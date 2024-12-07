import 'package:flutter/material.dart';

class Achievement {
  const Achievement(
      {required this.color,
      required this.achievementTitle,
      required this.achievementGoal,
      this.fieldFromFirestore});

  final String achievementTitle;
  final Color color;
  final int achievementGoal;
  final String? fieldFromFirestore;
}

const achievementList = [
  Achievement(
      achievementTitle: '🔰 First Redemption:',
      color: Color.fromARGB(255, 8, 122, 222),
      fieldFromFirestore: 'totalCodesUsed',
      achievementGoal: 1),
  Achievement(
      achievementTitle: '🍿 Entertainment Aficionado',
      color: Colors.purple,
      fieldFromFirestore: 'entertainmentRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '🏋️‍♂️ Fit and Fabulous',
      color: Color.fromARGB(255, 0, 141, 56),
      fieldFromFirestore: 'fitnessRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '☕ Caffeine & Cuisine Connoisseur',
      color: Colors.brown,
      fieldFromFirestore: 'coffeeAndFoodRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '💊 Health Guru',
      color: Colors.red,
      fieldFromFirestore: 'healthRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '🤖 Tech Wizard',
      color: Colors.blueAccent,
      fieldFromFirestore: 'technologyRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '📚 Lifelong Learner',
      color: Colors.orange,
      fieldFromFirestore: 'learningRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '💅 Beauty Expert',
      color: Colors.pinkAccent,
      fieldFromFirestore: 'beautyRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '🐾 Pet Whisperer',
      color: Colors.teal,
      fieldFromFirestore: 'petsRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '⚙️ Service Specialist',
      color: Colors.deepPurpleAccent,
      fieldFromFirestore: 'servicesRedemptions',
      achievementGoal: 5),
  Achievement(
      achievementTitle: '👗 Fashion Forward',
      color: Colors.indigo,
      fieldFromFirestore: 'clothesShoesRedemptions',
      achievementGoal: 5),
];
