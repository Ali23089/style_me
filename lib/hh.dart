import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/Home_Content.dart';
import 'package:style_me/NavBar.dart';
import 'package:style_me/UserProfile.dart';

class HomeScreen extends StatefulWidget {
  final Position? initialPosition;

  const HomeScreen({Key? key, this.initialPosition}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pageOptions;

  @override
  void initState() {
    super.initState();
    _pageOptions = [
      HomeContent(initialPosition: widget.initialPosition),
      BookingHistory(),
      Get_Location(),
      UserProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pageOptions,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
