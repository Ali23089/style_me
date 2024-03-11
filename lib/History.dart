
/*
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/Settings.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedItem = 0;
  // for switching navbar
  var _pageData = [HomeScreen(), Booking(), HistoryScreen(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
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

      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: GNav(
            gap: 10,
            padding: EdgeInsets.all(16),
            backgroundColor: Color.fromARGB(255, 13, 106, 101),
            color: Colors.white,
            activeColor: Color.fromARGB(255, 13, 106, 101),
            tabBackgroundColor: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.book,
                text: "Book",
              ),
              GButton(
                icon: Icons.history,
                text: "History",
              ),
              GButton(
                icon: Icons.person,
                text: "Account",
              ),
            ],
            selectedIndex: _selectedItem,
            onTabChange: (Index) {
              setState(() {
                _selectedItem = Index;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => _pageData[Index]));
            },
          ),
        ),
      ),
    );
  }
}
*/