import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWidget(
          userId: '8vRHKVWCCHPpMDLiCLdS'), // Replace with actual user ID
    );
  }
}

class MyWidget extends StatefulWidget {
  final String userId;

  const MyWidget({required this.userId, Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture =
        FirebaseFirestore.instance.collection('User').doc(widget.userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error fetching data: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData != null) {
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    title: Text('Name: ${userData['name']}'),
                  ),
                  ListTile(
                    title: Text('Email: ${userData['email']}'),
                  ),
                  // Add more ListTile widgets for other user data fields
                ],
              );
            } else {
              return Center(child: Text('Invalid data format'));
            }
          }
        },
      ),
    );
  }
}
