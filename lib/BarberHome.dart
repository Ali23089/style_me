import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:style_me/BaberProfile.dart';

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
  bool _isFABOpen = false;
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
    fetchServices();
  }

  void fetchBookings() async {
    final barberEmail = FirebaseAuth.instance.currentUser?.email;
    if (barberEmail == null) {
      print('No barber logged in');
      return;
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberEmail', isEqualTo: barberEmail)
        .get();

    if (mounted) {
      setState(() {
        bookings = snapshot.docs
            .map((doc) => {
                  'bookingId': doc.id,
                  'userId': doc['userId'],
                  'serviceId': doc['serviceId'],
                  'status': doc['status']
                })
            .toList();
      });
    }
  }

  void fetchServices() async {
    final barberEmail = FirebaseAuth.instance.currentUser?.email;
    if (barberEmail == null) {
      print('No barber logged in');
      return;
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('barberEmail', isEqualTo: barberEmail)
        .get();

    if (mounted) {
      setState(() {
        services = snapshot.docs
            .map((doc) => {
                  'serviceName': doc[
                      'productName'], // Assuming field name in Firestore is 'productName'
                  'description': doc['description'],
                  'price':
                      doc['price'].toString() // Ensuring 'price' is a string
                })
            .toList();
      });
    }
  }

  void fetchAppointments() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print('No user logged in');
      return;
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (mounted) {
      setState(() {
        bookings = snapshot.docs
            .map((doc) => {
                  'appointmentId': doc.id,
                  'date': doc['date'], // Fetching the date
                  'time': doc['time'], // Fetching the time
                  'salonName': doc['salonName'], // Fetching the salon name
                  'serviceName': doc['serviceDetails']
                      ['serviceName'], // Accessing nested data
                  'servicePrice': doc['serviceDetails']
                      ['servicePrice'], // Accessing nested data
                })
            .toList();
      });
    }
  }

  void updateBookingStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});

    if (mounted) {
      fetchBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text('Barber Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BarberProfileScreen()), // Navigate to HomeScreen
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text(
                'Home Service:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _isHomeServiceEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isHomeServiceEnabled = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
            if (bookings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No appointments scheduled.",
                    style: TextStyle(color: Colors.white)),
              ),
            if (bookings.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final appointment = bookings[index];
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.event, color: Colors.black),
                      title: Text(
                        appointment['serviceType'] ??
                            'Service Type Unspecified',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Date & Time: ${appointment['dateTime'] ?? 'Date Unspecified'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text('My Services:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            ),
            if (services.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No services added yet.",
                    style: TextStyle(color: Colors.white)),
              ),
            if (services.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.content_cut,
                          color: Colors.black), // Example icon
                      title: Text(
                        service['serviceName'] ?? 'Unnamed Service',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '${service['description'] ?? 'No description provided'} - Price: ${service['price'] ?? '0'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          // Add your code for editing the service
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isFABOpen)
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddServiceScreen()),
              );
            },
            icon: Icon(Icons.add),
            label: Text("Add Service"),
            backgroundColor: Colors.green,
          ),
        if (_isFABOpen) SizedBox(height: 10),
        if (_isFABOpen)
          FloatingActionButton.extended(
            heroTag: "fab1", // Unique tag
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddDealScreen()), // Adjust this if different screen for deals
              );
            },
            icon: Icon(Icons.local_offer),
            label: Text("Add Deal"),
            backgroundColor: Colors.blue,
          ),
        if (_isFABOpen) SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "fab2", // Unique tag
          onPressed: () {
            setState(() {
              _isFABOpen = !_isFABOpen;
            });
          },
          child: Icon(_isFABOpen ? Icons.close : Icons.add),
          backgroundColor: Colors.yellow,
        ),
      ],
    );
  }
}

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

class AddDealScreen extends StatefulWidget {
  @override
  _AddDealScreenState createState() => _AddDealScreenState();
}

class _AddDealScreenState extends State<AddDealScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<String> _selectedServices = [];
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('services').get();
      setState(() {
        _services = snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList();
      });
    } catch (e) {
      print("Failed to fetch services: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image was selected.')));
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image for the deal')));
      return;
    }
    try {
      final imageUrl = await _uploadImage();
      await FirebaseFirestore.instance.collection('deals').add({
        'name': _nameController.text,
        'imageUrl': imageUrl,
        'serviceIds': _selectedServices
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding deal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Deal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  ),
                  alignment: Alignment.center,
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 50)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Deal Name'),
              ),
              Text('Select Services:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                children: _services.map((service) {
                  return ChoiceChip(
                    label: Text(service['name']),
                    selected: _selectedServices.contains(service['id']),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedServices.add(service['id']);
                        } else {
                          _selectedServices.remove(service['id']);
                        }
                      });
                    },
                  );
                }).toList(),
                spacing: 8.0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDeal,
                child: Text('Add Deal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
