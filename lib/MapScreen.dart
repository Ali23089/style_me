import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
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
        infoWindow: InfoWindow(title: 'My Position')),
    Marker(
        markerId: MarkerId("Second"),
        position: LatLng(31.49030894293375, 74.38697665082525),
        infoWindow: InfoWindow(title: 'Salon')),
    Marker(
        markerId: MarkerId("Third"),
        position: LatLng(30.17663657161897, 71.48763589841042),
        infoWindow: InfoWindow(title: 'Gol Plot'))
  ];
  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
              CameraUpdate.newCameraPosition(const CameraPosition(
            target: LatLng(30.17663657161897, 71.48763589841042),
            zoom: 14,
          )));
        },
      ),
    );
  }
}
