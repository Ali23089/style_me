import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesScreen extends StatefulWidget {
  final String salonEmail;

  ServicesScreen({Key? key, required this.salonEmail}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  Future<List<dynamic>>? servicesFuture;

  @override
  void initState() {
    super.initState();
    servicesFuture = fetchServicesForSalon(widget.salonEmail);
  }

  Future<List<dynamic>> fetchServicesForSalon(String salonEmail) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    List<dynamic> servicesList = [];

    try {
      QuerySnapshot servicesSnapshot = await _db
          .collection('services')
          .where('barberEmail', isEqualTo: salonEmail) // Correct field name
          .get();

      servicesList = servicesSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // If you need the document ID
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching services: $e");
    }

    return servicesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Services'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text("No services available."));
          }

          List<dynamic> services = snapshot.data!;
          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index];
              String imageUrl = service['imageUrl'] as String? ??
                  ''; // Default to an empty string if not found
              return ListTile(
                title: Text(service['category'] ?? 'No Name'),
                subtitle: Text('Price: ${service['price'] ?? 'N/A'}'),
                leading: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 50, // Set a fixed width for the image
                        height: 50, // Set a fixed height for the image
                        fit: BoxFit.cover, // Cover the area without distortion
                      )
                    : Icon(Icons.content_cut),
              );
            },
          );
        },
      ),
    );
  }
}
