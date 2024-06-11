import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:style_me/Edit_Baber.dart';

class BarberDetails extends StatefulWidget {
  @override
  _BarberDetailsState createState() => _BarberDetailsState();
}

class _BarberDetailsState extends State<BarberDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? barberData;
  Map<String, dynamic>? salonData;
  bool isLoading = true;
  bool isEditMode = false;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String newName = '';
  String newPhoneNumber = '';
  String newSalonName = '';
  String newSalonContact = '';

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    User? currentUser = _auth.currentUser;
    print('Current user: ${currentUser?.email}');
    if (currentUser != null && currentUser.email != null) {
      try {
        // Fetch barber details
        QuerySnapshot barberSnapshot = await FirebaseFirestore.instance
            .collection('Barber')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (barberSnapshot.docs.isNotEmpty) {
          setState(() {
            barberData =
                barberSnapshot.docs.first.data() as Map<String, dynamic>?;
          });
        } else {
          print('No details found for this barber.');
        }

        // Fetch salon details
        QuerySnapshot salonSnapshot = await FirebaseFirestore.instance
            .collection('Salons')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (salonSnapshot.docs.isNotEmpty) {
          var salonDetails =
              salonSnapshot.docs.first.data() as Map<String, dynamic>?;
          if (salonDetails != null &&
              salonDetails.containsKey('latitude') &&
              salonDetails.containsKey('longitude')) {
            String address = await _getAddressFromCoordinates(
              salonDetails['latitude'],
              salonDetails['longitude'],
            );
            salonDetails['salonAddress'] =
                address; // Replace latitude and longitude with the address
          }

          setState(() {
            salonData = salonDetails;
          });
        } else {
          print('No details found for this salon.');
        }

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('Error fetching details: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('User is not signed in');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Unknown Address";
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      return "Unknown Address";
    }
  }

  Future<void> _updateBarberData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email != null) {
        QuerySnapshot barberSnapshot = await FirebaseFirestore.instance
            .collection('Barber')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (barberSnapshot.docs.isNotEmpty) {
          String docId = barberSnapshot.docs.first.id;
          Map<String, dynamic> updatedData = {};
          if (newName.isNotEmpty) {
            updatedData['name'] = newName;
          }
          if (_imageFile != null) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'barber_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
            UploadTask uploadTask = ref.putFile(_imageFile!);
            String downloadURL = await (await uploadTask).ref.getDownloadURL();
            updatedData['profileImageUrl'] = downloadURL;
          }
          if (newPhoneNumber.isNotEmpty) {
            updatedData['phoneNumber'] = newPhoneNumber;
          }
          await FirebaseFirestore.instance
              .collection('Barber')
              .doc(docId)
              .update(updatedData);
          setState(() {
            barberData = {...barberData!, ...updatedData};
            isEditMode = false;
          });
        }
      }
    } catch (e) {
      print('Error updating barber data: $e');
    }
  }

  Future<void> _updateSalonData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email != null) {
        QuerySnapshot salonSnapshot = await FirebaseFirestore.instance
            .collection('Salons')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (salonSnapshot.docs.isNotEmpty) {
          String docId = salonSnapshot.docs.first.id;
          Map<String, dynamic> updatedData = {};
          if (newSalonName.isNotEmpty) {
            updatedData['salonName'] = newSalonName;
          }
          if (newSalonContact.isNotEmpty) {
            updatedData['salonContact'] = newSalonContact;
          }
          await FirebaseFirestore.instance
              .collection('Salons')
              .doc(docId)
              .update(updatedData);
          setState(() {
            salonData = {...salonData!, ...updatedData};
            isEditMode = false;
          });
        }
      }
    } catch (e) {
      print('Error updating salon data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            //  bottomLeft: Radius.circular(20),
                            // bottomRight: Radius.circular(20),
                            ),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: salonData?['salonImageUrl'] != null
                                  ? NetworkImage(salonData!['salonImageUrl'])
                                  : AssetImage('assets/placeholder_image.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 180,
                        left: MediaQuery.of(context).size.width / 2 - 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              barberData?['profileImageUrl'] != null
                                  ? NetworkImage(barberData!['profileImageUrl'])
                                  : AssetImage('assets/placeholder_image.png')
                                      as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          barberData?['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          barberData?['email'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileField(
                            value: barberData?['phoneNumber'] ?? 'Unknown',
                            icon: Icons.phone),
                        SizedBox(
                          height: 10,
                        ),
                        ProfileField(
                            value: salonData?['salonName'] ?? 'Unknown',
                            icon: Icons.store),
                        SizedBox(
                          height: 10,
                        ),
                        ProfileField(
                            value: salonData?['salonAddress'] ?? 'Unknown',
                            icon: Icons.location_on),
                        SizedBox(
                          height: 10,
                        ),
                        ProfileField(
                            value: salonData?['category'] ?? 'Unknown',
                            icon: Icons.category),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBarberDetails(
                barberData: barberData!,
                salonData: salonData!,
              ),
            ),
          ).then((_) => fetchDetails()); // Fetch details again after editing
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String value;
  final IconData icon;

  ProfileField({required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color.fromARGB(255, 13, 106, 101),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
