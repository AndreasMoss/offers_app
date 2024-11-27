import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/providers/filtering_provider.dart';
import 'package:offers_app/providers/map_provider.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/screens/general_screens/map.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/offers_list.dart';

class OffersListPage extends ConsumerWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersListStreamDataProvided = ref.watch(activeOffersStreamProvider);
    final userStartingLocationFuture =
        ref.watch(userStartingLocationProvider.future);

    final boundsToFilter = ref.watch(boundsProvider);

    return offersListStreamDataProvided.when(
      data: (offersL) {
        final filteredOffers = offersL.where((offer) {
          final location = offer.location;
          return boundsToFilter.contains(
            LatLng(location!.latitude, location.longitude),
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Offers!👋',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: textBlackB12),
                ),
                Expanded(
                  child: OffersList(
                    offers: filteredOffers,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 576,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Text(
                        'View Map',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: FutureBuilder(
                      future: userStartingLocationFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return FloatingActionButton(
                            shape: const CircleBorder(),
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            child: const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator())),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('Could not fetch location.'),
                          );
                        }
                        return FloatingActionButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const MapScreen(),
                              ),
                            );
                          },
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('ErrorINOFFERSLISTTTTTTTTTTTTTTT_WIDGET: $error'),
      ),
    );
  }
}
