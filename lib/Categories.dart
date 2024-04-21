import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:style_me/Appointment.dart';

class SalonCategoryScreen extends StatelessWidget {
  final String salonEmail;

  SalonCategoryScreen({Key? key, required this.salonEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Categories'),
        //  backgroundColor: Colors.blac,
      ),
      body: Column(
        children: [
          Image.network(
            'https://img.freepik.com/premium-photo/salon-with-mirror-wall-hair-salon-chair_732812-843.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Categories(salonEmail: salonEmail),
          ),
        ],
      ),
    );
  }
}

class Categories extends StatefulWidget {
  final String salonEmail;

  Categories({Key? key, required this.salonEmail}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<dynamic>>? servicesFuture;

  @override
  void initState() {
    super.initState();
    servicesFuture = fetchServicesForSalon(widget.salonEmail);
  }

  Future<List<dynamic>> fetchServicesForSalon(String salonEmail) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    List<dynamic> servicesList = [];

    print('Fetching services for salon email: $salonEmail');

    try {
      QuerySnapshot servicesSnapshot = await _db
          .collection('services')
          .where('barberEmail', isEqualTo: salonEmail)
          .get();

      servicesList = servicesSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching services: $e");
    }

    return servicesList;
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold or AppBar here since this widget is part of SalonCategoryScreen
    return FutureBuilder<List<dynamic>>(
      future: servicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.data!.isEmpty) {
          return Center(child: Text("No services available."));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var service = snapshot.data![index];
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                leading: Image.network(
                  service['imageUrl'] ?? 'default_image.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  service['productName'] ?? 'Service',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Price: ${service['price'] ?? 'N/A'}\nDescription: ${service['description'] ?? 'No description available.'}',
                ),
                onTap: () {
                  // Navigate to service detail or booking screen
                },
              ),
            );
          },
        );
      },
    );
  }
}

// The AppointmentButton seems to be okay as is. Make sure it's being used appropriately in your navigation stack.

class AppointmentButton extends StatelessWidget {
  final Map<String, dynamic> category;

  AppointmentButton({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Center(
        child: Text('Book an appointment for ${category['name']}'),
      ),
    );
  }
}
