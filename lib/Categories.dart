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
      return [];
    }

    return servicesList;
  }

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetails(
                        category: service,
                        salonName:
                            'Your Salon Name', // Fetch the salon name properly or pass it as needed
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CategoryDetails extends StatelessWidget {
  final Map<String, dynamic> category;
  final String salonName;

  CategoryDetails({required this.category, required this.salonName});

  @override
  Widget build(BuildContext context) {
    final String name = category['productName'] ?? 'No Name Provided';
    final String description =
        category['description'] ?? 'No description available';
    final String imageUrl =
        category['imageUrl'] ?? 'https://placehold.it/200x200';
    final String price = category['price']?.toString() ?? 'Price not available';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Text('Failed to load image');
              },
            ),
            SizedBox(height: 16.0),
            Text(name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 16.0),
            Text('Description:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text(description, style: TextStyle(fontSize: 14)),
            SizedBox(height: 16.0),
            Text('Price: $price',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black)),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomBookingScreen(
                      serviceDetails: {
                        'salonName': salonName,
                        'serviceName': name,
                        'servicePrice': price,
                        'serviceId': category['id'],
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 13, 106, 101),
                textStyle: TextStyle(fontSize: 18),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Text('Save Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
