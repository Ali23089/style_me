import 'package:flutter/material.dart';

class BookingReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const BookingReceiptScreen({Key? key, required this.bookingDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Receipt'),
      ),
      body: Padding(
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
                buildDetailRow('Salon Name', bookingDetails['salonName']),
                buildDetailRow(
                    'Service', bookingDetails['serviceDetails']['title']),
                buildDetailRow('Date', bookingDetails['date']),
                buildDetailRow('Time', bookingDetails['time']),
                buildDetailRow('Location', bookingDetails['locationName']),
                buildDetailRow(
                    'Payment Method', bookingDetails['paymentMethod']),
                buildDetailRow('User Email', bookingDetails['userEmail']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Color.fromARGB(255, 13, 106, 101)),
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
