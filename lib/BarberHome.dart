import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BarberScreen extends StatefulWidget {
  const BarberScreen({Key? key}) : super(key: key);

  @override
  _BarberScreenState createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  File? _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> _services = [];
  List<String> _availableCategories = [
    'Men\'s Haircut',
    'Women\'s Haircut',
    'Shave',
    'Beard Trim',
    'Hair Color',
    'Facial',
    'Manicure',
    'Pedicure',
    'Massage',
    'Makeup',
    'Waxing',
  ];
  String? _selectedCategory;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void addService() {
    setState(() {
      _services.add({
        'category': _selectedCategory!,
        'description': _descriptionController.text,
        'price': _priceController.text,
      });
      _descriptionController.clear();
      _priceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Barber Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: _image != null
                    ? Image.file(
                        _image!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : _buildUploadButton(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text(
                  'Select Service Category',
                  style: TextStyle(color: Colors.black),
                ),
                items: _availableCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child:
                        Text(category, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 4, 172, 163),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter Price',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: addService,
                child:
                    Text('Add Service', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Services Added:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Category: ${_services[index]['category']}',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${_services[index]['description']}',
                            style: TextStyle(color: Colors.white)),
                        Text('Price Portion: ${_services[index]['price']}',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Salon details saved.');
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      onPressed: getImage,
      icon: Icon(Icons.cloud_upload),
      label: Text('Upload Image', style: TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
