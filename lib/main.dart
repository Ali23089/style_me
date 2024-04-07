import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:style_me/Appointment.dart';
import 'package:style_me/BarberForm.dart';
import 'package:style_me/BarberHome.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Converter.dart';
import 'package:style_me/Details.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/ForgetPasword.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/LoginBarber.dart';
import 'package:style_me/MapScreen.dart';
import 'package:style_me/Nav_Bar.dart';
import 'package:style_me/NewCertificate.dart';
import 'package:style_me/Places.dart';
import 'package:style_me/Profile.dart';
import 'package:style_me/Register.dart';
import 'package:style_me/RegisterBarbar.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/SaloonForm.dart';
import 'package:style_me/Settings.dart';
import 'package:style_me/Splash.dart';
import 'package:style_me/SwithUser.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:style_me/UserModel.dart';
import 'package:style_me/Verify.dart';
import 'package:style_me/bookingreceipt.dart';
import 'package:style_me/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_me/identitty.dart';
import 'package:style_me/reciept.dart';

void main() async {
  await initializeDateFormatting(
      "en_US"); // Replace "en_US" with your desired locale
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMe',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SwitchUser(),
      debugShowCheckedModeBanner: false,
    );
  }
}
