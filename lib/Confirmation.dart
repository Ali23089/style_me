import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const BookingConfirmationScreen({Key? key, required this.bookingDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    final date = DateFormat("EEEE, MMMM d, yyyy")
        .format(DateTime.parse(bookingDetails['date']));
    final time = bookingDetails['time'];

    // Get service details
    final serviceDetails =
        bookingDetails['serviceDetails'] as Map<String, dynamic>;

    // Access service details
    final salonName = serviceDetails['salonName'];
    final serviceName = serviceDetails['serviceName'];
    final servicePrice = serviceDetails['servicePrice'];
    final serviceType =
        bookingDetails['serviceType'].toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmation"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Icon(Icons.check_circle_outline, size: 120, color: Colors.teal),
            SizedBox(height: 20),
            Text("Booking Successful!",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.teal)),
            SizedBox(height: 30),
            buildBookingDetailCard(context, salonName, serviceName,
                servicePrice, serviceType, date, time),
          ],
        ),
      ),
    );
  }

  Card buildBookingDetailCard(
      BuildContext context,
      String salonName,
      String serviceName,
      String servicePrice,
      String serviceType,
      String date,
      String time) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            bookingDetailRow(context, "Salon Name:", salonName, Icons.store),
            bookingDetailRow(
                context, "Service Name:", serviceName, Icons.design_services),
            bookingDetailRow(context, "Service Price:", 'PKR $servicePrice',
                Icons.attach_money),
            bookingDetailRow(
                context, "Service Type:", serviceType, Icons.category),
            bookingDetailRow(context, "Date:", date, Icons.calendar_today),
            bookingDetailRow(context, "Time:", time, Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget bookingDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
