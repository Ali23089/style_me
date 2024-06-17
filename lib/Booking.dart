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
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings() async {
    User? user = _auth.currentUser;
    List<Map<String, dynamic>> bookingsList = [];

    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await _db
            .collection('Bookings')
            .where('userEmail', isEqualTo: user.email)
            .get();

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> serviceDetails = doc.get('serviceDetails') ?? {};
          bookingsList.add({
            'date': doc.get('date') ?? 'No date',
            'time': doc.get('time') ?? 'No time',
            'salonName': doc.get('salonName') ?? 'No Salon Name',
            'serviceType': doc.get('serviceType') ?? 'No Service Type',
            'serviceName': serviceDetails['serviceName'] ?? 'No Service Name',
            'servicePrice': serviceDetails['servicePrice'] ?? '0',
            'additionalInfo':
                serviceDetails['description'] ?? 'No additional info provided',
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
        title: Text(
          'Booking History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              var booking = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['salonName'],
                        style: TextStyle(
                          color: Color.fromARGB(255, 13, 106, 101),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${booking['serviceName']} (${booking['serviceType']})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 15),
                          SizedBox(width: 5),
                          Text(booking['date']),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 15),
                          SizedBox(width: 5),
                          Text(booking['time']),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.monetization_on, size: 15),
                          SizedBox(width: 5),
                          Text('\$${booking['servicePrice']}'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        booking['additionalInfo'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
