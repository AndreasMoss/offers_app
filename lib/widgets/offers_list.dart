import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/widgets/offer_tile.dart';
import 'package:offers_app/widgets/premium_offer_tile.dart';

class OffersList extends ConsumerWidget {
  const OffersList({super.key, required this.offers, this.color});

  final List<Offer> offers;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).asData?.value;
    final userType = userData!['userType'];
    return ListView.builder(
      padding: const EdgeInsets.only(top: 6),
      itemCount: offers.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            offers[index].requiredPoints == 0
                ? OfferTile(
                    offer: offers[index],
                    color: color,
                  )
                : PremiumOfferTile(
                    offer: offers[index],
                    color: color,
                    isLocked: userType == 'business'
                        ? false
                        : userData['points'] > offers[index].requiredPoints
                            ? false
                            : true,
                  ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
