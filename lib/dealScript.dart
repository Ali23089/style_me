import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderSummaryScreen extends StatelessWidget {
  final String userEmail;

  OrderSummaryScreen({required this.userEmail});

  Future<Map<String, dynamic>> fetchBookingDetails() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('dealsbooking')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      throw Exception('Booking details not found');
    }
  }

  Future<String> fetchSalonName(String barberEmail) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Salons')
        .where('email', isEqualTo: barberEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['salonName'];
    } else {
      throw Exception('Salon not found');
    }
  }

  Future<String> fetchUserName(String userEmail) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Email', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['Name'];
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBookingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var booking = snapshot.data!;
            return FutureBuilder<List<String>>(
              future: Future.wait([
                fetchSalonName(booking['barberEmail']),
                fetchUserName(userEmail),
              ]),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (userSnapshot.hasData) {
                  var salonName = userSnapshot.data![0];
                  var userName = userSnapshot.data![1];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Booking Details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 13, 106, 101),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              buildDetailRow(
                                  'User Name', userName, Icons.person),
                              buildDetailRow(
                                  'Salon Name', salonName, Icons.store),
                              buildDetailRow('Deal Title', booking['dealTitle'],
                                  Icons.title),
                              buildDetailRow('Payment Method',
                                  booking['paymentMethod'], Icons.payment),
                              buildDetailRow('Description',
                                  booking['description'], Icons.description),
                              buildDetailRow(
                                  'Valid From',
                                  DateFormat.yMMMd()
                                      .format(booking['validFrom'].toDate()),
                                  Icons.date_range),
                              buildDetailRow(
                                  'Valid To',
                                  DateFormat.yMMMd()
                                      .format(booking['validTo'].toDate()),
                                  Icons.date_range),
                              buildDetailRow(
                                  'Original Price',
                                  'PKR ${booking['originalPrice']}',
                                  Icons.money),
                              buildDetailRow(
                                  'Discounted Price',
                                  'PKR ${booking['discountedPrice']}',
                                  Icons.money_off),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No booking details found'));
                }
              },
            );
          } else {
            return Center(child: Text('No booking details found'));
          }
        },
      ),
    );
  }

  Widget buildDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 13, 106, 101)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 13, 106, 101),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
