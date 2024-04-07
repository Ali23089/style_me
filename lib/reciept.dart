import 'package:flutter/material.dart';
import 'package:style_me/Converter.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String label;
  final String value;

  const BookingDetailsScreen({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class BookingConfirmationScreen extends StatelessWidget {
  final String serviceName;
  final int serviceDuration;
  final DateTime bookingDate;
  final int quantity;
  final double serviceAmount;
  final double gstRate;

  const BookingConfirmationScreen({
    required this.serviceName,
    required this.serviceDuration,
    required this.bookingDate,
    required this.quantity,
    required this.serviceAmount,
    required this.gstRate,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate net amount
    double netAmount = serviceAmount * quantity;
    double gstAmount = netAmount * gstRate;
    double totalAmount = netAmount + gstAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingDetailsScreen(
              label: 'Service',
              value: serviceName,
            ),
            BookingDetailsScreen(
              label: 'Duration',
              value: '$serviceDuration minutes',
            ),
            BookingDetailsScreen(
              label: 'Booking Date',
              value:
                  '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}',
            ),
            BookingDetailsScreen(
              label: 'Exact Time',
              value: '${bookingDate.hour}:${bookingDate.minute}',
            ),
            BookingDetailsScreen(
              label: 'Quantity',
              value: quantity.toString(),
            ),
            BookingDetailsScreen(
              label: 'Service Amount',
              value: '\$${serviceAmount.toStringAsFixed(2)}',
            ),
            BookingDetailsScreen(
              label: 'Net Amount',
              value: '\$${netAmount.toStringAsFixed(2)}',
            ),
            BookingDetailsScreen(
              label: 'GST Rate',
              value: '${(gstRate * 100).toStringAsFixed(2)}%',
            ),
            BookingDetailsScreen(
              label: 'GST Amount',
              value: '\$${gstAmount.toStringAsFixed(2)}',
            ),
            BookingDetailsScreen(
              label: 'Total Amount',
              value: '\$${totalAmount.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMe',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Converter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
