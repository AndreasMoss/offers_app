import 'package:offers_app/dummy_data_for_test/dummy_offers.dart';
import 'package:offers_app/models/offer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final offersStreamProvider = StreamProvider<List<Offer>>((ref) {
  return Stream<List<Offer>>.periodic(const Duration(seconds: 5), (count) {
    print(
        'REFRESHIN THE OFFERS LIST HERE AND PRINTING SOMETHING FOR DEBUGGING');
    return dummyOffers;
  });
});
