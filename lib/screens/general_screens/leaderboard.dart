import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userWithPointsAsyncValue = ref.watch(userRankingProvider);
    return userWithPointsAsyncValue.when(
      data: (regularUsers) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          body: ListView.builder(
              itemCount: regularUsers.length,
              itemBuilder: (ctx, index) {
                return Text(
                    '${regularUsers[index].userId}  -  ${regularUsers[index].points}');
              }),
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
