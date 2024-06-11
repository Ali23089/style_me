import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditServiceScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final String serviceId;

  EditServiceScreen({required this.service, required this.serviceId});

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.service['productName']);
    _descriptionController =
        TextEditingController(text: widget.service['description']);
    _priceController = TextEditingController(text: widget.service['price']);
    _categoryController =
        TextEditingController(text: widget.service['category']);
    _imageUrl = widget.service['imageUrl'];
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('service_images/${widget.serviceId}.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> _updateService() async {
    String? imageUrl = _imageUrl;

    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    await FirebaseFirestore.instance
        .collection('services')
        .doc(widget.serviceId)
        .update({
      'productName': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category': _categoryController.text,
      'imageUrl': imageUrl,
    });

    Navigator.pop(
        context, true); // Return true to indicate the service was updated
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Service',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imageFile != null)
                Image.file(_imageFile!,
                    height: 200, width: double.infinity, fit: BoxFit.cover)
              else if (_imageUrl != null)
                Image.network(_imageUrl!,
                    height: 200, width: double.infinity, fit: BoxFit.cover)
              else
                Image.asset('assets/placeholder_image.png',
                    height: 200, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Change Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Update Service',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
