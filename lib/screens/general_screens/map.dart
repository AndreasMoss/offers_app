import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      print("ERROR WITH GETTING CURRENT LOCATION");
      return;
    }
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey');

    final response = await http.get(url);

    final resData = json.decode(response.body);
    // response body tha einai se morfi string, opote me to json.decode metatrepetai se morfi eukoli gia epejergasia.

    final address = resData['results'][0]['formatted_address'];

    print("current location:");
    print(address);

    print(lat);
    print(lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'This will be the Map Screen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Get current Location'))
          ],
        ),
      ),
    );
  }
}
