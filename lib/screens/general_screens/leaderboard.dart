import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/providers/leaderboard_provider.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/leaderboard_tile.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userWithPointsAsyncValue = ref.watch(userRankingProvider);
    final userIdProvided = ref.read(userIdProvider);
    final currentUserRank = ref.watch(userRankProvider);
    final userData = ref.watch(userDataProvider).asData?.value;

    return userWithPointsAsyncValue.when(
      data: (regularUsers) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 88,
            centerTitle: true,
            iconTheme: const IconThemeData(color: textBlackB12),
            title: Text(
              'Leaderboard',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: textBlackB12),
            ),
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 6.0, bottom: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: regularUsers.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            LeaderboardTile(
                              index: index,
                              user: regularUsers[index],
                              userId: userIdProvided!,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                ),
                const SizedBox(height: 22),
                if (userData!['userType'] == 'regular')
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFECEFF3),
                        width: 1,
                      ),
                    ),
                    width: 327,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Total Points',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF687588),
                                  )),
                              const Spacer(),
                              Text(
                                '${userData!['points']}',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFECEFF3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Your rank: $currentUserRank',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        );
      },
      error: (error, stack) => const Scaffold(
        body: Center(
          child: Text('Error in Leaderboard'),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
