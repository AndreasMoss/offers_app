import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/providers/map_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startingUserLocationFuture =
        ref.read(userStartingLocationProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FutureBuilder(
        future: startingUserLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching location!'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Could not determine location.'));
          }

          final LatLng userCurrentLocation = snapshot.data!;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                userCurrentLocation.latitude,
                userCurrentLocation.longitude,
              ),
              zoom: 14,
            ),
          );
        },
      ),
    );
  }
}
