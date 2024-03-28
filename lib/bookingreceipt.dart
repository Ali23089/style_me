import 'package:flutter/material.dart';

// Define a model class for booking
class Booking {
  final String itemName;
  final double price;

  Booking({required this.itemName, required this.price});
}

// Define a simple StatefulWidget for the receipt screen
class ReceiptScreen extends StatefulWidget {
  final List<Booking> bookings;

  ReceiptScreen({required this.bookings});

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: ListView.builder(
        itemCount: widget.bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.bookings[index].itemName),
            trailing:
                Text('\$${widget.bookings[index].price.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${_calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Function to calculate total price of all bookings
  double _calculateTotal() {
    double total = 0;
    for (var booking in widget.bookings) {
      total += booking.price;
    }
    return total;
  }
}

void main() {
  runApp(MaterialApp(
    home: ReceiptScreen(
      bookings: [
        Booking(itemName: 'Item 1', price: 10.00),
        Booking(itemName: 'Item 2', price: 20.00),
        Booking(itemName: 'Item 3', price: 15.00),
        Booking(itemName: 'Item 4', price: 25.00),
      ],
    ),
  ));
}
