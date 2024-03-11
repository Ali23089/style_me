import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/ff.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    //  final BottomNavigationBarController controller =
    //  Get.put(BottomNavigationBarController());

    return Scaffold(
      bottomNavigationBar: GNav(
        activeColor: Colors.white,
        color: Colors.brown,
        backgroundColor: Colors.teal,
        tabBackgroundColor: Colors.white,
        tabBorderRadius: 40,
        tabMargin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTabChange: (value) {
          print(value);
          // controller.index.value = value;
        },
        tabs: [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.calendar_month,
            text: 'Booking',
          ),
          /* GButton(
              icon: Icons.history,
              text: 'history',
            ),*/
          GButton(
            icon: Icons.person,
            text: 'profile',
          ),
        ],
      ),
      // body: Obx(
      // () => controller.pages[controller.index.value],
      //  )
    );
  }
}
