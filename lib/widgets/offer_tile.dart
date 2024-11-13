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
            if (widget.offer.profileImage != null)
              Container(
                width: 115,
                height: 108,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.offer.profileImage!),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 108,
                decoration: BoxDecoration(
                  color: textGrayB80,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            // Container(
            //   width: 80,
            //   height: 108,
            //   decoration: BoxDecoration(
            //       color: textGrayB80, borderRadius: BorderRadius.circular(8)),
            // ),
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
