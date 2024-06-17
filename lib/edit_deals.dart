import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditDealScreen extends StatefulWidget {
  final Map<String, dynamic> deal;
  final String dealId;

  EditDealScreen({required this.deal, required this.dealId});

  @override
  _EditDealScreenState createState() => _EditDealScreenState();
}

class _EditDealScreenState extends State<EditDealScreen> {
  late TextEditingController _titleController;
  late TextEditingController _originalPriceController;
  late TextEditingController _discountedPriceController;
  late List<TextEditingController> _descriptionControllers;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.deal['title']);
    _originalPriceController =
        TextEditingController(text: widget.deal['originalPrice'].toString());
    _discountedPriceController =
        TextEditingController(text: widget.deal['discountedPrice'].toString());
    _imageUrl = widget.deal['imageUrl'];
    _descriptionControllers =
        (widget.deal['description'] as String).split(', ').map((description) {
      return TextEditingController(text: description);
    }).toList();
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
        .child('deal_images/${widget.dealId}.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> _updateDeal() async {
    String? imageUrl = _imageUrl;

    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    String description =
        _descriptionControllers.map((controller) => controller.text).join(", ");

    try {
      print('Updating document with ID: ${widget.dealId}');
      await FirebaseFirestore.instance
          .collection('SalonsDeals')
          .doc(widget.dealId)
          .update({
        'title': _titleController.text,
        'description': description,
        'originalPrice': double.parse(_originalPriceController.text),
        'discountedPrice': double.parse(_discountedPriceController.text),
        'imageUrl': imageUrl,
      });
      print('Document updated successfully');
      Navigator.pop(
          context, true); // Return true to indicate the deal was updated
    } catch (e) {
      print('Error updating document: $e');
      _showSnackBar('Error updating deal: $e');
    }
  }

  void _addDescriptionPoint() {
    if (_descriptionControllers.length < 8) {
      setState(() {
        _descriptionControllers.add(TextEditingController());
      });
    }
  }

  void _removeDescriptionPoint(int index) {
    if (_descriptionControllers.length > 2) {
      setState(() {
        _descriptionControllers.removeAt(index);
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed, // Set the behavior to fixed
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _descriptionControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Deal',
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
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Deal Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Description Points:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _descriptionControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _descriptionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Point ${index + 1}',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            _removeDescriptionPoint(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: _descriptionControllers.length < 8
                    ? _addDescriptionPoint
                    : null,
                child: Text('Add Point'),
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _originalPriceController,
                decoration: InputDecoration(
                  labelText: 'Original Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _discountedPriceController,
                decoration: InputDecoration(
                  labelText: 'Discounted Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Update Deal',
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
