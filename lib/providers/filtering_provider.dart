import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/offers_list_provider.dart';

class BoundsNotifier extends StateNotifier<LatLngBounds> {
  BoundsNotifier()
      : super(LatLngBounds(
            southwest: const LatLng(34.8194, 19.3736),
            northeast: const LatLng(41.7489, 26.6042)));

  void setBounds(LatLngBounds bounds) {
    state = bounds;
    print('THOSE ARE MY BOUNDSSSS: $state');
  }

  // void printState() {
  //   print(state);
  // }
}

final boundsProvider = StateNotifierProvider<BoundsNotifier, LatLngBounds>(
  (ref) => BoundsNotifier(),
);

//////////////////////////////////////////////////////////////////////////

class CategoryNotifier extends StateNotifier<OfferCategory> {
  CategoryNotifier() : super(OfferCategory.all);

  void setCategory(OfferCategory category) {
    state = category;
    print('THIS IS MY CATEGORY state: $state');
  }
}

final categoryFilterProvider =
    StateNotifierProvider<CategoryNotifier, OfferCategory>(
  (ref) => CategoryNotifier(),
);

/////////////////////////////////////////////////////////////////////////////////////

final filteredListProvider = Provider((ref) {
  final offers = ref.watch(activeOffersStreamProvider).asData?.value ?? [];
  final bounds = ref.watch(boundsProvider);

  final filteredOffers = offers.where((offer) {
    final location = offer.location;
    return bounds.contains(
      LatLng(location!.latitude, location.longitude),
    );
  }).toList();

  return filteredOffers;
});
