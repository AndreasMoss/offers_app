import 'package:flutter/material.dart';
import 'package:offers_app/models/offer.dart';

class OffersDetails extends StatelessWidget {
  const OffersDetails({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers Details'),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              offer.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              offer.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // offer.redeemCode();
                // Navigator.of(context).pop();
                // print(offer.availableCodes);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              child: const Text('Redeem Code'),
            )
          ],
        ),
      ),
    );
  }
}
