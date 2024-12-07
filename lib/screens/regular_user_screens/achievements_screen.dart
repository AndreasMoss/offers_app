import 'package:flutter/material.dart';
import 'package:offers_app/models/achievement.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/widgets/achievement_tile.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int completedEntertainmentOffers = 5;
    final int completedFitnessOffers = 2;
    final int completedCoffeeAndFoodOffers = 4;
    final int completedHealthOffers = 5;
    final int completedTechnologyOffers = 1;
    final int completedLearningOffers = 5;
    final int completedBeautyOffers = 0;
    final int completedPetsOffers = 3;
    final int completedServicesOffers = 5;
    final int completedClothesShoesOffers = 3;

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
                      achievement: achievementList[index], progressValue: 0.3),
                  const SizedBox(height: 18),
                ],
              );
            }),
      ),
    );
  }
}
