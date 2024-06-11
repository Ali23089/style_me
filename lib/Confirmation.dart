import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  const BookingConfirmationScreen({Key? key, required this.bookingDetails})
      : super(key: key);
  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    final date = DateFormat("EEEE, MMMM d, yyyy")
        .format(DateTime.parse(widget.bookingDetails['date']));
    final time = widget.bookingDetails['time'];

    // Get service details
    final serviceDetails =
        widget.bookingDetails['serviceDetails'] as Map<String, dynamic>;

    // Access service details
    final salonName = serviceDetails['salonName'];
    final serviceName = serviceDetails['serviceName'];
    final servicePrice = serviceDetails['servicePrice'];
    final serviceType =
        widget.bookingDetails['serviceType'].toString().split('.').last;

    // Home service details
    final homeServiceDetails =
        widget.bookingDetails['homeServiceDetails'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmation"),
        backgroundColor: Colors.teal,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(Icons.check_circle_outline,
                    size: 120, color: Colors.teal),
              ),
              SizedBox(height: 20),
              Text("Booking Successful!",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.teal)),
              SizedBox(height: 30),
              SlideTransition(
                position: _slideAnimation,
                child: buildBookingDetailCard(context, salonName, serviceName,
                    servicePrice, serviceType, date, time, homeServiceDetails),
              ),
            ],
          ),
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
      String time,
      Map<String, dynamic>? homeServiceDetails) {
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
            if (homeServiceDetails != null) ...[
              bookingDetailRow(context, "Address:",
                  homeServiceDetails['address'], Icons.home),
              bookingDetailRow(context, "Contact Number:",
                  homeServiceDetails['contactNumber'], Icons.phone),
              bookingDetailRow(context, "Location:",
                  homeServiceDetails['locationName'], Icons.location_on),
              bookingDetailRow(context, "Email:",
                  homeServiceDetails['userEmail'], Icons.email),
            ],
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
