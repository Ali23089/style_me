import 'package:flutter/material.dart';
import 'package:style_me/Blog.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/Settings.dart';
import 'package:style_me/SetupBussiness.dart';
import 'package:style_me/hh.dart';
import 'package:style_me/privacyPolicy.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('StyleMe'),
          backgroundColor: const Color.fromARGB(255, 13, 106, 101),
        ),
        drawer: Drawer(
            child: Column(
          children: [
            Expanded(
              flex: 2,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 13, 106, 101),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/logo2.png"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const Text(
                      "StyleMe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: "Time New Roman",
                      ),
                    ),
                    const Text(
                      "styleme@gmail.com",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Time New Roman",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
