import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/filtering_provider.dart';
import 'package:offers_app/providers/map_provider.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/theme/custom_markers.dart';
import 'package:offers_app/theme/map_theme.dart';
import 'package:offers_app/widgets/offer_tile.dart';

/// kane to edit gia to profile twn epixeirisewn ena ena.
///
///

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  final String _mapStyle = mapTheme;

  @override
  ConsumerState<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _debounceTimer; //timer for debouncing
  LatLngBounds? _currentBounds;
  GoogleMapController? _mapController;
  double? _currentZoomLevel;

  Set<Marker> markers = {};

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<Set<Marker>> _createMarkers(List<Offer> offers) async {
    final Set<Marker> markers = {};

    for (var offer in offers) {
      int availability;
      if (offer.codes > 30) {
        availability = 1;
      } else if (offer.codes > 10) {
        availability = 2;
      } else {
        availability = 3;
      }

      final customMarker = await createCustomMarkerGreen(
          offer.profileImage,
          availability == 1
              ? Colors.green
              : availability == 2
                  ? Colors.yellow
                  : Colors.red);
      markers.add(
        Marker(
          markerId: MarkerId(offer.offerId),
          position: LatLng(
            offer.location.latitude,
            offer.location.longitude,
          ),
          onTap: () {
            _scaffoldKey.currentState?.showBottomSheet(
              (context) {
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
                        child: const Text('Return to map'),
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

  // Future<void> _setInitialBounds() async {
  //   final boundsNotifier = ref.read(boundsProvider.notifier);
  //   _currentBounds = await _mapController!.getVisibleRegion();
  //   boundsNotifier.setBounds(_currentBounds!);
  //   //print("Bounds: ${_currentBounds.toString()}");
  // }

  Future<void> _handleCameraIdle(int waitTime, BuildContext context) async {
    final boundsNotifier = ref.read(boundsProvider.notifier);
    final currentPositionNotifier = ref.read(currentMapImageProvider.notifier);
    final currentZoomNotifier = ref.read(currentZoomProvider.notifier);
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(seconds: waitTime), () async {
      _currentBounds = await _mapController!.getVisibleRegion();
      _currentZoomLevel = await _mapController!.getZoomLevel();
      boundsNotifier.setBounds(_currentBounds!);
      // boundsNotifier.printState();
      // print("Bounds: ${_currentBounds.toString()}");

      // final offers = ref.read(activeOffersStreamProvider).asData?.value ?? [];

      // final filteredOffers = offers.where((offer) {
      //   final location = offer.location;
      //   return _currentBounds!.contains(
      //     LatLng(location!.latitude, location.longitude),
      //   );
      // }).toList();
      final filteredOffers = ref.read(filteredListProvider);

      print(filteredOffers.length);

      if (context.mounted) {
        final newMarkers = await _createMarkers(filteredOffers);
        setState(() {
          markers = newMarkers;
        });
      }
      currentZoomNotifier.setCurrentZoom(_currentZoomLevel!);

      currentPositionNotifier.setCurrentImage(_currentBounds!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentImagePosition = ref.read(currentMapImageProvider);
    _currentZoomLevel = ref.read(currentZoomProvider);

    return Scaffold(
      key: _scaffoldKey,
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
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) async {
          _mapController = controller;
          // await _setInitialBounds();
          _handleCameraIdle(0, context);
        },
        style: widget._mapStyle,
        myLocationEnabled: true,
        rotateGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
          target: currentImagePosition!,
          zoom: _currentZoomLevel!,
        ),
        onCameraIdle: () {
          _handleCameraIdle(1, context);
        },
        markers: markers,

        // offers
        //     .map(
        //       (offer) => Marker(
        //           markerId: MarkerId(offer.offerId),
        //           position: LatLng(offer.location!.latitude,
        //               offer.location!.longitude)),
        //     )
        //     .toSet(),
      ),
    );
  }
}
