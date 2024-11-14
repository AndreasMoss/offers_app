import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/widgets/offer_tile.dart';

class OffersList extends ConsumerWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersListStreamDataProvided = ref.watch(offersStreamProvider);

    return offersListStreamDataProvided.when(
      data: (offers) => ListView.builder(
        padding: const EdgeInsets.only(top: 18),
        itemCount: offers.length,
        itemBuilder: (ctx, index) {
          return OfferTile(offer: offers[index]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('ErrorINOFFERSLISTTTTTTTTTTTTTTT_WIDGET: $error')),
    );
  }
}
