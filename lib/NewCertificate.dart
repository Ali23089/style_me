import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_me/identitty.dart';

class Certificate extends StatefulWidget {
  const Certificate({Key? key}) : super(key: key);

  @override
  State<Certificate> createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  File? _certificateImage;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _certificateImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_certificateImage == null) return;

    try {
      // Get the currently logged-in user's email
      String? email = FirebaseAuth.instance.currentUser!.email;

      // Create a reference to the location you want to upload to in Firebase Storage
      String fileName =
          'certificate_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Salon Certificates/$fileName');

      // Upload the file to Firebase Storage
      await storageReference.putFile(_certificateImage!);

      // Get the download URL of the uploaded file
      String downloadURL = await storageReference.getDownloadURL();

      // Update the certificate image URL in Firestore
      await FirebaseFirestore.instance
          .collection('Salons')
          .doc(email)
          .update({'certificateImageUrl': downloadURL});
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      // Handle error uploading image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate'),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Upload your License/Certificate',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _certificateImage != null
                              ? Image.file(
                                  _certificateImage!,
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.add_a_photo,
                                  size: 100,
                                  color: Color.fromARGB(255, 6, 35, 28),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _getImage,
                    child: Text('Select Image'),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the function to upload the image to Firebase
                        _uploadImageToFirebase();

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CNIC()),
                        );
                      },
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
