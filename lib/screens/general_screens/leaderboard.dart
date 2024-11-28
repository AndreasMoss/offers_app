import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return userWithPointsAsyncValue.when(
      data: (regularUsers) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 88,
            centerTitle: true,
            iconTheme: IconThemeData(color: textBlackB12),
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
