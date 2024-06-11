import 'package:flutter/material.dart';
import 'package:style_me/BarberForm.dart';
import 'package:style_me/Barber_Home.dart';
import 'package:style_me/Barbers.dart';
import 'package:style_me/RegisterBarbar.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/firebase_functions.dart';

class BarberLogin extends StatefulWidget {
  const BarberLogin({super.key});

  @override
  State<BarberLogin> createState() => _BarberLoginState();
}

class _BarberLoginState extends State<BarberLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true; // Toggle for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 35, 28),
                  Color.fromARGB(255, 4, 172, 163),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 140.0, left: 22),
              child: Text(
                'Hello Barber\nPlease-Sign In!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.email),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 35, 28),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: passToggle,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passToggle =
                                    !passToggle; // Toggle the password visibility
                              });
                            },
                            icon: Icon(
                              passToggle
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color.fromARGB(255, 6, 35, 28),
                            ),
                          ),
                          labelText: 'Password',
                          hintText: "Enter your password",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 35, 28),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            signInWithEmailAndPasswordtwo(emailController.text,
                                passwordController.text, context);
                            /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BarberScreen())
                                    );*/
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 6, 35, 28),
                                Color.fromARGB(255, 4, 172, 163),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BarberForm()),
                                );
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
