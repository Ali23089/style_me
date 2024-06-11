import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditBarberDetails extends StatefulWidget {
  final Map<String, dynamic> barberData;
  final Map<String, dynamic> salonData;

  EditBarberDetails({required this.barberData, required this.salonData});

  @override
  _EditBarberDetailsState createState() => _EditBarberDetailsState();
}

class _EditBarberDetailsState extends State<EditBarberDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  late String newName;
  late String newPhoneNumber;
  late String newSalonName;
  late String newSalonContact;

  @override
  void initState() {
    super.initState();
    newName = widget.barberData['name'] ?? '';
    newPhoneNumber = widget.barberData['phoneNumber'] ?? '';
    newSalonName = widget.salonData['salonName'] ?? '';
    newSalonContact = widget.salonData['salonContact'] ?? '';
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picking error: $e");
    }
  }

  Future<void> _updateBarberData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email != null) {
        QuerySnapshot barberSnapshot = await FirebaseFirestore.instance
            .collection('Barber')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (barberSnapshot.docs.isNotEmpty) {
          String docId = barberSnapshot.docs.first.id;
          Map<String, dynamic> updatedData = {
            'name': newName,
            'phoneNumber': newPhoneNumber,
          };
          if (_imageFile != null) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'barber_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
            UploadTask uploadTask = ref.putFile(_imageFile!);
            String downloadURL = await (await uploadTask).ref.getDownloadURL();
            updatedData['profileImageUrl'] = downloadURL;
          }
          await FirebaseFirestore.instance
              .collection('Barber')
              .doc(docId)
              .update(updatedData);
        }
      }
    } catch (e) {
      print('Error updating barber data: $e');
    }
  }

  Future<void> _updateSalonData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.email != null) {
        QuerySnapshot salonSnapshot = await FirebaseFirestore.instance
            .collection('Salons')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (salonSnapshot.docs.isNotEmpty) {
          String docId = salonSnapshot.docs.first.id;
          Map<String, dynamic> updatedData = {
            'salonName': newSalonName,
            'salonContact': newSalonContact,
          };
          await FirebaseFirestore.instance
              .collection('Salons')
              .doc(docId)
              .update(updatedData);
        }
      }
    } catch (e) {
      print('Error updating salon data: $e');
    }
  }

  Future<void> _saveChanges() async {
    await _updateBarberData();
    await _updateSalonData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Barber Details'),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfileImage(),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Name',
              value: newName,
              onChanged: (value) => newName = value,
            ),
            _buildTextField(
              label: 'Phone Number',
              value: newPhoneNumber,
              onChanged: (value) => newPhoneNumber = value,
            ),
            _buildTextField(
              label: 'Salon Name',
              value: newSalonName,
              onChanged: (value) => newSalonName = value,
            ),
            _buildTextField(
              label: 'Salon Contact',
              value: newSalonContact,
              onChanged: (value) => newSalonContact = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 13, 106, 101),
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _imageFile == null
                ? (widget.barberData['profileImageUrl'] != null
                    ? NetworkImage(widget.barberData['profileImageUrl'])
                    : AssetImage('assets/placeholder_image.png')
                        as ImageProvider)
                : FileImage(_imageFile!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _pickImage,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: value),
      ),
    );
  }
}
