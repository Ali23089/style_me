import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'NewCertificate.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _pickedLocation;
  Completer<GoogleMapController> _controller = Completer();

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(31.588948, 74.421324),
          zoom: 16,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation!,
                ),
              },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _pickedLocation == null
            ? null
            : () {
                Navigator.of(context).pop(_pickedLocation);
              },
      ),
    );
  }
}

class SalonForm extends StatefulWidget {
  const SalonForm({Key? key}) : super(key: key);

  @override
  State<SalonForm> createState() => _SalonFormState();
}

class _SalonFormState extends State<SalonForm> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  String? _selectedCategory;
  final salonNameController = TextEditingController();
  final salonAddressController = TextEditingController();
  final salonContactController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _registerSalon(LatLng location) async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;

      String imageUrl = await _uploadImageToFirebase(email!);

      await FirebaseFirestore.instance.collection('Salons').add({
        'salonName': salonNameController.text,
        'salonAddress': salonAddressController.text,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'salonContact': salonContactController.text,
        'category': _selectedCategory,
        'email': email,
        'salonImageUrl': imageUrl,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Certificate()));
    } catch (e) {
      print('Error registering salon: $e');
    }
  }

  Future<String> _uploadImageToFirebase(String email) async {
    if (_imageFile == null) return "";

    String fileName = 'profile_$email.jpg';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Salon Profile/$fileName');

    await storageReference.putFile(_imageFile!);
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Salon Form'),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Enter Salon Info',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                              child: _imageFile == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 38,
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 79,
                              child: Text(
                                'Salon image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: salonNameController,
                    decoration: InputDecoration(
                      labelText: 'Salon Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    controller: salonAddressController,
                    readOnly: true, // Make it read-only
                    decoration: InputDecoration(
                      labelText: 'Salon Address',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      var location = await Navigator.push<LatLng>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPicker(),
                        ),
                      );
                      if (location != null) {
                        salonAddressController.text =
                            "Lat: ${location.latitude}, Long: ${location.longitude}";
                      }
                    },
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    controller: salonContactController,
                    decoration: InputDecoration(
                      labelText: 'Salon Contact',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text('Select Category'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    items: [
                      'For Gents',
                      'For Ladies',
                      'Unisex',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (salonAddressController.text.startsWith("Lat:")) {
                          List<String> parts =
                              salonAddressController.text.split(', ');
                          double lat = double.parse(parts[0].split(": ")[1]);
                          double lng = double.parse(parts[1].split(": ")[1]);
                          await _registerSalon(LatLng(lat, lng));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 13, 106, 101)),
                        fixedSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: Text(
                        'Register Salon',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
