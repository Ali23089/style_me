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
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
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
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (userData['profileImageUrl'] != null
                            ? NetworkImage(userData['profileImageUrl'])
                            : AssetImage('assets/placeholder_image.png')
                                as ImageProvider),
                  ),
                  if (isEditMode)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 28),
                        color: Color.fromARGB(255, 13, 106, 101),
                        onPressed: _pickImage,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.person,
                          color: Color.fromARGB(255, 13, 106, 101)),
                      SizedBox(width: 10),
                      Text(
                        '${userData['Name'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 106, 101),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email,
                          color: Color.fromARGB(255, 13, 106, 101)),
                      SizedBox(width: 10),
                      Text(
                        '${userData['Email'] ?? 'Unknown'}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          color: Color.fromARGB(255, 13, 106, 101)),
                      SizedBox(width: 10),
                      Text(
                        'Phone: ${userData['PhoneNumber'] ?? 'Unknown'}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                ),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 106, 101),
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() => newName = value),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 13, 106, 101),
                      ),
                      onPressed: _pickImage,
                      child: Text(
                        'Change Profile Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: userData['PhoneNumber'],
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 13, 106, 101),
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          setState(() => newPhoneNumber = value),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 13, 106, 101),
                      ),
                      onPressed: () {
                        _updateUserData();
                      },
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
