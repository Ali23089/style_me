import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  int totalUsers = 0;
  int totalSalons = 0;
  int totalBarbers = 0;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> salons = [];
  List<Map<String, dynamic>> barbers = [];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    fetchCounts();
    fetchDetails();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchCounts() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').get();
      QuerySnapshot salonSnapshot =
          await FirebaseFirestore.instance.collection('Salons').get();
      QuerySnapshot barberSnapshot =
          await FirebaseFirestore.instance.collection('Barber').get();

      setState(() {
        totalUsers = userSnapshot.docs.length;
        totalSalons = salonSnapshot.docs.length;
        totalBarbers = barberSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  Future<void> fetchDetails() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').get();
      QuerySnapshot salonSnapshot =
          await FirebaseFirestore.instance.collection('Salons').get();
      QuerySnapshot barberSnapshot =
          await FirebaseFirestore.instance.collection('Barber').get();

      setState(() {
        users = userSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        salons = salonSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        barbers = barberSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 106, 101),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircularIndicator(
                    title: 'Total Users',
                    count: totalUsers,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 16),
                  CircularIndicator(
                    title: 'Total Salons',
                    count: totalSalons,
                    color: Colors.green,
                  ),
                  SizedBox(width: 16),
                  CircularIndicator(
                    title: 'Total Barbers',
                    count: totalBarbers,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              labelColor: Color.fromARGB(255, 13, 106, 101),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color.fromARGB(255, 13, 106, 101),
              tabs: [
                Tab(text: 'Users'),
                Tab(text: 'Salons'),
                Tab(text: 'Barbers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildUserListView(users),
                  buildSalonListView(salons),
                  buildBarberListView(barbers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserListView(List<Map<String, dynamic>> items) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: items.map((item) => UserInfoCard(data: item)).toList(),
    );
  }

  Widget buildSalonListView(List<Map<String, dynamic>> items) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: items.map((item) => SalonInfoCard(data: item)).toList(),
    );
  }

  Widget buildBarberListView(List<Map<String, dynamic>> items) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: items.map((item) => BarberInfoCard(data: item)).toList(),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  CircularIndicator({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 5.0,
          percent: 1.0,
          center: Text(
            count.toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          backgroundColor: Colors.grey.shade200,
          progressColor: color,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  UserInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 40,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['Name'] ?? 'No name available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['Email'] ?? 'No email available',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  if (data.containsKey('Location'))
                    Text(
                      'Location: ${data['Location']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalonInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  SalonInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.store,
              size: 40,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['salonName'] ?? 'No salon name available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['email'] ?? 'No email available',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  if (data.containsKey('salonAddress'))
                    Text(
                      'Address: ${data['salonAddress']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  if (data.containsKey('category'))
                    Text(
                      'Category: ${data['category']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  if (data.containsKey('salonContact'))
                    Text(
                      'Contact: ${data['salonContact']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarberInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  BarberInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.content_cut,
              size: 40,
              color: Color.fromARGB(255, 13, 106, 101),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'No name available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['email'] ?? 'No email available',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  if (data.containsKey('phoneNumber'))
                    Text(
                      'Phone: ${data['phoneNumber']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
