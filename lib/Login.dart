import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_me/ForgetPasword.dart';
import 'package:style_me/Register.dart';
import 'package:style_me/UserModel.dart';
import 'package:style_me/firebase_functions.dart';
import 'package:style_me/main.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late Color mycolor;
  late Size mediaSize;
  bool rememberUser = false;
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    mycolor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 6, 35, 28),
              Color.fromARGB(255, 4, 172, 163),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: 80,
            child: const Padding(
              padding: EdgeInsets.only(top: 140.0, left: 22),
              child: Text(
                'Hello User\nPlease-Sign In!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 310.0),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: Icon(Icons.done),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !passToggle,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passToggle = !passToggle;
                            });
                          },
                          icon: Icon(
                            passToggle
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberUser,
                              onChanged: (value) {
                                setState(() {
                                  rememberUser = value!;
                                });
                              },
                            ),
                            Text("Remember me",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPassword()),
                            );
                          },
                          child: Text("Forgot Password",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signInWithEmailAndPassword(emailController.text,
                            passwordController.text, context);
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyWidget(userId: "8vRHKVWCCHPpMDLiCLdS")),
                        );*/
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        minimumSize: Size.fromHeight(60),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 6, 35, 28),
                              Color.fromARGB(255, 4, 172, 163),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          "Create an Account",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
