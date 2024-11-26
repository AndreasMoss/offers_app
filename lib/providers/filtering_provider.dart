import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BoundsNotifier extends StateNotifier<LatLngBounds> {
  BoundsNotifier()
      : super(LatLngBounds(
            southwest: const LatLng(34.8194, 19.3736),
            northeast: const LatLng(41.7489, 26.6042)));

  void setBounds(LatLngBounds bounds) {
    state = bounds;
  }

  void printState() {
    print(state);
  }
}

final boundsProvider = StateNotifierProvider<BoundsNotifier, LatLngBounds>(
  (ref) => BoundsNotifier(),
);
