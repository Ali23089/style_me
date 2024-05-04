import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberProfileScreen extends StatefulWidget {
  @override
  _BarberProfileScreenState createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<BarberProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> barberData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBarberData();
  }

  Future<void> fetchBarberData() async {
    setState(() => isLoading = true);
    if (user?.email != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Barber')
            .where('email', isEqualTo: user!.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            barberData = querySnapshot.docs.first.data();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          showSnackbar("No barber data found.");
        }
      } catch (e) {
        setState(() => isLoading = false);
        showSnackbar("Error fetching barber data: $e");
      }
    } else {
      setState(() => isLoading = false);
      showSnackbar("No user logged in.");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  Future<void> updateBarberData(String name, String salonName,
      String phoneNumber, String salonAddress) async {
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('Barber')
          .doc(user!.email) // Assuming you store barbers by their UID
          .update({
        'name': name,
        'salonName': salonName,
        'phoneNumber': phoneNumber,
        'salonAddress': salonAddress,
      });
      fetchBarberData(); // Refresh the data on screen
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      showSnackbar("Failed to update data: $e");
    }
  }

  Future<void> deleteBarberData() async {
    try {
      await FirebaseFirestore.instance
          .collection('Barber')
          .doc(user!.email)
          .delete();
      showSnackbar("Barber profile deleted successfully.");
      Navigator.of(context).pop(); // Going back to previous screen or home
    } catch (e) {
      showSnackbar("Failed to delete profile: $e");
    }
  }

  void showEditDialog() {
    TextEditingController nameController =
        TextEditingController(text: barberData['name']);
    TextEditingController salonNameController =
        TextEditingController(text: barberData['salonName']);
    TextEditingController phoneNumberController =
        TextEditingController(text: barberData['phoneNumber']);
    TextEditingController salonAddressController =
        TextEditingController(text: barberData['salonAddress']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: salonNameController,
                  decoration: InputDecoration(labelText: "Salon Name"),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
                TextField(
                  controller: salonAddressController,
                  decoration: InputDecoration(labelText: "Salon Address"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                updateBarberData(
                  nameController.text,
                  salonNameController.text,
                  phoneNumberController.text,
                  salonAddressController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barber Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchBarberData,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: showEditDialog,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteBarberData,
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        barberData['profileImageUrl'] ??
                            'assets/default_avatar.png'),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          //spread_radius: 2,
                          //blur_radius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow(
                            Icons.person, "Name: ${barberData['name']}"),
                        buildInfoRow(Icons.store,
                            "Salon Name: ${barberData['salonName']}"),
                        buildInfoRow(Icons.phone,
                            "Contact: ${barberData['phoneNumber']}"),
                        buildInfoRow(
                            Icons.email, "Email: ${user?.email ?? 'No email'}"),
                        buildInfoRow(Icons.location_on,
                            "Location: ${barberData['salonAddress']}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Flexible(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
