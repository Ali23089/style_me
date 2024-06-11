import 'package:flutter/material.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/LoginBarber.dart';

class SwitchUser extends StatefulWidget {
  const SwitchUser({Key? key}) : super(key: key);

  @override
  State<SwitchUser> createState() => _SwitchUserState();
}

class _SwitchUserState extends State<SwitchUser>
    with SingleTickerProviderStateMixin {
  late Size mediaSize;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(height: mediaSize.height * 0.05),
                Container(
                  padding: EdgeInsets.all(mediaSize.width * 0.05),
                  child: Image.asset("assets/logo2.png"),
                ),
                SizedBox(height: mediaSize.height * 0.02),
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: mediaSize.width * 0.08,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: mediaSize.height * 0.02),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: mediaSize.width * 0.1),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Loginpage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaSize.width * 0.13,
                            vertical: mediaSize.height * 0.02,
                          ),
                        ),
                        child: Text(
                          "Login as User",
                          style: TextStyle(
                            fontSize: mediaSize.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: mediaSize.height * 0.015),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      BarberLogin(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaSize.width * 0.1,
                            vertical: mediaSize.height * 0.02,
                          ),
                        ),
                        child: Text(
                          "Login as Barber",
                          style: TextStyle(
                            fontSize: mediaSize.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mediaSize.height * 0.1),
                Text(
                  "Login with Social media",
                  style: TextStyle(
                    fontSize: mediaSize.width * 0.05,
                    fontFamily: "Times New Roman",
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: mediaSize.height * 0.01),
                Image(
                  image: AssetImage("assets/social.png"),
                  height: mediaSize.height * 0.1,
                ),
                SizedBox(height: mediaSize.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
