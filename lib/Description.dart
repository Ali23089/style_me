import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  const Description({Key? key}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your salon image or banner
            Image.network(
              'https://img.freepik.com/premium-photo/salon-with-mirror-wall-hair-salon-chair_732812-843.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Add salon details like name, address, etc.
            Text(
              'Salon Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Address: 123 Salon Street, City',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            // Add a description of the salon
            Text(
              'Welcome to our amazing salon! We offer a wide range of services...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            // Add other details or features of the salon
            Text(
              'Services:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '- Haircut\n- Hair Color\n- Manicure\n- Pedicure',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
