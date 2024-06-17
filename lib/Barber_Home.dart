import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_me/AddDeal.dart';
import 'package:style_me/AddService.dart';
import 'package:style_me/Barber_Profile.dart';
import 'package:style_me/Blog.dart';
import 'package:style_me/Edit_Services.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/Login.dart';
import 'package:style_me/edit_deals.dart';
import 'package:style_me/firebase_functions.dart';

class BarberScreen extends StatefulWidget {
  @override
  _BarberScreenState createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  bool _isHomeServiceEnabled = false;
  bool _isFABOpen = false;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> deals = [];
  Map<String, dynamic>? barberData;
  Map<String, dynamic>? salonData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      try {
        final barberSnapshot = await FirebaseFirestore.instance
            .collection('Barber')
            .where('email', isEqualTo: currentUser.email)
            .get();

        final salonSnapshot = await FirebaseFirestore.instance
            .collection('Salons')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (mounted) {
          setState(() {
            if (barberSnapshot.docs.isNotEmpty) {
              barberData =
                  barberSnapshot.docs.first.data() as Map<String, dynamic>?;
              fetchServices(barberData!['email']);
              fetchAppointments(barberData!['email']);
              fetchDeals(barberData!['email']);
            }
            if (salonSnapshot.docs.isNotEmpty) {
              salonData =
                  salonSnapshot.docs.first.data() as Map<String, dynamic>?;
              fetchServices(salonData!['email']);
              fetchAppointments(salonData!['email']);
              fetchDeals(salonData!['email']);
            }
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching details: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchServices(String email) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('barberEmail', isEqualTo: email)
        .get();

    if (mounted) {
      setState(() {
        services = snapshot.docs
            .map((doc) => {
                  'serviceId': doc.id,
                  'productName': doc.data().containsKey('productName')
                      ? doc['productName']
                      : null,
                  'description': doc.data().containsKey('description')
                      ? doc['description']
                      : null,
                  'price': doc.data().containsKey('price')
                      ? doc['price'].toString()
                      : null,
                  'category': doc.data().containsKey('category')
                      ? doc['category']
                      : null,
                  'imageUrl': doc.data().containsKey('imageUrl')
                      ? doc['imageUrl']
                      : null,
                })
            .toList();
      });
    }
  }

  Future<void> fetchAppointments(String email) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('salonEmail', isEqualTo: email)
        .get();

    if (mounted) {
      setState(() {
        bookings = snapshot.docs
            .map((doc) => {
                  'appointmentId': doc.id,
                  'date': doc.data().containsKey('date') ? doc['date'] : null,
                  'time': doc.data().containsKey('time') ? doc['time'] : null,
                  'salonName': doc.data().containsKey('salonName')
                      ? doc['salonName']
                      : null,
                  'serviceName': doc.data().containsKey('serviceDetails')
                      ? doc['serviceDetails']['serviceName']
                      : null,
                  'servicePrice': doc.data().containsKey('serviceDetails')
                      ? doc['serviceDetails']['servicePrice']
                      : null,
                  'userEmail': doc.data().containsKey('userEmail')
                      ? doc['userEmail']
                      : null,
                  'serviceType': doc.data().containsKey('serviceType')
                      ? doc['serviceType']
                      : null,
                  'homeServiceDetails':
                      doc.data().containsKey('homeServiceDetails')
                          ? doc['homeServiceDetails']
                          : null,
                })
            .toList();
      });
    }
  }

  Future<void> fetchDeals(String email) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('SalonsDeals')
        .where('barberEmail', isEqualTo: email)
        .get();

    if (mounted) {
      setState(() {
        deals = snapshot.docs.map((doc) {
          var data = doc.data();
          return {
            'description':
                data.containsKey('description') ? data['description'] : null,
            'discountedPrice': data.containsKey('discountedPrice')
                ? data['discountedPrice']
                : null,
            'endDate': data.containsKey('endDate') ? data['endDate'] : null,
            'imageUrl': data.containsKey('imageUrl') ? data['imageUrl'] : null,
            'originalPrice': data.containsKey('originalPrice')
                ? data['originalPrice']
                : null,
            'serviceIds':
                data.containsKey('serviceIds') ? data['serviceIds'] : null,
            'startDate':
                data.containsKey('startDate') ? data['startDate'] : null,
            'title': data.containsKey('title') ? data['title'] : null,
          };
        }).toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  width: 120, // Define the width to maintain the circle shape
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
            leading: Icon(Icons.home_repair_service),
            title: Text('Services'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Appointments'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Deals'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Service'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _isHomeServiceEnabled = !_isHomeServiceEnabled;
              });
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
          ListTile(
            leading: Icon(Icons.back_hand),
            title: Text('Blog'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Blog()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              /*Navigator.push(
                context,
               MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: _isDarkMode,
                    onThemeChanged: _onThemeChanged,
                  ),
                ),
              );*/
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              signOut(context);
            },
          ),
          SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 13, 106, 101),
                  ),
                ),
                child: Text(
                  "User Mode",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Barber Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BarberDetails()),
              );
            },
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildContent()),
              ],
            ),
      floatingActionButton: _buildFloatingActionButtons(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Deals',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 13, 106, 101),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildServices();
      case 1:
        return _buildAppointments();
      case 2:
        return _buildDeals();
      default:
        return Center(child: Text('Unknown page'));
    }
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 13, 106, 101),
                Color.fromARGB(255, 13, 106, 101),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage('assets/header_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 14,
          left: 25,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: barberData?['profileImageUrl'] != null
                ? NetworkImage(barberData!['profileImageUrl'])
                : AssetImage('assets/placeholder_image.png') as ImageProvider,
          ),
        ),
        Positioned(
          top: 30,
          left: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${barberData?['name'] ?? 'Barber'}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                salonData?['salonName'] ?? 'Salon',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointments() {
    return RefreshIndicator(
      onRefresh: () => fetchAppointments(barberData!['email']),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final appointment = bookings[index];
                return Card(
                  color: Color.fromARGB(255, 13, 106, 101),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.event, color: Colors.white),
                    title: Text(
                      appointment['serviceName'] ?? 'Service Type Unspecified',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Date & Time: ${appointment['date']} at ${appointment['time']}\nUser Email: ${appointment['userEmail']}\nService Type: ${appointment['serviceType']?.toString().split('.').last ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      if (appointment['homeServiceDetails'] != null) {
                        _showHomeServiceDetailsDialog(
                            context, appointment['homeServiceDetails']);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHomeServiceDetailsDialog(
      BuildContext context, Map<String, dynamic> homeServiceDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Home Service Details',
            style: TextStyle(
                color: Color.fromARGB(255, 13, 106, 101),
                fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.home,
                      size: 15, color: Color.fromARGB(255, 13, 106, 101)),
                  SizedBox(width: 5),
                  Text(homeServiceDetails['address'] ?? 'No Address',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 106, 101))),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone,
                      size: 15, color: Color.fromARGB(255, 13, 106, 101)),
                  SizedBox(width: 5),
                  Text(
                      homeServiceDetails['contactNumber'] ??
                          'No Contact Number',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 106, 101))),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 15, color: Color.fromARGB(255, 13, 106, 101)),
                  SizedBox(width: 5),
                  Text(homeServiceDetails['locationName'] ?? 'No Location',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 106, 101))),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email,
                      size: 15, color: Color.fromARGB(255, 13, 106, 101)),
                  SizedBox(width: 5),
                  Text(homeServiceDetails['userEmail'] ?? 'No Email',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 106, 101))),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.person,
                      size: 15, color: Color.fromARGB(255, 13, 106, 101)),
                  SizedBox(width: 5),
                  Text(homeServiceDetails['userName'] ?? 'No Name',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 106, 101))),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Color.fromARGB(255, 13, 106, 101)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildServices() {
    return RefreshIndicator(
      onRefresh: () => fetchServices(barberData!['email']),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  color: Color.fromARGB(255, 13, 106, 101),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: service['imageUrl'] != null
                        ? Image.network(service['imageUrl'],
                            width: 50, height: 50)
                        : Icon(Icons.content_cut, color: Colors.white),
                    title: Text(
                      service['productName'] ?? 'Unnamed Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      '${service['description'] ?? 'No description provided'} - Price: ${service['price'] ?? '0'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditServiceScreen(
                              service: service,
                              serviceId: service['serviceId'],
                            ),
                          ),
                        );
                        if (result == true) {
                          // If the service was updated, refresh the services list
                          fetchServices(barberData!['email']);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeals() {
    return RefreshIndicator(
      onRefresh: () => fetchDeals(barberData!['email']),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Deals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 106, 101),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Card(
                  color: Color.fromARGB(255, 13, 106, 101),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: deal['imageUrl'] != null
                        ? Image.network(deal['imageUrl'], width: 50, height: 50)
                        : Icon(Icons.local_offer, color: Colors.white),
                    title: Text(
                      deal['title'] ?? 'Unnamed Deal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Discounted Price: ${deal['discountedPrice'] ?? 'N/A'}\nOriginal Price: ${deal['originalPrice'] ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        if (deal['title'] != null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDealScreen(
                                deal: deal,
                                dealId: deal['title'],
                              ),
                            ),
                          );
                          if (result == true) {
                            // If the deal was updated, refresh the deals list
                            fetchDeals(barberData!['email']);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Deal ID is missing. Cannot edit this deal.')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isFABOpen)
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddServiceScreen()),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              "Add Service",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        if (_isFABOpen) SizedBox(height: 10),
        if (_isFABOpen)
          FloatingActionButton.extended(
            heroTag: "fab1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDealScreen(
                        barberEmail: FirebaseAuth.instance.currentUser?.email)),
              );
            },
            icon: Icon(
              Icons.local_offer,
              color: Colors.white,
            ),
            label: Text(
              "Add Deal",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        if (_isFABOpen) SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "fab2",
          onPressed: () {
            setState(() {
              _isFABOpen = !_isFABOpen;
            });
          },
          child: Icon(
            _isFABOpen ? Icons.close : Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 13, 106, 101),
        ),
      ],
    );
  }
}
