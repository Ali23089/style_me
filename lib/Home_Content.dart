import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/Blog.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/FetchDeal.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/SetupBussiness.dart';
import 'package:style_me/SwithUser.dart';
import 'package:style_me/firebase_functions.dart';
import 'package:style_me/privacyPolicy.dart';
import 'package:style_me/settings_screen.dart';

class HomeContent extends StatefulWidget {
  final Position? initialPosition;

  const HomeContent({Key? key, this.initialPosition}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<dynamic>> fetchServicesForSalon(String salonEmail) async {
    List<dynamic> servicesList = [];

    QuerySnapshot salonSnapshot = await _db
        .collection('Salons')
        .where('email', isEqualTo: salonEmail)
        .get();

    if (salonSnapshot.docs.isEmpty) {
      print("Koi salon nahi mila is email ke sath: $salonEmail");
      return servicesList;
    }

    QuerySnapshot servicesSnapshot = await _db
        .collection('services')
        .where('barberEmail', isEqualTo: salonEmail)
        .get();

    servicesList = servicesSnapshot.docs.map((doc) => doc.data()).toList();

    return servicesList;
  }
}

class _HomeContentState extends State<HomeContent> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> nearbySalons = [];
  List<Map<String, dynamic>> popularSalons = [];
  String locationName = 'No location';
  bool _isDarkMode = false; // Add this line

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Add this line
    if (widget.initialPosition != null) {
      fetchLocationName(widget.initialPosition!);
      fetchSalons2();
    }
    fetchSalons();
    searchController.addListener(onSearchChanged);
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _onThemeChanged(bool isDarkMode) {
    // Add this method
    setState(() {
      _isDarkMode = isDarkMode;
    });
    (context as Element).reassemble();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchLocationName(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          locationName =
              '${place.name}, ${place.subLocality}, ${place.thoroughfare}';
        } else {
          locationName = 'Unknown location';
        }
      });
    } catch (e) {
      print('Error fetching location name: $e');
      setState(() {
        locationName = 'Error fetching location';
      });
    }
  }

  void onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        searchResults = [];
      });
    } else {
      searchSalonsByName(searchController.text);
    }
  }

  Future<void> searchSalonsByName(String query) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Salons')
        .where('salonName', isGreaterThanOrEqualTo: query)
        .where('salonName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    List<Map<String, dynamic>> fetchedSalons =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      searchResults = fetchedSalons;
    });
  }

  void fetchSalons2() async {
    if (widget.initialPosition == null) {
      print("No initial position provided");
      return;
    }

    double lat = widget.initialPosition!.latitude;
    double long = widget.initialPosition!.longitude;
    double radius = 0.009; // Roughly 1km

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Salons')
          .where('latitude',
              isGreaterThan: lat - radius, isLessThan: lat + radius)
          .get();

      List<Map<String, dynamic>> fetchedSalons = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double salonLongitude = data['longitude'];
        if (salonLongitude >= long - radius &&
            salonLongitude <= long + radius) {
          fetchedSalons.add({
            'name': data['salonName'] ?? 'No Name',
            'image': data['salonImageUrl'] ?? 'https://via.placeholder.com/150',
            'email': data['email'] ?? 'No Email',
          });
          print("Fetched Salon: $data");
        }
      }

      setState(() {
        nearbySalons = fetchedSalons;
      });
    } catch (e) {
      print("Error fetching salons within 1km: $e");
    }
  }

  void fetchSalons() async {
    FirebaseFirestore.instance.collection('Salons').get().then((snapshot) {
      List<Map<String, dynamic>> fetchedSalons = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> salon = doc.data() as Map<String, dynamic>;
        fetchedSalons.add({
          'name': salon['salonName'],
          'image': salon['salonImageUrl'],
          'email': salon['email'],
        });
      }

      setState(() {
        popularSalons = fetchedSalons;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: searchResults.isNotEmpty
                  ? buildSearchResults()
                  : buildBodyContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 13, 106, 101),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Text(
                  "StyleMe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.location_pin, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        locationName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.my_location, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: buildSearchBar(),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 13, 106, 101),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 1),
                  height: 100,
                  width: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "StyleMe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Times New Roman",
                  ),
                ),
                const Text(
                  "styleme@gmail.com",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Appointment'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingHistory()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('SettingUpBussiness'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => setupBussiness()));
            },
          ),
          ListTile(
            leading: Icon(Icons.policy),
            title: Text('PrivacyPolicy'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('Feedback'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()));
            },
          ),
          /*  ListTile(
            leading: Icon(Icons.back_hand),
            title: Text('Blog'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Blog()));
            },
          ),*/
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: _isDarkMode,
                    onThemeChanged: _onThemeChanged,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              signOut(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: buttonWidget(context),
          )
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

  Widget buildBodyContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          searchResults.isNotEmpty
              ? buildSearchResults()
              : buildRegularContent(),
        ],
      ),
    );
  }

  Widget buildRegularContent() {
    return Column(
      children: [
        buildSalonsNearbySection(),
        buildTopDealsSection(),
        buildPopularSalonsSection(context),
      ],
    );
  }

  Widget buildSalonCard(Map<String, dynamic> salon) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 13, 106, 101), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              salon['salonImageUrl'] ?? 'https://via.placeholder.com/150',
              width: 500,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              salon['salonName'] ?? 'No Name',
              style: GoogleFonts.prompt(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 106, 101),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Categories(
                    salonEmail: salon['email'],
                    salonName: salon['salonName'],
                    locationName: locationName,
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
            child: Text(
              'View Details',
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 13, 106, 101),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Salon',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return buildSalonCard(searchResults[index]);
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchTopDeals() async {
    try {
      QuerySnapshot<Map<String, dynamic>> dealsSnapshot =
          await FirebaseFirestore.instance.collection('SalonsDeals').get();

      return dealsSnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching top deals: $e');
      return [];
    }
  }

  Future<String> getSalonNameByEmail(String salonEmail) async {
    var salon = await FirebaseFirestore.instance
        .collection('Salons')
        .where('email', isEqualTo: salonEmail)
        .limit(1)
        .get();

    if (salon.docs.isNotEmpty) {
      return salon.docs.first.data()['salonName'];
    } else {
      return 'Salon not found';
    }
  }

  Widget buildTopDealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Top Deals",
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
          ),
        ),
        FutureBuilder(
          future: fetchTopDeals(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> deals = snapshot.data!;
              return Container(
                height: 330,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    String barberEmail = deals[index]['barberEmail'] ?? '';
                    String dealTitle = deals[index]['title'] ?? '';
                    return FutureBuilder(
                      future: getSalonNameByEmail(barberEmail),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> salonSnapshot) {
                        if (salonSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        String salonName =
                            salonSnapshot.data ?? 'Salon not found';
                        return buildDealCard(
                            deals[index],
                            salonName,
                            Color.fromARGB(255, 13, 106, 101),
                            context,
                            barberEmail,
                            dealTitle);
                      },
                    );
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No deals available at the moment.'),
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildDealCard(
      Map<String, dynamic> deal,
      String salonName,
      Color tealColor,
      BuildContext context,
      String barberEmail,
      String dealTitle) {
    return ClipOval(
      child: Container(
        width: 220,
        height: 220,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.network(
                deal['imageUrl'] ?? 'https://via.placeholder.com/150',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 1),
            Center(
              child: Text(
                deal['title'] ?? 'No Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tealColor,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 1),
            Center(
              child: Text(
                salonName,
                style: TextStyle(
                  color: tealColor,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DealDetailsScreen(
                      barberEmail: barberEmail,
                      dealTitle: dealTitle,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.arrow_forward_rounded,
                color: tealColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSalonsNearbySection() {
    String placeholderImageUrl = 'https://via.placeholder.com/50';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Salons Nearby",
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
          ),
        ),
        Container(
          height: 235,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: nearbySalons.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromARGB(255, 13, 106, 101), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            nearbySalons[index]['image'] ?? placeholderImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                              placeholderImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          nearbySalons[index]['name'] ?? 'No Name',
                          style: GoogleFonts.prompt(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 13, 106, 101),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          var salonEmail = nearbySalons[index]['email'];
                          var salonName = nearbySalons[index]['name'];
                          if (salonEmail == null || salonName == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Salon email or name is not available")));
                            return;
                          }
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SalonScreen(
                                salonEmail: salonEmail,
                                salonName: salonName,
                                locationName: locationName,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                        child: Text(
                          'View Details',
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 13, 106, 101),
                          ),
                        ),
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

  Widget buildPopularSalonsSection(BuildContext context) {
    String placeholderImageUrl = 'https://via.placeholder.com/150';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Popular Salons",
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: popularSalons.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromARGB(255, 13, 106, 101), width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      popularSalons[index]['image'] ?? placeholderImageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(
                        placeholderImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            popularSalons[index]['name'] ?? 'No Name',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 13, 106, 101),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      var salonEmail = popularSalons[index]['email'];
                      var salonName = popularSalons[index]['name'];
                      if (salonEmail == null || salonName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Salon email or name is not available")));
                        return;
                      }
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SalonScreen(
                            salonEmail: salonEmail,
                            salonName: salonName,
                            locationName: locationName,
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
                    child: Text(
                      'View Details',
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 13, 106, 101),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
