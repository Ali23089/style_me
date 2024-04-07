import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class Converter extends StatefulWidget {
  const Converter({Key? key}) : super(key: key);

  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  String PlaceM = " ";
  String Address_On_Screen = ' ';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.teal,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Address_On_Screen),
            Text(PlaceM),
            GestureDetector(
              onTap: () async {
                List<Location> location =
                    await locationFromAddress('Pakistan, Lahore');

                List<Placemark> placemarks = await placemarkFromCoordinates(
                  31.57443258442658,
                  74.41356717352804,
                );
                setState(() {
                  PlaceM = '${placemarks.reversed.last.country}'
                      '${placemarks.reversed.last.locality}';

                  Address_On_Screen =
                      '${location.last.longitude}' '${location.last.latitude}';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(color: Colors.tealAccent),
                  child: Center(
                    child: Text('Hit to Convert'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
