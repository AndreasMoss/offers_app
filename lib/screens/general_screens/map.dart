import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/map_provider.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/theme/custom_markers.dart';
import 'package:offers_app/widgets/offer_tile.dart';

/// kane to edit gia to profile twn epixeirisewn ena ena.
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

  Future<Set<Marker>> _createMarkers(
      List<Offer> offers, BuildContext ctx) async {
    final Set<Marker> markers = {};

    for (var offer in offers) {
      final customMarker = await createCustomMarker(offer.profileImage!);
      markers.add(
        Marker(
          markerId: MarkerId(offer.offerId),
          position: LatLng(
            offer.location!.latitude,
            offer.location!.longitude,
          ),
          onTap: () {
            showBottomSheet(
              context: ctx,
              builder: (BuildContext context) {
                return Container(
                  height: 353, // Ύψος του BottomSheet
                  padding: const EdgeInsets.all(16),

                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Το υπόλοιπο περιεχόμενο του BottomSheet
                      Text(
                        'Offer Details',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: textBlackB12),
                      ),
                      const SizedBox(height: 32),
                      OfferTile(offer: offer),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Κλείνει το BottomSheet
                        },
                        child: Text('Return to map'),
                      ),
                    ],
                  ),
                );
              },
            );
          },

          icon: customMarker,
          // infoWindow: InfoWindow(
          //   title: offer.businessId,
          //   snippet: offer.description,
          // ),
        ),
      );
    }

    return markers;
  }

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

              return FutureBuilder(
                  future: _createMarkers(offers, context),
                  builder: (ctx, markersSnapshot) {
                    if (markersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (markersSnapshot.hasError) {
                      return const Center(
                          child: Text('Error creating markers.'));
                    }

                    final markers = markersSnapshot.data ?? {};

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
                      markers: markers,

                      // offers
                      //     .map(
                      //       (offer) => Marker(
                      //           markerId: MarkerId(offer.offerId),
                      //           position: LatLng(offer.location!.latitude,
                      //               offer.location!.longitude)),
                      //     )
                      //     .toSet(),
                    );
                  });
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
