import 'package:flutter/material.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/LoginBarber.dart';
import 'package:style_me/Register.dart';

class SwitchUser extends StatefulWidget {
  const SwitchUser({Key? key}) : super(key: key);

  @override
  State<SwitchUser> createState() => _SwitchUserState();
}

class _SwitchUserState extends State<SwitchUser> {
  late Size mediaSize;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size; // Initialize mediaSize

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 6, 35, 28),
              Color.fromARGB(255, 4, 172, 163),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.all(18.0),
              child: Image.asset("assets/logo2.png"),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Login as User",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarberLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                "Login as Barber",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            Text(
              "Login with Social media",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Times New Roman",
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Image(
              image: AssetImage("assets/social.png"),
              height: 80,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
