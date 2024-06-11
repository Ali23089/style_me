import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  File? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController =
      TextEditingController(); // For deal discount

  void _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
    }
  }

  void addService() async {
    String? email = _auth.currentUser?.email;
    if (email == null) {
      // Handle user not authenticated
      return;
    }

    String imageUrl = "";
    if (_image != null) {
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final ref = _storage
          .ref()
          .child('service_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(_image!, metadata);
      final snapshot = await uploadTask.whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    try {
      await _firestore.collection('services').add({
        'barberEmail': email,
        'productName': _productNameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'imageUrl': imageUrl,
      });
      setState(() {
        _productNameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _image = null;
      });
    } catch (e) {
      print("Error adding service: $e");
    }
  }

  void addDeal() async {
    String? email = _auth.currentUser?.email;
    if (email == null) {
      return;
    }

    String imageUrl = "";
    if (_image != null) {
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final ref = _storage
          .ref()
          .child('deal_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(_image!, metadata);
      final snapshot = await uploadTask.whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    try {
      await _firestore.collection('deals').add({
        'salonEmail': email,
        'dealName': _productNameController.text,
        'price': _priceController.text,
        'discount': _discountController.text,
        'imageUrl': imageUrl,
      });
      setState(() {
        _productNameController.clear();
        _priceController.clear();
        _discountController.clear();
        _image = null;
      });
    } catch (e) {
      print("Error adding deal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service or Deal'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: 90,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 38,
                          color: Colors.black,
                        ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Product Name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter Price (PKR)',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Discount Percentage',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addService,
                child: Text('Add Service'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: addDeal,
                child: Text('Add offer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
