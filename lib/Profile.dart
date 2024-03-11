import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String barberId;

  ProfileScreen({required this.barberId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<DocumentSnapshot> barberStream;

  @override
  void initState() {
    super.initState();
    barberStream = FirebaseFirestore.instance
        .collection('Barber')
        .doc(widget.barberId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barber Profile'),
      ),
      body: StreamBuilder(
        stream: barberStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Barber not found'),
            );
          } else {
            // Barber data is available
            var barberData = snapshot.data!;
            String barberName = barberData['BarberName'];
            String salonName = barberData['SalonName'];
            String email = barberData['Email'];
            String imageUrl = barberData['CertificateImageUrl'];

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Barber Name: $barberName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Salon Name: $salonName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
