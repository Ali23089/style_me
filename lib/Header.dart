import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 13, 106, 101),
      width: double.infinity,
      height: 250,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 130,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage("assets/logo2.png"))),
          ),
          Text(
            "StyleMe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: "Time New Roman",
            ),
          ),
          Text(
            "styleme@gmail.com",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: "Time New Roman",
            ),
          ),
        ],
      ),
    );
  }
}
