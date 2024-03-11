import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_me/SaloonForm.dart';

class BarberForm extends StatefulWidget {
  const BarberForm({Key? key}) : super(key: key);

  @override
  State<BarberForm> createState() => _BarberFormState();
}

class _BarberFormState extends State<BarberForm> {
  final ImagePicker _imagePicker = ImagePicker(); // Initialize ImagePicker here
  File? _imageFile;
  String? _selectedGender;

  Future<void> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Barber Form'),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Enter Barber Basic Info',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                              child: _imageFile == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 38,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    )
                                  : null,
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 79,
                              //    bottom: 10,
                              child: Text(
                                'Profile',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 28),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    hint: Text('Select Gender'),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    items: ['Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SalonForm()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 13, 106, 101)),
                        fixedSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
