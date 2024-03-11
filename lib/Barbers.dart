import 'package:flutter/material.dart';

class Barbers extends StatefulWidget {
  const Barbers({Key? key}) : super(key: key);

  @override
  State<Barbers> createState() => _BarbersState();
}

class _BarbersState extends State<Barbers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barbers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to our Barber Salon!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Our Barbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // List of barbers
            _buildBarberList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarberList() {
    // You can replace this with actual data from your backend or a hardcoded list
    List<String> barbers = ['Barber 1', 'Barber 2', 'Barber 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: barbers.map((barber) {
        return ListTile(
          title: Text(barber),
          // Add more details like working hours, ratings, etc. if needed
        );
      }).toList(),
    );
  }
}
