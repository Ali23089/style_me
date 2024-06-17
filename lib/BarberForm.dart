import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:style_me/SaloonForm.dart';

class BarberForm extends StatefulWidget {
  const BarberForm({Key? key}) : super(key: key);

  @override
  State<BarberForm> createState() => _BarberFormState();
}

class _BarberFormState extends State<BarberForm> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerAndUploadData() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        String userId = userCredential.user!.uid;
        String imageUrl = await _uploadImageToFirebase(emailController.text);

        await FirebaseFirestore.instance.collection('Barber').doc(userId).set({
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'gender': _selectedGender,
          'profileImageUrl': imageUrl,
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SalonForm()));
      } catch (e) {
        print('Error registering user: $e');
      }
    }
  }

  Future<String> _uploadImageToFirebase(String email) async {
    if (_imageFile == null) return "";
    try {
      String fileName = 'profile_$email.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Barber Profile/$fileName');
      await storageReference.putFile(_imageFile!);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Barber Form'),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Enter Barber Basic Info',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: _getImage,
                        child: _buildProfileImage(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Name must contain only letters and spaces';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 28),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone number must contain only digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 28),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 28),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
                            .hasMatch(value)) {
                          return 'Password must contain at least one letter and one number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 28),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      hint: Text('Select Gender'),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _registerAndUploadData,
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
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(80),
      ),
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[200],
        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        child: _imageFile == null
            ? Icon(
                Icons.camera_alt,
                size: 38,
                color: Color.fromARGB(255, 0, 0, 0),
              )
            : null,
      ),
    );
  }
}
