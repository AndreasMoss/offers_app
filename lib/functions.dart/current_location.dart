import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:offers_app/models/for_maps.dart';
import 'package:http/http.dart' as http;

String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

// boithitiki
Future<String> locationToAddress(
    {required double latitude, required double longtitude}) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longtitude&key=$googleMapsApiKey');

  final response = await http.get(url);

  final resData = json.decode(response.body);
  // response body tha einai se morfi string, opote me to json.decode metatrepetai se morfi eukoli gia epejergasia.

  final address = resData['results'][0]['formatted_address'];

  // print("current location:");
  // print(address);

  return address;
}

Future<PlaceLocation?> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  locationData = await location.getLocation();
  final lat = locationData.latitude;
  final lng = locationData.longitude;
  if (lat == null || lng == null) {
    print("ERROR WITH GETTING CURRENT LOCATION");
    return null;
  }

  final address = await locationToAddress(latitude: lat, longtitude: lng);

  return PlaceLocation(latitude: lat, longtitude: lng, address: address);
}
