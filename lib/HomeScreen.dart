import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/SwithUser.dart';
import 'package:style_me/UserProfile.dart';
import 'package:style_me/test1.dart';

import 'SalonScreen.dart'; // Make sure you have this screen created for navigation
import 'Header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Aapko ye function call karna hai jab user koi salon select kare.
  Future<List<dynamic>> fetchServicesForSalon(String salonEmail) async {
    List<dynamic> servicesList = [];

    // Pehle 'Salons' collection se salon document ko fetch karenge
    QuerySnapshot salonSnapshot = await _db
        .collection('Salons')
        .where('email', isEqualTo: salonEmail)
        .get();

    // Check karenge ki koi salon mila hai ke nahi
    if (salonSnapshot.docs.isEmpty) {
      print("Koi salon nahi mila is email ke sath: $salonEmail");
      return servicesList;
    }

    // Salon mil gaya, ab hum 'Services' collection se related services fetch karenge
    QuerySnapshot servicesSnapshot = await _db
        .collection('services')
        .where('barberEmail',
            isEqualTo:
                salonEmail) // Yaha pe hum salon email ka use karenge jo 'Salons' collection se mila hai
        .get();

    // Services ke documents ko ek list mein convert karein
    servicesList = servicesSnapshot.docs.map((doc) => doc.data()).toList();

    return servicesList;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerSections currentPage = DrawerSections.Dashboard; // Set default page
  List<Map<String, dynamic>> salons = [];
  int _selectedItem = 0;
  var _pageData = [
    HomeScreen(),
    HistoryScreen(),
    Get_Location(),
    UserProfile()
  ]; // Ensure you have these screens available

  @override
  void initState() {
    super.initState();
    fetchSalons();
  }

  void fetchSalons() async {
    FirebaseFirestore.instance.collection('Salons').get().then((snapshot) {
      List<Map<String, dynamic>> fetchedSalons = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> salon = doc.data() as Map<String, dynamic>;
        fetchedSalons.add({
          'name': salon['salonName'],
          'image': salon['salonImageUrl'],
          'rating': salon['rating'] ?? 0,
          'email': salon['email'],
        });
      }
      setState(() {
        salons = fetchedSalons;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('StyleMe',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: buildDrawer(),
      bottomNavigationBar: buildBottomNavBar(),
      body: buildBodyContent(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            DrawerList(),
          ],
        ),
      ),
    );
  }

  Widget buildBodyContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildSearchBar(),
          buildTopDealsSection(),
          buildSalonsNearbySection(),
          buildPopularSalonsSection(),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Salon',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget buildTopDealsSection() {
    // Assuming this will have dynamic or static data in the future
    return Container(); // Placeholder
  }

  Widget buildSalonsNearbySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Salons Nearby",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          height:
              220, // Increased height to accommodate larger images and ratings
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: salons.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.network(
                          salons[index]['image'] ?? '',
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          salons[index]['name'] ?? 'No Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          return Icon(
                            i < salons[index]['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: i < salons[index]['rating']
                                ? Colors.amber
                                : Colors.grey,
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: () {
                          var salonEmail = salons[index]['email'];
                          if (salonEmail == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Salon email is not available")),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SalonScreen(
                                      salonEmail: salonEmail,
                                    )),
                          );
                        },
                        child: Text('View Details'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildPopularSalonsSection() {
    // Static or dynamic popular salons listing
    return Container(); // Placeholder
  }

  Widget buildBottomNavBar() {
    return Container(
      color: Color.fromARGB(255, 13, 106, 101),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: GNav(
          gap: 10,
          padding: EdgeInsets.all(16),
          backgroundColor: Color.fromARGB(255, 13, 106, 101),
          color: Colors.white,
          activeColor: Color.fromARGB(255, 13, 106, 101),
          tabBackgroundColor: Colors.white,
          tabs: [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.calendar_month, text: "Appointment"),
            GButton(icon: Icons.location_on, text: "Location"),
            GButton(icon: Icons.person, text: "Profile"),
          ],
          selectedIndex: _selectedItem,
          onTabChange: (index) {
            setState(() {
              _selectedItem = index;
            });
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => _pageData[index]));
          },
        ),
      ),
    );
  }

  Widget DrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menu(1, "Dashboard", Icons.dashboard_outlined, false),
          menu(2, "Appointments", Icons.calendar_month, false),
          menu(3, "Blog", Icons.back_hand, false),
          menu(4, "Search", Icons.search, false),
          menu(5, "Set up business", Icons.business_center, false),
          menu(6, "Settings", Icons.settings, false),
          Divider(),
          menu(7, "Privacy Policy", Icons.policy, false),
          menu(8, "Send feedbacks", Icons.feedback_outlined, false),
          Divider(),
          SizedBox(height: 12),
          buttonWidget(),
        ],
      ),
    );
  }

  Widget menu(int id, String title, IconData icon, bool selected) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            currentPage = DrawerSections.values[id - 1];
          });
          Navigator.pop(context); // Close the drawer
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Colors.black),
              SizedBox(width: 22),
              Text(title, style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget() {
    return SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SwitchUser()));
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 13, 106, 101))),
          child: Text("Barber Mode",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ));
  }
}

enum DrawerSections {
  Dashboard,
  Settings,
  Appointments,
  SetUpBusiness,
  Blog,
  Search,
  privacy,
  feedbacks
}
