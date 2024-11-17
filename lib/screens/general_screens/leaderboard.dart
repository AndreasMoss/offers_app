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
                final rank = index + 1;
                return Center(
                  child: ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: index > 2
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary)
                              : null,
                          color: (rank == 1)
                              ? const Color(0xFFFFD700)
                              : (rank == 2)
                                  ? const Color.fromARGB(255, 165, 165, 169)
                                  : (rank == 3)
                                      ? const Color.fromARGB(255, 154, 90, 6)
                                      : Colors.white),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: index > 2
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(regularUsers[index].username),
                        const Spacer(),
                        Text(regularUsers[index].points.toString()),
                      ],
                    ),
                  ),
                );
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
