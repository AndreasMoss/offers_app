import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/models/achievement.dart';
import 'package:offers_app/theme/other_colors.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({
    super.key,
    required this.achievement,
    required this.progressValue,
  });

  final Achievement achievement;
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFECEFF3), // Χρώμα του border
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
                achievement.achievementTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: textBlackB12),
              ),
              const Spacer(),
              Text('+${achievement.achievementPoints.toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: achievement.color))
            ],
          ),
          const SizedBox(height: 4),
          Text(achievement.achievementDescription,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: textGrayB80)),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: textGrayB80, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(30),
                      value: progressValue,
                      backgroundColor: Colors
                          .grey[300], // Χρώμα φόντου για την ανενεργή περιοχή
                      valueColor: AlwaysStoppedAnimation<Color>(
                          achievement.color), // Χρώμα της προόδου
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    progressValue < 1.0 ? '${progressValue * 100}%' : '100%',
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFF616161)),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
