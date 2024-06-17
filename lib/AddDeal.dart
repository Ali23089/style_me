import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDealScreen extends StatefulWidget {
  final String? barberEmail;

  AddDealScreen({Key? key, this.barberEmail}) : super(key: key);

  @override
  _AddDealScreenState createState() => _AddDealScreenState();
}

class _AddDealScreenState extends State<AddDealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountedPriceController =
      TextEditingController();
  bool _isImagePickerActive = false;
  DateTime? _startDate;
  DateTime? _endDate;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<TextEditingController> _descriptionControllers = [
    TextEditingController(),
    TextEditingController()
  ];

  Future<void> _pickImage() async {
    if (_isImagePickerActive) return;
    _isImagePickerActive = true;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        _showSnackBar('No image was selected.');
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e');
    } finally {
      _isImagePickerActive = false;
    }
  }

  Future<String> _uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('deal_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = ref.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  void _addDeal() async {
    if (_image == null) {
      _showSnackBar('Please select an image for the deal');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String description =
        _descriptionControllers.map((controller) => controller.text).join(", ");

    try {
      final imageUrl = await _uploadImage();
      await FirebaseFirestore.instance.collection('SalonsDeals').add({
        'title': _titleController.text,
        'description': description,
        'originalPrice': double.parse(_originalPriceController.text),
        'discountedPrice': double.parse(_discountedPriceController.text),
        'startDate': _startDate,
        'endDate': _endDate,
        'imageUrl': imageUrl,
        'serviceIds': [],
        'barberEmail': widget.barberEmail,
      });
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Error adding deal: $e');
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
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 80.0, left: 20.0, right: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Deal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _image == null
                        ? Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[700])
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Deal Title',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
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
                            child: TextFormField(
                              controller: _descriptionControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Point ${index + 1}',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description point';
                                }
                                return null;
                              },
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
                SizedBox(height: 8),
                TextFormField(
                  controller: _originalPriceController,
                  decoration: InputDecoration(
                    labelText: 'Original Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _discountedPriceController,
                  decoration: InputDecoration(
                    labelText: 'Discounted Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null ||
                        double.parse(value) <= 0 ||
                        double.parse(value) >=
                            (double.tryParse(_originalPriceController.text) ??
                                0)) {
                      return 'Please enter a valid discounted price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addDeal,
                  child: Text(
                    'Add Deal',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 13, 106, 101),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
