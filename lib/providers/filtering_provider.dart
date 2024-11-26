// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:offers_app/models/offer.dart';
// import 'package:offers_app/providers/offers_list_provider.dart';

// class FilteredOffersNotifier extends StateNotifier<List<Offer>> {
//   FilteredOffersNotifier(this.ref) : super([]) {
//     // Παρακολουθούμε το activeOffersStreamProvider για να πάρουμε τις προσφορές
//     ref.listen<AsyncValue<List<Offer>>>(activeOffersStreamProvider,
//         (_, offersState) {
//       offersState.whenData((offers) {
//         // Αρχικοποιούμε τις φιλτραρισμένες προσφορές όταν οι ενεργές προσφορές είναι διαθέσιμες
//         updateFilteredOffers(offers);
//       });
//     });
//   }

//   final Ref ref;
//   LatLngBounds? _currentBounds;

//   // Ενημέρωση των φιλτραρισμένων προσφορών
//   void updateFilteredOffers(List<Offer> allOffers) {
//     final visibleOffers = allOffers.where((offer) {
//       final offerLocation =
//           LatLng(offer.location!.latitude, offer.location!.longitude);
//       return _currentBounds?.contains(offerLocation) ?? false;
//     }).toList();

//     state =
//         visibleOffers; // Ενημερώνουμε το state με τις φιλτραρισμένες προσφορές
//   }

//   // Μέθοδος για να ενημερώσουμε τα bounds (για χρήση από τον MapScreen)
//   void updateBounds(LatLngBounds bounds) {
//     _currentBounds = bounds;
//     // Αν υπάρχουν ήδη προσφορές, φιλτράρουμε ξανά
//     final currentOffers =
//         ref.read(activeOffersStreamProvider).asData?.value ?? [];
//     updateFilteredOffers(currentOffers);
//   }
// }

// final filteredOffersNotifierProvider =
//     StateNotifierProvider<FilteredOffersNotifier, List<Offer>>(
//   (ref) => FilteredOffersNotifier(ref),
// );
