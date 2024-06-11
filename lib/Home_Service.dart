import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_me/Confirmation.dart';

class HomeServiceFormScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  final String locationName;

  HomeServiceFormScreen(
      {required this.bookingDetails, required this.locationName});

  @override
  _HomeServiceFormScreenState createState() => _HomeServiceFormScreenState();
}

class _HomeServiceFormScreenState extends State<HomeServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _locationController = TextEditingController();
  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.locationName;
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _contactNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
      userName = user?.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Service Details',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/HOME1.png',
                    height: 200,
                  ),
                  SizedBox(height: 15), // Spacing between logo and text field
                  _buildTextField(_addressController, 'Address',
                      'Please enter your address'),
                  SizedBox(height: 24), // Increased spacing between fields
                  _buildTextField(_contactNumberController, 'Contact Number',
                      'Please enter your contact number',
                      keyboardType: TextInputType.phone),
                  SizedBox(height: 24), // Increased spacing between fields
                  _buildTextField(_locationController, 'Location',
                      'Please enter your location',
                      editable: true),
                  SizedBox(height: 24), // Increased spacing between fields
                  if (userEmail != null)
                    _buildReadOnlyField('Email', userEmail!),
                  if (userName != null) _buildReadOnlyField('Name', userName!),
                  SizedBox(
                      height: 40), // Increased spacing before the submit button
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String validationMessage,
      {TextInputType keyboardType = TextInputType.text,
      bool editable = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.montserrat(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: editable
            ? IconButton(
                icon: Icon(Icons.edit, color: Colors.teal),
                onPressed: () {
                  // Optionally, add edit functionality here
                },
              )
            : null,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      style: GoogleFonts.montserrat(),
    );
  }

  Widget _buildReadOnlyField(String labelText, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.montserrat(color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        initialValue: value,
        readOnly: true,
        style: GoogleFonts.montserrat(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 13, 106, 101),
            Color.fromARGB(255, 13, 106, 101)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _completeBooking();
          }
        },
        child: Text('Submit',
            style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ), // Ensures the button background is transparent to show the gradient
          shadowColor:
              Colors.transparent, // Ensures no additional shadow is added
        ),
      ),
    );
  }

  void _completeBooking() async {
    widget.bookingDetails['homeServiceDetails'] = {
      'address': _addressController.text,
      'contactNumber': _contactNumberController.text,
      'locationName': _locationController.text,
      'userEmail': userEmail,
      'userName': userName,
    };

    await FirebaseFirestore.instance
        .collection('Bookings')
        .add(widget.bookingDetails);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            BookingConfirmationScreen(bookingDetails: widget.bookingDetails),
      ),
    );
  }
}
