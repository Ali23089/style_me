import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_me/SalonScreen.dart';

class HomeContent extends StatefulWidget {
  final Position? initialPosition;

  const HomeContent({Key? key, this.initialPosition}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
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

class _HomeContentState extends State<HomeContent> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> nearbySalons = [];
  List<Map<String, dynamic>> popularSalons = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      fetchSalons2();
    }
    fetchSalons();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
      // Firestore does not support multiple range queries on different fields without a composite index.
      // You will need to create a composite index in Firestore for this query to work, or adjust the query to use a single range field.
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Salons')
          // First range filter on 'latitude'
          .where('latitude',
              isGreaterThan: lat - radius, isLessThan: lat + radius)
          .get();

      List<Map<String, dynamic>> fetchedSalons = [];

      // Filter by longitude in memory if necessary
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double salonLongitude = data['longitude'];
        if (salonLongitude >= long - radius &&
            salonLongitude <= long + radius) {
          fetchedSalons.add({
            'name': data['salonName'] ?? 'No Name',
            'image': data['salonImageUrl'] ?? 'https://via.placeholder.com/150',
            'rating': data['rating'] ?? 0,
            'email': data['email'] ?? 'No Email',
          });
          print("Fetched Salon: $data");
        }
      }

      setState(() {
        nearbySalons = fetchedSalons;
      });
    } catch (e) {
      print("Error fetching salons within 5km: $e");
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
          'rating': salon['rating'] ?? 0,
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
      appBar: AppBar(
        title: Text('StyleMe', style: GoogleFonts.nunitoSans()),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildSearchBar(),
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
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 2),
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
                color: Colors.teal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalonScreen(
                    salonEmail: salon['email'],
                    salonName: 'salonName',
                  ),
                ),
              );
            },
            child: Text(
              'View Details',
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.w800,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Salon',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
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
    QuerySnapshot dealsSnapshot =
        await FirebaseFirestore.instance.collection('deals').get();
    return dealsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
    Color tealColor = Colors.teal;
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
              color: tealColor,
            ),
          ),
        ),
        FutureBuilder(
          future: fetchTopDeals(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> deals = snapshot.data!;
              return Container(
                height: 270,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: getSalonNameByEmail(deals[index]['salonEmail']),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> salonSnapshot) {
                        if (salonSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loader until the salon name is fetched
                        }

                        String salonName =
                            salonSnapshot.data ?? 'Salon not found';
                        return buildDealCard(
                            deals[index], salonName, tealColor);
                      },
                    );
                  },
                ),
              );
            } else {
              return Text('No deals available at the moment.');
            }
          },
        ),
      ],
    );
  }

  Widget buildDealCard(
      Map<String, dynamic> deal, String salonName, Color tealColor) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle, // Make the card circular
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
              width: 150, // Diameter of the circle
              height: 150, // Diameter of the circle
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            deal['dealName'] ?? 'No Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tealColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Discount: ${deal['discount']}%',
            style: TextStyle(
              color: tealColor,
            ),
          ),
          Text(
            salonName,
            style: TextStyle(
              color: tealColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSalonsNearbySection() {
    Color tealColor = Colors.teal;

    // Placeholder image URL - replace with an appropriate one for your app
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
              color: tealColor,
            ),
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: nearbySalons.length, // Use nearbySalons here
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  color: Colors.white, // Set the card background to white
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: tealColor, width: 2), // Teal border
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 100,
                        child: ClipRRect(
                          // Rounded corners
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
                            color: tealColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          return Icon(
                            i < (nearbySalons[index]['rating'] ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: i < (nearbySalons[index]['rating'] ?? 0)
                                ? tealColor
                                : Colors.grey,
                          );
                        }),
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
                            MaterialPageRoute(
                              builder: (context) => SalonScreen(
                                salonEmail: salonEmail,
                                salonName:
                                    salonName, // Passing both salonEmail and salonName
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View Details',
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w800,
                            color: tealColor,
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
    Color tealColor = Colors.teal;
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
              color: tealColor,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Disables scrolling of this ListView
          itemCount: popularSalons.length, // Use popularSalons for item count
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: tealColor, width: 2), // Teal border
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
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
                              color: tealColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (i) {
                            return Icon(
                              i < (popularSalons[index]['rating'] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: i < (popularSalons[index]['rating'] ?? 0)
                                  ? tealColor
                                  : Colors.grey, // Teal stars for rating
                              size: 20, // Setting a fixed size for all icons
                            );
                          }),
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
                        MaterialPageRoute(
                          builder: (context) => SalonScreen(
                            salonEmail: salonEmail,
                            salonName:
                                salonName, // Passing both salonEmail and salonName
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View Details',
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w800,
                        color: tealColor,
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
