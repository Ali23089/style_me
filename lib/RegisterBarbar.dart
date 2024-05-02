/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_me/LoginBarber.dart';

class BarberRegister extends StatefulWidget {
  const BarberRegister({Key? key}) : super(key: key);

  @override
  _BarberRegisterState createState() => _BarberRegisterState();
}

class _BarberRegisterState extends State<BarberRegister> {
  final SalonController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Initialize Firebase Storage
  File? _certificateImage;

  bool passToggle = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _certificateImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadImageToFirebase(File? imageFile) async {
    if (imageFile == null) return null;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      await _storage.ref('certificate_images/$fileName').putFile(imageFile);
      String downloadURL =
          await _storage.ref('certificate_images/$fileName').getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image. Please try again.'),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 35, 28),
                  Color.fromARGB(255, 4, 172, 163),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 80.0, left: 22),
              child: Text(
                'Hello Barber\nPlease-Sign Up!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 190.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: SalonController,
                              decoration: InputDecoration(
                                labelText: 'Salon Name',
                                prefixIcon: Icon(Icons.shop),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 35, 28),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Barber Name',
                                prefixIcon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 35, 28),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Barber Email',
                                prefixIcon: Icon(Icons.email),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 35, 28),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              obscureText: passToggle,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passToggle = !passToggle;
                                    });
                                  },
                                  icon: Icon(
                                    passToggle
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color.fromARGB(255, 6, 35, 28),
                                  ),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 35, 28),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: _getImage,
                              child: Container(
                                width: 300,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _certificateImage != null
                                    ? Image.file(
                                        _certificateImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Color.fromARGB(255, 6, 35, 28),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Upload Certificate Image',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 35, 28),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                String? imageUrl = await uploadImageToFirebase(
                                    _certificateImage);

                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );

                                  if (userCredential.user != null) {
                                    CollectionReference collRef =
                                        FirebaseFirestore.instance
                                            .collection('Barber');
                                    collRef.add({
                                      'SalonName': SalonController.text,
                                      'BarberName': nameController.text,
                                      'Email': emailController.text,
                                      'Password': passwordController.text,
                                      'CertificateImageUrl':
                                          imageUrl, // Store image URL in Firestore
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BarberLogin()),
                                    );
                                  }
                                } catch (e) {
                                  print('Error during registration: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Registration failed. Please try again.'),
                                    ),
                                  );
                                }
                                ;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: Colors.white, // Border color
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 6, 35, 28),
                                      Color.fromARGB(255, 4, 172, 163),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " Sign in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/