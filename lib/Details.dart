import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  final String salonEmail;

  const Details({Key? key, required this.salonEmail}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<Map<String, dynamic>?> salonDetailsFuture;

  @override
  void initState() {
    super.initState();
    salonDetailsFuture = fetchSalonDetails(widget.salonEmail);
  }

  Future<Map<String, dynamic>?> fetchSalonDetails(String salonEmail) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    try {
      QuerySnapshot salonSnapshot = await _db
          .collection('Salons')
          .where('email', isEqualTo: salonEmail)
          .limit(1)
          .get();

      if (salonSnapshot.docs.isNotEmpty) {
        var data = salonSnapshot.docs.first.data() as Map<String, dynamic>;
        return data;
      } else {
        print("No salon found for the given email.");
        return null;
      }
    } catch (e) {
      print("Error fetching salon details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: salonDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No salon details available."));
          }

          var salonData = snapshot.data!;

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                automaticallyImplyLeading:
                    false, // This will hide the back arrow
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    salonData['salonImageUrl'] ?? 'default_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      salonData['salonName'] ?? 'Salon Name',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Makes text bold
                          fontSize: 24 // Increases the font size
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      salonData['salonAddress'] ?? 'Your Salon Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.location_on, color: Colors.white),
                  ),
                  ListTile(
                    title: Text(
                      'Phone',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      salonData['salonContact'] ?? 'Your Salon Phone Number',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.phone, color: Colors.white),
                  ),
                  ListTile(
                    title: Text(
                      'Category',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      salonData['category'] ?? 'Not specified',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.category, color: Colors.white),
                  ),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      salonData['email'] ?? 'Not provided',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.email, color: Colors.white),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your FAB action here, like opening a phone dialer or booking form
        },
        child: Icon(Icons.phone),
        backgroundColor: Colors.white,
      ),
    );
  }
}
