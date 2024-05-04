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

    setState(() {
      services = snapshot.docs
          .map((doc) => {
                'serviceName': doc[
                    'productName'], // Assuming field name in Firestore is 'productName'
                'description': doc['description'],
                'price': doc['price'].toString() // Ensuring 'price' is a string
              })
          .toList();
    });
  }

  void updateBookingStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});
    fetchBookings();
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
                child: Text("No bookings found.",
                    style: TextStyle(color: Colors.white)),
              ),
            if (bookings.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  return ListTile(
                    title: Text(
                      'Service ID: ${booking['serviceId']} - Status: ${booking['status']}',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateBookingStatus(
                            booking['bookingId'],
                            'confirmed',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateBookingStatus(
                            booking['bookingId'],
                            'declined',
                          ),
                        ),
                      ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddServiceScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
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
                  labelText: 'Enter Product/Deal Name',
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
                child: Text('Add Deal'),
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
