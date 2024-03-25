import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_me/HomeScreen.dart';

class Get_Location extends StatefulWidget {
  const Get_Location({Key? key}) : super(key: key);

  @override
  State<Get_Location> createState() => _Get_LocationState();
}

class _Get_LocationState extends State<Get_Location> {
  final Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.58894855147015, 74.42132446174648),
    zoom: 15,
  );

  final List<Marker> myMarker = [];
  final List<Marker> markerList = const [
    Marker(
        markerId: MarkerId("First"),
        position: LatLng(31.58894855147015, 74.42132446174648),
        infoWindow: InfoWindow(title: 'My Home')),
    Marker(
        markerId: MarkerId("Second"),
        position: LatLng(31.49030894293375, 74.38697665082525),
        infoWindow: InfoWindow(title: 'Salon')),
    Marker(
        markerId: MarkerId("Third"),
        position: LatLng(30.17663657161897, 71.48763589841042),
        infoWindow: InfoWindow(title: 'Gol Plot')),
  ];

  late Marker _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
    _currentLocationMarker = Marker(
      markerId: MarkerId('Current'),
      position: LatLng(0, 0),
      infoWindow: InfoWindow(title: 'Current Location'),
    );
    _saveLocationOnLogin();
  }

  Future<Position> getLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  void _saveLocationOnLogin() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // User is logged in, save location
        _saveLocationToFirestore();
      }
    });
  }

  Future<void> _saveLocationToFirestore() async {
    try {
      Position position = await getLocation();
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // Get user document reference by email
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('Email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          String userId = userSnapshot.docs.first.id;
          // Save location to Firestore
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .update({
            'Location': {
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
          });
        }
      }
      // Update marker position
      setState(() {
        _currentLocationMarker = _currentLocationMarker.copyWith(
          positionParam: LatLng(position.latitude, position.longitude),
        );
      });
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: MapType.normal,
            markers: Set<Marker>.of([...myMarker, _currentLocationMarker]),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                await _saveLocationToFirestore();
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newLatLng(_currentLocationMarker.position));
              },
              child:
                  Text('Set Location', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 13, 106, 101), // Desired color
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Next', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 13, 106, 101), // Desired color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
