import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Example data model for list items
class ListItem {
  final String title;
  final String subtitle;

  ListItem(this.title, this.subtitle);
}

class BarberScreen extends StatefulWidget {
  @override
  _BarberScreenState createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  bool _isHomeServiceEnabled = false;

  // Example list data
  final List<ListItem> items = [
    ListItem('Item 1', 'Description 1'),
    ListItem('Item 2', 'Description 2'),
    ListItem('Item 3', 'Description 3'),
    ListItem('Item 4', 'Description 4'),
    ListItem('Item 5', 'Description 5'),
  ];

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
              /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnotherScreen()),
              );*/
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Home Service:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        value: _isHomeServiceEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isHomeServiceEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // Add your other widgets here
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].title),
                  subtitle: Text(items[index].subtitle),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your floating action button functionality here
          // For example, navigate to AnotherScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddServiceScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
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
  TextEditingController _productNameController = TextEditingController();
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
        'productName': _productNameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
      });
      _productNameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _image != null
                    ? Image.file(
                        _image!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : ElevatedButton(
                        onPressed: getImage,
                        child: Text('Upload Image'),
                      ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Select Service Category'),
                items: _availableCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addService,
                child: Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
