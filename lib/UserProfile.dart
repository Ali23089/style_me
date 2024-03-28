import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> userData = {};
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String newName = '';
  String newPhoneNumber = '';
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('Email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          setState(() {
            userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
          });
        } else {
          print('User not found');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('Email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          String userId = userSnapshot.docs.first.id;
          Map<String, dynamic> updatedData = {};
          if (newName.isNotEmpty) {
            updatedData['Name'] = newName;
          }
          if (_imageFile != null) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
            UploadTask uploadTask = ref.putFile(_imageFile!);
            String downloadURL = await (await uploadTask).ref.getDownloadURL();
            updatedData['profileImageUrl'] = downloadURL;
          }
          if (newPhoneNumber.isNotEmpty) {
            updatedData['PhoneNumber'] = newPhoneNumber;
          }
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .update(updatedData);
          setState(() {
            userData = {...userData, ...updatedData};
            isEditMode = false; // After updating, switch back to view mode
          });
        }
      }
    } catch (e) {
      print('Error updating user data: $e');
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
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              // Add navigation to settings page
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (userData['profileImageUrl'] != null
                            ? NetworkImage(userData['profileImageUrl'])
                            : AssetImage('assets/placeholder_image.jpg')
                                as ImageProvider),
                  ),
                  if (isEditMode)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${userData['Name'] ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${userData['Email'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: ${userData['PhoneNumber'] ?? 'Unknown'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditMode = true; // Switch to edit mode
                  });
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Visibility(
              visible: isEditMode,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: userData['Name'],
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) => setState(() => newName = value),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Change Profile Photo'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: userData['PhoneNumber'],
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) =>
                          setState(() => newPhoneNumber = value),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _updateUserData();
                      },
                      child: Text(
                        'Save Changes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
