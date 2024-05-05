/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void initNotification() 
  {
    _messaging.requestPermission
    (
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message in the foreground!");
      print("Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}");
    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A message opened the app: ${message.notification?.title}");
    });
  }
}*/
