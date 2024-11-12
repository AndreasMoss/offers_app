import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/screens/general_screens/offers_details.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class OfferTile extends StatefulWidget {
  const OfferTile({super.key, required this.offer});

  final Offer offer;

  @override
  State<OfferTile> createState() => _OfferTileState();
}

class _OfferTileState extends State<OfferTile> {
  Future<String?> fetchProfileImage(String businessId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(businessId)
          .get();

      // `profile_image`Elegxos an to eggrafo iparxei kai an periexo to pedio profile_image
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        return data.containsKey('profile_image')
            ? data['profile_image'] as String
            : null;
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return OffersDetails(offer: widget.offer);
            },
          ),
        );
      },
      child: Container(
        height: 136,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFECEFF3), // Χρώμα του border
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 108,
              decoration: BoxDecoration(
                  color: textGrayB80, borderRadius: BorderRadius.circular(8)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 9, bottom: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.offer.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: textBlackB12),
                    ),
                    Text(
                      widget.offer.description,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: textGrayB80),
                    ),
                    const Spacer(),
                    Text(
                      "Remaining: ${widget.offer.codes} codes",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: textGrayB80),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
