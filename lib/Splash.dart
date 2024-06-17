import 'dart:async';
import 'package:flutter/material.dart';
import 'package:style_me/SwithUser.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SwitchUser()),
      );
    });
  }

  late Color mycolor;

  @override
  Widget build(BuildContext context) {
    mycolor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 6, 35, 28),
            Color.fromARGB(255, 4, 172, 163),
          ],
        ),

        /*image: DecorationImage(
          image: const AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            mycolor.withOpacity(1.0),
            BlendMode.dstATop,
          ),
        ),*/
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo2.png",
              height: 400,
              width: 400,
            ),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
