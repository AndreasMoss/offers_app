import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:offers_app/models/achievement.dart';

enum OfferCategory {
  all,
  entertainment,
  fitness,
  coffeeAndFood,
  health,
  technology,
  learning,
  beauty,
  pets,
  services,
  clothesShoes
}

class Offer {
  Offer(
      {required this.offerId,
      required this.title,
      required this.description,
      required this.codes,
      required this.businessId,
      required this.category,
      required this.profileImage,
      required this.location,
      required this.address,
      required this.businessName,
      required this.requiredPoints});

  final String offerId;
  final String title;
  final String description;
  final int codes;
  final String businessId;
  final String profileImage;
  final GeoPoint location;
  final String address;
  final OfferCategory category;
  final String businessName;
  final int requiredPoints;

  // void printOfferId() async {
  //   print("OFFFFEEEEERRRR ID: ---------------$id------------------");
  // }

  // Using transaction
  Future<int> redeemCode(String userId) async {
    final isPremium = requiredPoints > 0;
    final firestoreDb = FirebaseFirestore.instance;
    int pointsFromAchievements = 0;
    var statusCode = 0;
    try {
      final userRef = firestoreDb.collection('users').doc(userId);
      final offerRef = firestoreDb.collection('offers').doc(offerId);
      final bussRef = firestoreDb.collection('users').doc(businessId);

      await userRef
          .update({'lastRedeemOfferDate': FieldValue.serverTimestamp()});

      await firestoreDb.runTransaction((transaction) async {
        print('STAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAART');

        final snapshot = await transaction.get(userRef);

        if (snapshot.data()!['points'] < requiredPoints) {
          statusCode = -1;
          return -1;
        }

        var lastRedeems = snapshot.data()?['redeemedOffers'] ?? [];

        if ((lastRedeems as List).isNotEmpty) {
          for (var item in lastRedeems) {
            if (item['offerId'] == offerId) {
              statusCode = 0;
              return 0;
            }
          }
        }

        final snapshot2 = await transaction.get(offerRef);
        final snapshot3 = await transaction.get(bussRef);

        try {
          //print(snapshot.data());
          int currentPoints = snapshot.data()!['points'];
          int currentRedemptionCategoryNumber =
              snapshot.data()!['${category.name}Redemptions'];
          int currentCodes = snapshot2.data()!['codes'];
          int currentsCodesUsedByUser = snapshot.data()!['totalCodesUsed'];
          int currentCodesGivenByBuss = snapshot3.data()!['totalCodesGiven'];

          Timestamp redeemTimestamp = snapshot.data()!['lastRedeemOfferDate'];
          if (currentCodes == 1) {
            transaction.update(offerRef, {'isActive': false});
          }

          // ADD IFs FOR ACHIEVEMENT POINTS
          if (currentRedemptionCategoryNumber == 4) {
            pointsFromAchievements =
                pointsFromAchievements + categoryAchievementPoints;
          }
          if (currentsCodesUsedByUser == 0) {
            pointsFromAchievements =
                pointsFromAchievements + firstRedemptionPoints;
          }

          //print('Current POINTS AREEEEEEEEEEEEEEEEEEEEE : $currentPoints');
          transaction.update(userRef, {
            'points': isPremium
                ? currentPoints - 100 + pointsFromAchievements
                : currentPoints + 20 + pointsFromAchievements
          });
          transaction.update(offerRef, {'codes': currentCodes - 1});
          transaction
              .update(userRef, {'totalCodesUsed': currentsCodesUsedByUser + 1});
          transaction.update(
              bussRef, {'totalCodesGiven': currentCodesGivenByBuss + 1});

          transaction.update(userRef, {
            '${category.name}Redemptions': currentRedemptionCategoryNumber + 1
          });

          //print('Points added successfully to user $userId.');
          DateTime redeemDate = redeemTimestamp.toDate();
          String formattedDate = DateFormat('dd/MM/yyyy').format(redeemDate);

          transaction.update(userRef, {
            'redeemedOffers': FieldValue.arrayUnion([
              {
                'offerId': offerId,
                'title': title,
                'businessName': snapshot3.data()!['business_name'],
                'redeemDate': formattedDate,
              }
            ]),
          });
        } catch (error) {
          print('ERROR WHILE TRYING TO READ USER DOCUMENT');
          statusCode = 0;
        }
        print('FINIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISH');
        statusCode = 1;
      });

      return statusCode;
    } catch (e) {
      print('ERROR WHILE TRYING TO ADD POINTS TO USER!!!');
      statusCode = 0;
    }
    return statusCode;
  }
}

Map categoryDict = {
  OfferCategory.all: 'Show all',
  OfferCategory.entertainment: 'Entertainment',
  OfferCategory.fitness: 'Fitness',
  OfferCategory.coffeeAndFood: 'Coffee and Food',
  OfferCategory.health: 'Health',
  OfferCategory.technology: 'Technology',
  OfferCategory.learning: 'Learning',
  OfferCategory.beauty: 'Beauty',
  OfferCategory.pets: 'Pets',
  OfferCategory.services: 'Services',
  OfferCategory.clothesShoes: 'Clothes/Shoes'
};

Map inverseCategoryDict = {
  'all': OfferCategory.all,
  'entertainment': OfferCategory.entertainment,
  'fitness': OfferCategory.fitness,
  'coffeeAndFood': OfferCategory.coffeeAndFood,
  'health': OfferCategory.health,
  'technology': OfferCategory.technology,
  'learning': OfferCategory.learning,
  'beauty': OfferCategory.beauty,
  'pets': OfferCategory.pets,
  'services': OfferCategory.services,
  'clothesShoes': OfferCategory.clothesShoes,
};
