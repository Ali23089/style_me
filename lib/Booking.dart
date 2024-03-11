import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Salon History',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Color.fromARGB(255, 6, 35, 28),
      ),
      body: Container(
        /* decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 6, 35, 28),
              Color.fromARGB(255, 4, 172, 163),], // Set gradient colors
          ),
        ),*/
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.history,
                  color: Colors.black), // Set icon color to white
              title: Text(
                'Appointment #$index',
                style:
                    TextStyle(color: Colors.black), // Set text color to white
              ),
              subtitle: Text(
                'Date: 01/01/2023',
                style: TextStyle(
                    color: Colors
                        .black), // Set subtitle text color to white with some transparency
              ),
              trailing: Icon(Icons.arrow_forward,
                  color: Colors.black), // Set icon color to white
              onTap: () {
                // Navigate to detailed history or perform actions
              },
            );
          },
        ),
      ),
    );
  }
}
