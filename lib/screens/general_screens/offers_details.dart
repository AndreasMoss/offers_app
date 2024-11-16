import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/user_provider.dart';

class OffersDetails extends ConsumerWidget {
  const OffersDetails({super.key, required this.offer});

  final Offer offer;

// DEN EXW PAREI PERIPTWSI POU NA EINAI TO TELEUTAIO KOUPONI
// KAI PERIPTWSI POU TELEIWSE I PROSFORA ARA PREPEI NA MIN FAINETAI STIN ARXIKI.
  void scanQRCode(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: MobileScanner(
            key: UniqueKey(), // Βοηθά στην ανανέωση του widget
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? scannedUserId = barcodes.first.rawValue;
                if (scannedUserId != null) {
                  Navigator.of(context).pop();
                  try {
                    await offer.redeemCode(scannedUserId);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          content: Text(
                            'Coded Redeemed Succesfuly for the User $scannedUserId',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  } catch (e) {
                    print('ERROR WHILE READING THE QR CODE OF THE USER');
                  }
                }
              }
            },
          ),
        );
      },
    );
  }

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
                  scanQRCode(context);
                },
                label: const Text('Scan User QR Code'),
              )
          ],
        ),
      ),
    );
  }
}
