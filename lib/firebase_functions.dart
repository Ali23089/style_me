import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_me/Barber_Home.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/hh.dart';
import 'package:style_me/main.dart';

class SessionController {
  static String? userId; // Example property, adjust as needed
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final RegExp emailValidatorRegex =
    RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

Future<void> createUserWithEmailAndPassword(
  String emailAddress,
  String password,
  BuildContext context,
) async {
  if (!emailValidatorRegex.hasMatch(emailAddress)) {
    // Show error message for invalid email format
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid email format."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (password.length < 6) {
    // Show error message for weak password
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password should be greater than 6 characters."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    final UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    if (credential.user != null) {
      // Add user details to Firestore after successful registration
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': emailAddress,
        // Add other user details if needed
      });

      // Navigate to HomeScreen after successful registration
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );*/

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully Registered"),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    // Handle Firebase Authentication exceptions
    print(e);
    if (e is FirebaseAuthException) {
      // Handle specific exceptions (e.g., weak-password, email-already-in-use)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> signInWithEmailAndPassword(
  String emailAddress,
  String password,
  BuildContext context,
) async {
  if (!emailValidatorRegex.hasMatch(emailAddress)) {
    // Show error message for invalid email format
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid email format."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    if (credential.user != null) {
      // Navigate to HomeScreen after successful login
      if (!credential.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verify your Email Address"),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Get_Location()),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    // Handle Firebase Authentication exceptions
    print(e);
    if (e is FirebaseAuthException) {
      // Handle specific exceptions (e.g., user-not-found, wrong-password)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> signInWithEmailAndPasswordtwo(
  String emailAddress,
  String password,
  BuildContext context,
) async {
  if (!emailValidatorRegex.hasMatch(emailAddress)) {
    // Show error message for invalid email format
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid email format."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    if (credential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BarberScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    // Handle Firebase Authentication exceptions
    print(e);
    if (e is FirebaseAuthException) {
      // Handle specific exceptions (e.g., user-not-found, wrong-password)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    // Navigate to the login screen after signing out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()),
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Successfully Signed Out"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Handle sign out exceptions
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred while signing out."),
        backgroundColor: Colors.red,
      ),
    );
  }
}
