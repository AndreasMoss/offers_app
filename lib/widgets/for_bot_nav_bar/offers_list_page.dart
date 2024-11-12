import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/screens/general_screens/map.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/offer_tile.dart';

class OffersListPage extends ConsumerWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersListStreamDataProvided = ref.watch(offersStreamProvider);

    return offersListStreamDataProvided.when(
      data: (offers) => Padding(
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
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 18),
                  itemCount: offers.length,
                  itemBuilder: (ctx, index) {
                    return OfferTile(offer: offers[index]);
                  },
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: ElevatedButton.icon(
              //     icon: const Icon(Icons.map),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //             builder: (ctx) => const MapScreen()),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context)
              //           .colorScheme
              //           .secondary
              //           .withOpacity(0.9),
              //     ),
              //     label: const Text('View on Map'),
              //   ),
              // ),
              // Text('You are user: \n$userIdProvided'),
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
                  child: FloatingActionButton(
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
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('ErrorBBBBBBBBBBBBBBBBBBBB: $error')),
    );
  }
}
