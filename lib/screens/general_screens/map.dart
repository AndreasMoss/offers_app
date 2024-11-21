import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/providers/map_provider.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';

/// BALE OTAN BAZEI MIA EPIXEIRISI PROSFORA NA APOTHIKEUEI STI PROSFORA TO LOCATION, ADDRESS TIS EPIXEIRISIS
///
///

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  final String _mapStyle = '''
[
    {
      "featureType": "poi.attraction",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.business",
      "stylers": [
        {
          "visibility": "off"
        },
        {
          "weight": 1
        }
      ]
    },
    {
      "featureType": "poi.business",
      "elementType": "labels.text",
      "stylers": [
        {
          "saturation": -25
        }
      ]
    },
    {
      "featureType": "poi.government",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.medical",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.place_of_worship",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.school",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.sports_complex",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.local",
      "stylers": [
        {
          "saturation": -40
        },
        {
          "lightness": 5
        }
      ]
    }
  ]
''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startingUserLocationFuture =
        ref.read(userStartingLocationProvider.future);
    final offersAsync = ref.watch(activeOffersStreamProvider);
    return offersAsync.when(
      data: (offers) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: textBlackB12,
            ),
            toolbarHeight: 70,
            title: Text('Filter offers with map',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: textBlackB12)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          body: FutureBuilder(
            future: startingUserLocationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error fetching location!'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                    child: Text('Could not determine location.'));
              }

              final LatLng userCurrentLocation = snapshot.data!;
              return GoogleMap(
                style: _mapStyle,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    userCurrentLocation.latitude,
                    userCurrentLocation.longitude,
                  ),
                  zoom: 14,
                ),
                markers: offers
                    .map(
                      (offer) => Marker(
                          markerId: MarkerId(offer.offerId),
                          position: LatLng(offer.location!.latitude,
                              offer.location!.longitude)),
                    )
                    .toSet(),
              );
            },
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body:
            Center(child: Text('ErrorAAAAAAAAIIIIIIIIIIAAAAAAAAAAAA: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
