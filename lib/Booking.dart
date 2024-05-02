import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Here you would fetch the bookings for the logged-in user
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings() async {
    User? user = _auth.currentUser;
    List<Map<String, dynamic>> bookingsList = [];

    if (user != null) {
      try {
        // Query the 'Bookings' collection for documents where 'serviceDetails.serviceId' matches the current user's ID
        QuerySnapshot querySnapshot = await _db
            .collection('Bookings')
            .where('serviceDetails.serviceId',
                isEqualTo: user.uid) // Corrected field path
            .get();

        // Add each booking to a list
        for (var doc in querySnapshot.docs) {
          bookingsList.add({
            'date': doc.get('date'), // Safe access using the get method
            'salonName': doc.get('serviceDetails')[
                'salonName'], // Safe access using the get method
            'serviceName': doc.get('serviceDetails')[
                'serviceName'], // Safe access using the get method
            'servicePrice': doc.get('serviceDetails')[
                'servicePrice'], // Safe access using the get method
            'serviceType':
                doc.get('serviceType'), // Safe access using the get method
            'time': doc.get('time'), // Safe access using the get method
          });
        }
      } catch (e) {
        print('Error fetching bookings: $e');
      }
    } else {
      print('User not logged in');
    }

    return bookingsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          // Create a list view of the bookings
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data![index];
              return ListTile(
                title: Text(booking['salonName'] ?? 'No Salon Name'),
                subtitle: Text(
                    '${booking['serviceName']} at ${booking['time']} on ${booking['date']}'),
                trailing: Text('\$${booking['servicePrice']}'),
              );
            },
          );
        },
      ),
    );
  }
}
