import 'package:flutter/material.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/widgets/offer_tile.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key, required this.offers, this.color});

  final List<Offer> offers;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 18),
      itemCount: offers.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            OfferTile(
              offer: offers[index],
              color: color,
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
