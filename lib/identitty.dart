import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:style_me/BarberHome.dart';
import 'package:style_me/SalonScreen.dart';

class CNIC extends StatefulWidget {
  const CNIC({Key? key}) : super(key: key);

  @override
  State<CNIC> createState() => _CNICState();
}

class _CNICState extends State<CNIC> {
  File? _frontImage;
  File? _backImage;

  Future<void> _getFrontImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _frontImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getBackImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _backImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImagesToFirebase() async {
    try {
      // Upload front image
      if (_frontImage != null) {
        String frontFileName =
            'front_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference frontStorageReference =
            FirebaseStorage.instance.ref().child('CNIC_images/$frontFileName');
        await frontStorageReference.putFile(_frontImage!);
      }

      // Upload back image
      if (_backImage != null) {
        String backFileName =
            'back_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference backStorageReference =
            FirebaseStorage.instance.ref().child('CNIC_images/$backFileName');
        await backStorageReference.putFile(_backImage!);
      }
    } catch (e) {
      print('Error uploading images to Firebase Storage: $e');
      // Handle error uploading images
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
                    'Upload your Identity Card Image',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Upload Front side',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _getFrontImage,
                      child: _frontImage != null
                          ? Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.file(
                                _frontImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color.fromARGB(255, 6, 35, 28),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Upload Back image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _getBackImage,
                      child: _backImage != null
                          ? Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.file(
                                _backImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color.fromARGB(255, 6, 35, 28),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _uploadImagesToFirebase();
                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalonScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 13, 106, 101)),
                        fixedSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: Text(
                        'Submit',
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
