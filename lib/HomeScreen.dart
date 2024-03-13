import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:style_me/Appointment.dart';
import 'package:style_me/Blog.dart';
import 'package:style_me/Booking.dart';
import 'package:style_me/Categories.dart';
import 'package:style_me/Feedback.dart';
import 'package:style_me/Header.dart';
import 'package:style_me/History.dart';
import 'package:style_me/Nav_Bar.dart';
import 'package:style_me/SalonScreen.dart';
import 'package:style_me/Settings.dart';
import 'package:style_me/SetupBussiness.dart';
import 'package:style_me/UserProfile.dart';
import 'package:style_me/ff.dart';
import 'package:style_me/privacyPolicy.dart';

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

  final TextEditingController _controller = TextEditingController();

  var _pageData = [
    HomeScreen(),
    HistoryScreen(),
    UserProfile(userId: "HlISRugiLox9RxIhmof2")
  ];

  @override
  Widget build(BuildContext context) {
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
                icon: Icons.person,
                text: "Account",
              ),
              GButton(
                icon: Icons.inbox_rounded,
                text: "Cart",
              ),
            ],
            selectedIndex: _selectedItem,
            onTabChange: (Index) {
              setState(() {
                _selectedItem = Index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _pageData[Index]),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
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
              ),
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
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/sn1.jpg'),
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 11),
                height: 200,
                decoration: BoxDecoration(
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
                ),
              )
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
                  MaterialPageRoute(builder: (context) => AppointmentScreen()),
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
