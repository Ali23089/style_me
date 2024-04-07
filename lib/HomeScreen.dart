import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:style_me/Appointment.dart';
import 'package:style_me/Blog.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/Get_User.dart';
import 'package:style_me/Header.dart';
import 'package:style_me/History.dart';
import 'package:style_me/Nav_Bar.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/Settings.dart';
import 'package:style_me/SetupBussiness.dart';
import 'package:style_me/SwithUser.dart';
import 'package:style_me/UserProfile.dart';
import 'package:style_me/privacyPolicy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Search bar
/*class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Salon',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}*/

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = DrawerSections.Dashboard;
  int _selectedItem = 0;

  /*String tokenforSession = '37465';
  var uuid = Uuid();

  final TextEditingController _controller = TextEditingController();

  List<dynamic> listforplaces = [];
  bool isLoading = false;

  void makesuggestion(String input) async {
    if (input.isEmpty) {
      setState(() {
        listforplaces = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    String googlePlacesApiKey =
        "AIzaSyBjy7ZhrjIhu7HC_1YB6qo7mPhB02aCf74"; // Replace with your API key
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey';

    var responseResult = await http.get(Uri.parse(request));

    if (responseResult.statusCode == 200) {
      setState(() {
        listforplaces = jsonDecode(responseResult.body)['predictions'];
        isLoading = false;
      });
    } else {
      print("Failed to load data: ${responseResult.statusCode}");
      setState(() {
        isLoading = false;
      });
      // Handle error gracefully, e.g., show a snackbar
    }
  }

  void onModify(String input) {
    if (tokenforSession == null) {
      setState(() {
        tokenforSession = uuid.v4();
      });
    }

    makesuggestion(input);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onModify(_controller.text);
    });
  }*/

  var _pageData = [
    HomeScreen(),
    HistoryScreen(),
    Get_Location(),
    UserProfile()
  ];

  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'StyleMe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Header(),
                DrawerList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.calendar_month,
                text: "Appointment",
              ),
              GButton(
                icon: Icons.location_on,
                text: "Location",
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              ),
            ],
            selectedIndex: _selectedItem,
            onTabChange: (index) {
              setState(() {
                _selectedItem = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _pageData[index]),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  // controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search Salon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              /* isLoading
                  ? CircularProgressIndicator() // Show loading indicator while fetching suggestions
                  : listforplaces.isEmpty
                      ? Center(
                          child: Text(
                            'No suggestions',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listforplaces.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(listforplaces[index]['description']),
                                onTap: () {
                                  // Handle selection
                                  print(
                                      'Selected: ${listforplaces[index]['description']}');
                                },
                              );
                            },
                          ),
                        ),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 11),
                      height: 20,
                      child: const Text(
                        "Top Deals",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 150, // Adjusted height
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ), // Rounded corners
                          image: DecorationImage(
                            image: AssetImage('assets/men.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10, // Positioned at the bottom
                                left: 10, // Positioned from the left
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hair Styling', // Dynamically replace with your deal name variable
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'PKR: 250', // Dynamically replace with your deal price variable
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.yellow),

                                      // Adjusted for visibility
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage('assets/deal.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hair Cleansing', // Placeholder for the deal name
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'PkR: 450', // Placeholder for the deal price
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.yellow),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage('assets/deal1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Facial Mask', // Replace with the actual deal name
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'PKR: 900', // Replace with the actual deal price
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.yellow),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)), // Adds rounded corners
                          image: DecorationImage(
                            image: AssetImage('assets/deal2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        20)), // Ensures the gradient respects the border radius
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Party Makeup', // Replace with the actual deal name
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'PKR: 3000', // Replace with the actual deal price
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.yellow),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 11),
                      height: 20,
                      child: const Text(
                        "Salons NearBy",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Salons')
                              .doc(userEmail)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              var salonData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SalonScreen()),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                            image: NetworkImage(salonData[
                                                'salonImageUrl']), // Use salon image URL from Firestore
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        salonData[
                                            'salonName'], // Use salon name from Firestore
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                    ConnectionState.none ||
                                snapshot.hasError) {
                              return Text("Error fetching data");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)), // Added for rounded corners
                          image: DecorationImage(
                            image: AssetImage('assets/sn2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        20)), // Ensures the gradient respects the border radius
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Azan Hair Dresser', // Placeholder for the actual salon name
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {
                                        // Dynamically generate stars based on salon rating
                                        return Icon(
                                          index < 3
                                              ? Icons.star
                                              : Icons
                                                  .star_border, // Placeholder for rating logic
                                          color: Colors.yellow,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)), // Adds rounded corners
                          image: DecorationImage(
                            image: AssetImage('assets/sn3.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        20)), // Ensures gradient respects the border radius
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Roop Singhar Salon', // Replace with actual salon name variable
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {
                                        // Dynamically generate stars based on salon rating
                                        return Icon(
                                          index < 3
                                              ? Icons.star
                                              : Icons
                                                  .star_border, // Adjust based on actual rating
                                          color: Colors.yellow,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)), // Adds rounded corners
                          image: DecorationImage(
                            image: AssetImage('assets/sn4.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalonScreen()),
                            );
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        20)), // Ensures gradient respects the border radius
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Zohaib Stylish', // Replace with actual salon name variable
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {
                                        // Dynamically generate stars based on salon rating
                                        return Icon(
                                          index < 3
                                              ? Icons.star
                                              : Icons
                                                  .star_border, // Adjust based on actual rating
                                          color: Colors.yellow,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 11),
                      height: 20,
                      child: const Text(
                        "Popular Salons",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)), // Adds rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/ps4.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                20)), // Ensures gradient respects the border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peter Salon', // Placeholder for the salon name
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                // Dynamically generates stars based on salon rating
                                return Icon(
                                  index < 3
                                      ? Icons.star
                                      : Icons
                                          .star_border, // Placeholder for rating, adjust accordingly
                                  color: Colors.yellow,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)), // Adds rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/sn4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                20)), // Ensures the gradient respects the border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tony and Guy', // Replace with actual salon name variable
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                // Dynamically generates stars based on salon rating
                                return Icon(
                                  index < 3
                                      ? Icons.star
                                      : Icons
                                          .star_border, // Adjust based on actual rating
                                  color: Colors.yellow,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)), // Adds rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/ps1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                20)), // Ensures the gradient respects the border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nabeela,s Salon', // Replace with the actual salon name variable
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                // Dynamically generate stars based on the salon rating
                                return Icon(
                                  index < 3
                                      ? Icons.star
                                      : Icons
                                          .star_border, // Adjust based on actual rating
                                  color: Colors.yellow,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)), // Adds rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/ps2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                20)), // Ensures the gradient respects the border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shimla Beauty Parlor', // Placeholder for the actual salon name
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                // Dynamically generates stars based on the salon rating
                                return Icon(
                                  index < 3
                                      ? Icons.star
                                      : Icons
                                          .star_border, // Placeholder for rating, adjust accordingly
                                  color: Colors.yellow,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)), // Adds rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/ps3.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                20)), // Ensures the gradient respects the border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BUZZ Groom', // Placeholder for the actual salon name
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                // Dynamically generates stars based on the salon rating
                                return Icon(
                                  index < 3
                                      ? Icons.star
                                      : Icons
                                          .star_border, // Placeholder for rating, adjust accordingly
                                  color: Colors.yellow,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menu(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.Dashboard ? true : false),
          menu(2, "Appointments", Icons.calendar_month,
              currentPage == DrawerSections.Appointments ? true : false),
          menu(3, "Blog", Icons.back_hand,
              currentPage == DrawerSections.Blog ? true : false),
          menu(4, "Search", Icons.search,
              currentPage == DrawerSections.Search ? true : false),
          menu(5, "Set up businesss", Icons.business_center,
              currentPage == DrawerSections.SetUpBusiness ? true : false),
          menu(6, "Settings", Icons.settings,
              currentPage == DrawerSections.Settings ? true : false),
          Divider(),
          menu(7, "Privacy Policy", Icons.policy,
              currentPage == DrawerSections.privacy ? true : false),
          menu(8, "Send feedbacks", Icons.feedback_outlined,
              currentPage == DrawerSections.feedbacks ? true : false),
          Divider(),
          SizedBox(
            height: 12,
          ),
          buttonWidget(context),
        ],
      ),
    );
  }

  Widget buttonWidget(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SwitchUser()),
              );

              // Handle button press
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 13, 106, 101),
              ),
            ),
            child: Text(
              "Barber Mode",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            )));
  }

  Widget menu(int id, String title, IconData icon, bool selected) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.Appointments;
            } else if (id == 3) {
              currentPage = DrawerSections.Blog;
            } else if (id == 4) {
              currentPage = DrawerSections.Search;
            } else if (id == 5) {
              currentPage = DrawerSections.SetUpBusiness;
            } else if (id == 6) {
              currentPage = DrawerSections.Settings;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy;
            } else if (id == 8) {
              currentPage = DrawerSections.feedbacks;
            }
            switch (currentPage) {
              case DrawerSections.Dashboard:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case DrawerSections.Appointments:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingCalendarDemoApp()),
                );
                break;
              case DrawerSections.Blog:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Blog()),
                );
                break;
              case DrawerSections.Search:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case DrawerSections.SetUpBusiness:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => setupBussiness()),
                );
                break;
              case DrawerSections.Settings:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
                break;
              case DrawerSections.privacy:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
                break;
              case DrawerSections.feedbacks:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
                break;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Icon(
                  icon,
                  size: 22,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 22),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  feedbacks,
}
