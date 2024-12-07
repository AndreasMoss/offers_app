import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/achievement.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/widgets/achievement_tile.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).asData!.value;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 88,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textBlackB12),
        title: Text(
          'Your Achievements',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: textBlackB12),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: ListView.builder(
            itemCount: achievementList.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  AchievementTile(
                      achievement: achievementList[index],
                      progressValue:
                          userData![achievementList[index].fieldFromFirestore] /
                              achievementList[index].achievementGoal),
                  const SizedBox(height: 18),
                ],
              );
            }),
      ),
    );
  }
}
