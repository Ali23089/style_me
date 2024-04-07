import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Places extends StatefulWidget {
  const Places({Key? key}) : super(key: key);
  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  String tokenforSession = '37465';
  var uuid = Uuid();

  final TextEditingController _controller = TextEditingController();

  List<dynamic> listforplaces = [];

  void makesuggestion(String input) async {
    String googlePlacesApiKey =
        "AIzaSyBjy7ZhrjIhu7HC_1YB6qo7mPhB02aCf74"; // Replace with your API key
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenforSession';

    var responseResult = await http.get(Uri.parse(request));

    var Resultdata = responseResult.body.toString();

    print('Result Data');
    print(Resultdata);

    if (responseResult.statusCode == 200) {
      setState(() {
        listforplaces =
            jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception('Showing data Failed / Try again');
    }
  }

  void onModify() {
    if (tokenforSession == null) {
      setState(() {
        tokenforSession = uuid.v4();
      });
    }

    makesuggestion(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }
  //final TextEditingController _controller = TextEditingController();

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
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Places API"),
          flexibleSpace: Container(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Search Here'),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listforplaces.length,
                    itemBuilder: (context, Index) {
                      return ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              listforplaces[Index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.longitude);
                        },
                        title: Text(listforplaces[Index]['description']),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
