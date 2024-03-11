/*import 'package:flutter/material.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/History.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/Settings.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
 int _selectedItem = 0;
 var _pageData = [HomeScreen(), Booking(), HistoryScreen(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      // BOTTOM NAVIGATION BAR 

    bottomNavigationBar: Theme
    (
  data: Theme.of(context).copyWith(
  canvasColor: Colors.black, // Set the desired background color here

    
  ),
  child: BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

      BottomNavigationBarItem(icon: Icon(Icons.book), label: "Book"),
      
      BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings"),
    ],

    currentIndex: _selectedItem,
    onTap:(setValue){
      setState(() {
        _selectedItem = setValue;
      });
      // Navigate to the selected page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pageData[_selectedItem]),
            );


    },


  ),
),
      // Add the rest of your widget tree here
    );
  }
}*/