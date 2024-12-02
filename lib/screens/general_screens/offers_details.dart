import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/theme/map_theme.dart';

class OffersDetails extends ConsumerStatefulWidget {
  const OffersDetails({super.key, required this.offer});

  final Offer offer;

  @override
  ConsumerState<OffersDetails> createState() {
    return _OffersDetailsState();
  }
}

class _OffersDetailsState extends ConsumerState<OffersDetails> {
  bool isProcessing = false;

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
              if (isProcessing) return;
              isProcessing = true;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? scannedUserId = barcodes.first.rawValue;
                if (scannedUserId != null) {
                  Navigator.of(context).pop();
                  try {
                    int redemptionStatus =
                        await widget.offer.redeemCode(scannedUserId);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          content: Text(
                            redemptionStatus == 1
                                ? 'Coded Redeemed Succesfuly'
                                : 'Unsuccesfull redemption',
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
                  } finally {
                    isProcessing = false;
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
  Widget build(BuildContext context) {
    final userId = ref.read(userIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.offer.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: textBlackB12, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Business Name:',
              textAlign: TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textBlackB12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.offer.businessName ?? 'No business name found',
              textAlign: TextAlign.justify,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 72, 72, 83),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Address:',
              textAlign: TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textBlackB12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.offer.address ?? 'No address found',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 72, 72, 83),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              textAlign: TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textBlackB12,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 78,
              child: SingleChildScrollView(
                child: Text(
                  widget.offer.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 72, 72, 83),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 320,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    style: mapTheme,
                    initialCameraPosition: CameraPosition(
                        zoom: 14,
                        target: LatLng(widget.offer.location!.latitude,
                            widget.offer.location!.longitude)),
                    markers: {
                      Marker(
                          markerId: const MarkerId('1'),
                          position: LatLng(
                            widget.offer.location!.latitude,
                            widget.offer.location!.longitude,
                          ))
                    },
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (userId == widget.offer.businessId)
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
