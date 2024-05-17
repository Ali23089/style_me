import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  CustomBottomNavBar({required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 12, 101, 97),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: const Color.fromARGB(255, 13, 106, 101)!,
            hoverColor: const Color.fromARGB(255, 13, 106, 101)!,
            gap: 8,
            activeColor: Color.fromARGB(255, 13, 106, 101),
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.white,
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.book, text: 'Bookings'),
              GButton(icon: Icons.location_on, text: 'Location'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
