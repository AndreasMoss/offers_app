import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:offers_app/providers/user_provider.dart';

String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

final userStartingLocationProvider = FutureProvider<LatLng?>(
  (ref) async {
    ref.watch(authStateProvider);
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

    return LatLng(lat, lng);
  },
);

class CurrentMapImageNotifier extends StateNotifier<LatLng> {
  CurrentMapImageNotifier(super.initialLocation);

  void setCurrentImage(LatLngBounds bounds) {
    final double centerLat =
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
    final double centerLng =
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2;

    state = LatLng(centerLat, centerLng);
  }

  // void printState() {
  //   print(state);
  // }
}

final currentMapImageProvider =
    StateNotifierProvider<CurrentMapImageNotifier, LatLng?>((ref) {
  // Διαβάζουμε την αρχική τοποθεσία από το userStartingLocationProvider
  final startingLocation = ref.read(userStartingLocationProvider).value;

  // Αν δεν υπάρχει αρχική τοποθεσία, θέτουμε μια προκαθορισμένη τιμή
  final initialLocation = startingLocation ?? LatLng(0.0, 0.0);

  // Επιστρέφουμε το Notifier με την αρχικοποιημένη τοποθεσία
  return CurrentMapImageNotifier(initialLocation);
});

class CurrentZoomNotifier extends StateNotifier<double> {
  CurrentZoomNotifier() : super(14);

  void setCurrentZoom(double zoom) {
    state = zoom;
  }

  // void printState() {
  //   print(state);
  // }
}

final currentZoomProvider =
    StateNotifierProvider<CurrentZoomNotifier, double?>((ref) {
  return CurrentZoomNotifier();
});
