import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/user_provider.dart';

class OffersDetails extends ConsumerWidget {
  const OffersDetails({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
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
            const Spacer(),
            if (userId == offer.businessId)
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code),
                onPressed: () {
                  // offer.redeemCode();
                  // Navigator.of(context).pop();
                  // print(offer.availableCodes);
                },
                label: const Text('Scan User QR Code'),
              )
          ],
        ),
      ),
    );
  }
}
