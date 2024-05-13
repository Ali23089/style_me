import 'package:booking_calendar/booking_calendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/Appointment.dart';
import 'package:style_me/BarberForm.dart';
import 'package:style_me/BarberHome.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Converter.dart';
import 'package:style_me/Details.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/Firebase_Api.dart';
import 'package:style_me/ForgetPasword.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/LoginBarber.dart';
import 'package:style_me/MapScreen.dart';
import 'package:style_me/Nav_Bar.dart';
import 'package:style_me/NewCertificate.dart';
import 'package:style_me/Notification.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Initialize OneSignal
  OneSignal.initialize("dce36486-8046-42f4-92eb-e13356e45aac");

  // Optionally, prompt for push notifications permission
  OneSignal.Notifications.requestPermission(true);

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
