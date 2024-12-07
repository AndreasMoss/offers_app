import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/models/points_titles.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/general_screens/leaderboard.dart';
import 'package:offers_app/screens/regular_user_screens/achievements_screen.dart';
import 'package:offers_app/screens/regular_user_screens/history_screen.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  String _getTitle(int points) {
    if (points < begginerMaxPoints) {
      return '🔰 Beginner';
    } else if (points < apprenticeMaxPoints) {
      return '🌱 Apprentice';
    } else if (points < explorerMaxPoints) {
      return '🌟 Explorer';
    } else if (points < achieverMaxPoints) {
      return '🏆 Achiever';
    } else if (points < masterMaxPoints) {
      return '🏅 Master';
    } else if (points < grandMasterMaxPoints) {
      return '🎖️ Grandmaster';
    } else {
      return '👑 Legendary';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    final userDataProvided = ref.watch(userDataProvider);

    return userDataProvided.when(
      data: (userData) {
        return Padding(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'My Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: textBlackB12),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                      top: 12, left: 24, right: 24, bottom: 12),
                  width: double.infinity,
                  height: 145,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: const Color(0xFFECEFF3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData!['username'],
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userData['email'],
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF687588),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Points:',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF687588),
                            ),
                          ),
                          const Spacer(),
                          Text(userData['points'].toString(),
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Title:',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF687588),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _getTitle(userData['points']),
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 107,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => const LeaderboardScreen()));
                            },
                            child: Container(
                              width: 156,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: const Color(0x0A743A24),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Image.asset(
                                  'assets/trophy.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('View Leaderboard',
                              style: GoogleFonts.workSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF111827),
                              ))
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) =>
                                      const AchievementsScreen()));
                            },
                            child: Container(
                              width: 156,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: const Color(0x0AFF1510),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Image.asset(
                                  'assets/achievements.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Achievements',
                            style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF111827),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 38),
                if (userId != null)
                  QrImageView(
                    data: userId,
                    version: QrVersions.auto,
                    size: 260.0,
                  )
                else
                  const Text('ERROR: NO USER FOUND IN THE SYSTEM'),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have used',
                      style: GoogleFonts.workSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textGrayB80,
                      ),
                    ),
                    Text(
                      ' ${userData['totalCodesUsed']} Codes!',
                      style: GoogleFonts.workSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('ErrorIN_USERPROFILE_LOADING: $error'),
      ),
    );
  }
}
