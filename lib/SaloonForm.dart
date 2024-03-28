import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_me/NewCertificate.dart';

class SalonForm extends StatefulWidget {
  const SalonForm({Key? key}) : super(key: key);

  @override
  State<SalonForm> createState() => _SalonFormState();
}

class _SalonFormState extends State<SalonForm> {
  final ImagePicker _imagePicker = ImagePicker(); // Initialize ImagePicker here
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

  Future<void> _registerSalon() async {
    try {
      // Get the currently logged-in user's email
      String? email = FirebaseAuth.instance.currentUser!.email;

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToFirebase(email!);

      // Store salon information in Firestore
      await FirebaseFirestore.instance.collection('Salons').add({
        'salonName': salonNameController.text,
        'salonAddress': salonAddressController.text,
        'salonContact': salonContactController.text,
        'category': _selectedCategory,
        'email': email, // Add currently registered email to salon document
        'salonImageUrl': imageUrl, // Add salon image URL to salon document
      });

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Certificate()),
      );
    } catch (e) {
      print('Error registering salon: $e');
      // Handle registration error
    }
  }

  Future<String> _uploadImageToFirebase(String email) async {
    if (_imageFile == null) return "";

    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      String fileName = 'profile_$email.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Salon Profile/$fileName');

      // Upload the file to Firebase Storage
      await storageReference.putFile(_imageFile!);

      // Get the download URL of the uploaded file
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      // Handle error uploading image
      return "";
    }
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
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    )
                                  : null,
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 79,
                              //    bottom: 10,
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
                      labelText: 'SalonName',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    controller: salonAddressController,
                    decoration: InputDecoration(
                      labelText: 'Salon Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    controller: salonContactController,
                    decoration: InputDecoration(
                      labelText: 'Salon contact',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
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
                      onPressed: _registerSalon,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 13, 106, 101)),
                        fixedSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: Text(
                        'Next',
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
