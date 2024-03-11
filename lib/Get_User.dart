import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
    packData();
  }

  Future<Position> getLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  void packData() {
    getLocation().then((value) async {
      // Prompt user to input a name for the location
      TextEditingController locationNameController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Location Name'),
            content: TextField(
              controller: locationNameController,
              decoration: InputDecoration(hintText: 'Location Name'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  String locationName = locationNameController.text.trim();
                  if (locationName.isNotEmpty) {
                    saveLocationToFirestore(
                        value.latitude, value.longitude, locationName);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> saveLocationToFirestore(
      double latitude, double longitude, String locationName) async {
    // Initialize Firebase if not already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // Get Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Save location data to Firestore
    await firestore.collection('Location').add({
      'latitude': latitude,
      'longitude': longitude,
      'name': locationName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: MapType.normal,
            markers: Set<Marker>.of(myMarker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: packData,
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
                backgroundColor: Color.fromARGB(255, 13, 106, 101),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
