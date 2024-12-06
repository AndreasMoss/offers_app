import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/models/points_titles.dart';
import 'package:offers_app/screens/general_screens/offers_details.dart';
import 'package:offers_app/theme/other_colors.dart';

class PremiumOfferTile extends StatelessWidget {
  const PremiumOfferTile({
    super.key,
    required this.offer,
    required this.isLocked,
    this.color,
  });

  final Color? color;
  final bool isLocked;

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return OffersDetails(offer: offer);
            },
          ),
        );
      },
      child: Container(
        height: 136,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? const Color.fromARGB(0, 255, 255, 255),
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
              width: 115,
              height: 108,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(offer.profileImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 9, bottom: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isLocked)
                          Text(
                            '🔒 Offer ${offer.requiredPoints == achieverMaxPoints ? '60%' : offer.requiredPoints == masterMaxPoints ? '70%' : '80%'}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: textGrayB80),
                          )
                        else
                          Text(
                            '🎁 Offer ${offer.requiredPoints == achieverMaxPoints ? '60%' : offer.requiredPoints == masterMaxPoints ? '70%' : '80%'}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: textGrayB80),
                          ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: premiumColor),
                          width: 69,
                          height: 20,
                          child: Text(
                            'Premium',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.workSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      offer.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: textBlackB12),
                    ),
                    if (!isLocked)
                      Text(
                        offer.description,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: textGrayB80),
                      ),
                    const Spacer(),
                    if (isLocked)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Points required: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: textGrayB80),
                              ),
                              Text(
                                '${offer.requiredPoints}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: textGrayB80,
                                        fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          Text(
                            'Earn more Points to Unlock',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      )
                    else
                      Text(
                        "Remaining: ${offer.codes} codes",
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
