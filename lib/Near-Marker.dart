import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NearbySalonsMapScreen extends StatefulWidget {
  const NearbySalonsMapScreen({Key? key}) : super(key: key);

  @override
  State<NearbySalonsMapScreen> createState() => _NearbySalonsMapScreenState();
}

class _NearbySalonsMapScreenState extends State<NearbySalonsMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> myMarkers = {};
  Position? currentPosition;
  List<Map<String, dynamic>> nearbySalons = [];
  Map<String, dynamic>? selectedSalon;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _getCurrentLocationAndNearbySalons();
  }

  void _initializeMarkers() {
    // Add initial markers if needed
  }

  Future<void> _getCurrentLocationAndNearbySalons() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        currentPosition = position;
        myMarkers.add(Marker(
          markerId: MarkerId('Current'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Your Location'),
        ));
      });
      _fetchNearbySalons(position);
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _fetchNearbySalons(Position position) async {
    double lat = position.latitude;
    double long = position.longitude;
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
            'latitude': data['latitude'],
            'longitude': data['longitude'],
            'address': data['address'] ?? 'No Address',
            'rating': data['rating'] ?? 0,
          });
        }
      }

      setState(() {
        nearbySalons = fetchedSalons;
        for (var salon in nearbySalons) {
          myMarkers.add(Marker(
            markerId: MarkerId(salon['name']),
            position: LatLng(salon['latitude'], salon['longitude']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                174.0), // Custom hue value for teal
            infoWindow: InfoWindow(
              title: salon['name'],
              snippet: 'Tap for details',
              onTap: () {
                setState(() {
                  selectedSalon = salon;
                });
                _showSalonDetails(salon);
              },
            ),
          ));
        }
      });
    } catch (e) {
      print('Error fetching nearby salons: $e');
    }
  }

  void _showSalonDetails(Map<String, dynamic> salon) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(salon['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(salon['address']),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(salon['rating'].toString(),
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to the salon details page if needed
                },
                child: Text('View Details'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 13, 106, 101)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Nearby Salons', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
      body: Stack(
        children: [
          currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentPosition!.latitude, currentPosition!.longitude),
                    zoom: 15,
                  ),
                  mapType: MapType.normal,
                  markers: myMarkers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                if (currentPosition != null) {
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                    CameraUpdate.newLatLng(LatLng(
                        currentPosition!.latitude, currentPosition!.longitude)),
                  );
                }
              },
              child: Icon(Icons.my_location, color: Colors.white),
              backgroundColor: Color.fromARGB(255, 13, 106, 101),
            ),
          ),
        ],
      ),
    );
  }
}
