import 'package:flutter/material.dart';

class BookingReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  BookingReceiptScreen({required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Receipt',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
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
                      'User Email', bookingDetails['userEmail'], Icons.email),
                  buildDetailRow('Deal Title',
                      bookingDetails['serviceDetails']['title'], Icons.title),
                  buildDetailRow(
                      'Description',
                      bookingDetails['serviceDetails']['description'],
                      Icons.description),
                  buildDetailRow(
                    'Original Price',
                    'PKR ${bookingDetails['serviceDetails']['originalPrice']}',
                    Icons.money,
                  ),
                  buildDetailRow(
                    'Discounted Price',
                    'PKR ${bookingDetails['serviceDetails']['discountedPrice']}',
                    Icons.money_off,
                  ),
                  buildDetailRow(
                    'Booking Date',
                    bookingDetails['date'],
                    Icons.date_range,
                  ),
                  buildDetailRow('Booking Time', bookingDetails['time'],
                      Icons.access_time),
                ],
              ),
            ),
          ),
        ),
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
