import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_me/HomeScreen.dart';
import 'package:style_me/hh.dart';

class Get_Location extends StatefulWidget {
  const Get_Location({Key? key}) : super(key: key);

  @override
  State<Get_Location> createState() => _Get_LocationState();
}

class _Get_LocationState extends State<Get_Location> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> myMarkers = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _saveLocationOnLogin();
  }

  void _initializeMarkers() {
    myMarkers.add(Marker(
      markerId: MarkerId("First"),
      position: LatLng(31.58894855147015, 74.42132446174648),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      infoWindow: InfoWindow(title: 'My Home'),
    ));
    myMarkers.add(Marker(
      markerId: MarkerId("Second"),
      position: LatLng(31.49030894293375, 74.38697665082525),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'Salon'),
    ));
    myMarkers.add(Marker(
      markerId: MarkerId("Third"),
      position: LatLng(30.17663657161897, 71.48763589841042),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: 'Gol Plot'),
    ));
  }

  Future<void> _saveLocationOnLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        Position position = await _determinePosition();
        _saveLocationToFirestore(user.email, position);
      }
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _saveLocationToFirestore(
      String? email, Position position) async {
    if (email != null) {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: email)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        var userId = userSnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('User').doc(userId).update({
          'Location': {
            'latitude': position.latitude,
            'longitude': position.longitude
          },
        });
        setState(() {
          myMarkers.add(Marker(
            markerId: MarkerId('Current'),
            position: LatLng(position.latitude, position.longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: 'Your Location'),
          ));
        });
      }
    }
  }

  void navigateToHomeScreen(Position currentPosition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(initialPosition: currentPosition),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Select Location', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(31.58894855147015, 74.42132446174648),
          zoom: 15,
        ),
        mapType: MapType.normal,
        markers: myMarkers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _determinePosition();
          await _saveLocationToFirestore(
              FirebaseAuth.instance.currentUser?.email, position);
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude)));
        },
        child: Icon(Icons.my_location, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
        tooltip: 'Find and save your current location',
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color.fromARGB(255, 13, 106, 101),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.navigate_next, color: Colors.white),
              onPressed: () async {
                Position currentPosition = await _determinePosition();
                navigateToHomeScreen(currentPosition);
              },
            ),
          ],
        ),
      ),
    );
  }
}
