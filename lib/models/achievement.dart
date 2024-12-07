import 'package:flutter/material.dart';

class Achievement {
  const Achievement(
      {required this.color,
      required this.achievementTitle,
      required this.fieldFromFirestore});

  final String achievementTitle;
  final Color color;
  final String? fieldFromFirestore;
}

const achievementList = [
  Achievement(
      achievementTitle: '🥇 Total Progress:',
      color: Color(0xFFFFB900),
      fieldFromFirestore: 'totalCodesUsed'),
  Achievement(
      achievementTitle: '🍿 Entertainment Aficionado',
      color: Colors.purple,
      fieldFromFirestore: 'entertainmentRedemptions'),
  Achievement(
      achievementTitle: '🏋️‍♂️ Fit and Fabulous',
      color: Colors.green,
      fieldFromFirestore: 'fitnessRedemptions'),
  Achievement(
      achievementTitle: '☕ Caffeine & Cuisine Connoisseur',
      color: Colors.brown,
      fieldFromFirestore: 'coffeeAndFoodRedemptions'),
  Achievement(
      achievementTitle: '💊 Health Guru',
      color: Colors.red,
      fieldFromFirestore: 'healthRedemptions'),
  Achievement(
      achievementTitle: '🤖 Tech Wizard',
      color: Colors.blueAccent,
      fieldFromFirestore: 'technologyRedemptions'),
  Achievement(
      achievementTitle: '📚 Lifelong Learner',
      color: Colors.orange,
      fieldFromFirestore: 'learningRedemptions'),
  Achievement(
      achievementTitle: '💅 Beauty Expert',
      color: Colors.pinkAccent,
      fieldFromFirestore: 'beautyRedemptions'),
  Achievement(
      achievementTitle: '🐾 Pet Whisperer',
      color: Colors.teal,
      fieldFromFirestore: 'petsRedemptions'),
  Achievement(
      achievementTitle: '⚙️ Service Specialist',
      color: Colors.deepPurpleAccent,
      fieldFromFirestore: 'servicesRedemptions'),
  Achievement(
      achievementTitle: '👗 Fashion Forward',
      color: Colors.indigo,
      fieldFromFirestore: 'clothesShoesRedemptions'),
];
