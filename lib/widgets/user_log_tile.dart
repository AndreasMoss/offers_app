import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/theme/other_colors.dart';

class UserLogTile extends StatelessWidget {
  const UserLogTile(
      {super.key,
      required this.date,
      required this.offerTitle,
      required this.businessName});

  final String date;
  final String offerTitle;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 118,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFECEFF3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                date,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: textBlackB12),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary),
                width: 86,
                height: 24,
                child: Text(
                  'Redeemed',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xFFECEFF3),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                offerTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: textBlackB12),
              ),
              const SizedBox(height: 5),
              Text(
                'Business: $businessName',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: textBlackB12),
              ),
            ],
          )
        ],
      ),
    );
  }
}
