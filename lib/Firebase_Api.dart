/*import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Fetch the FCM token for this device
    final fcmToken = await _firebaseMessaging.getToken();

    // Print the token (normally you would send this to your server)
    print('Token: $fcmToken');
  }

  // Function to handle received messages
  void setupInteractions() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming foreground messages here
      print('Message received in the foreground: ${message.messageId}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle message when the user taps on a notification
      print('Message clicked: ${message.messageId}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }
}*/
