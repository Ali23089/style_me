import 'package:flutter/material.dart';
import 'package:style_me/BarberHome.dart';
import 'package:style_me/SalonScreen.dart';

class CNIC extends StatefulWidget {
  const CNIC({Key? key}) : super(key: key);

  @override
  State<CNIC> createState() => _CNICState();
}

class _CNICState extends State<CNIC> {
  String? _certificateImage;
  String? _secondImage;

  void _getImage() {
    setState(() {
      _certificateImage = "assets/certificate.png";
    });
  }

  void _getSecondImage() {
    setState(() {
      _secondImage = "assets/second_image.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate'),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Upload your Identity Card Image',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Upload Front side',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: _certificateImage != null
                          ? Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                _certificateImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color.fromARGB(255, 6, 35, 28),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Upload Back image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _getSecondImage,
                      child: _secondImage != null
                          ? Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                _secondImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color.fromARGB(255, 6, 35, 28),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarberScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 13, 106, 101)),
                        fixedSize: MaterialStateProperty.all(Size(200, 50)),
                      ),
                      child: Text(
                        'Submit',
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
