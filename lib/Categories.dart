import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:style_me/Appointment.dart';

class Categories extends StatefulWidget {
  final String salonEmail;
  final String salonName;
  final String locationName;

  Categories(
      {Key? key,
      required this.salonEmail,
      required this.salonName,
      required this.locationName})
      : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<dynamic>>? servicesFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<dynamic> _servicesList = [];

  @override
  void initState() {
    super.initState();
    fetchServicesForSalon(widget.salonEmail).then((services) {
      if (mounted) {
        setState(() {
          _servicesList = services;
          for (var i = 0; i < services.length; i++) {
            _listKey.currentState?.insertItem(i);
          }
        });
      }
    });
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
    return AnimatedList(
      key: _listKey,
      initialItemCount: _servicesList.length,
      itemBuilder: (context, index, animation) {
        var service = _servicesList[index];
        return SizeTransition(
          sizeFactor: animation,
          child: Card(
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
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CategoryDetails(
                      category: service,
                      salonName: widget.salonName,
                      salonEmail: widget.salonEmail,
                      locationName: widget.locationName,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CategoryDetails extends StatelessWidget {
  final Map<String, dynamic> category;
  final String salonName;
  final String salonEmail;
  final String locationName;

  CategoryDetails(
      {required this.category,
      required this.salonName,
      required this.salonEmail,
      required this.locationName});

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
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color.fromARGB(255, 13, 106, 101),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: ListView(
              key: ValueKey<String>(name),
              children: [
                Card(
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      imageUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/default_image.png',
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromARGB(255, 13, 106, 101))),
                        SizedBox(height: 16.0),
                        Text('Description:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromARGB(255, 13, 106, 101))),
                        Text(description,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 13, 106, 101))),
                        Text('PKR $price',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 13, 106, 101)),
                    label: Text('Book Appointment',
                        style: TextStyle(
                            color: Color.fromARGB(255, 13, 106, 101))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomBookingScreen(
                            serviceDetails: {
                              'salonName': salonName,
                              'salonEmail': salonEmail,
                              'serviceName': name,
                              'servicePrice': price,
                              'serviceId': category['id'],
                            },
                            locationName: locationName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(30, 48),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
