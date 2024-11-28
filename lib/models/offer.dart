import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class Offer {
  Offer(
      {required this.offerId,
      required this.title,
      required this.description,
      required this.codes,
      required this.businessId,
      required this.category,
      this.profileImage,
      this.location,
      this.address});

  final String offerId;
  final String title;
  final String description;
  final int codes;
  final String businessId;
  final String? profileImage;
  final GeoPoint? location;
  final String? address;
  final OfferCategory category;

  // void printOfferId() async {
  //   print("OFFFFEEEEERRRR ID: ---------------$id------------------");
  // }

  // Using transaction
  Future<void> redeemCode(String userId) async {
    final firestoreDb = FirebaseFirestore.instance;
    try {
      final userRef = firestoreDb.collection('users').doc(userId);
      final offerRef = firestoreDb.collection('offers').doc(offerId);
      final bussRef = firestoreDb.collection('users').doc(businessId);
      await firestoreDb.runTransaction((transaction) async {
        print('STAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAART');
        final snapshot = await transaction.get(userRef);
        final snapshot2 = await transaction.get(offerRef);
        final snapshot3 = await transaction.get(bussRef);

        try {
          //print(snapshot.data());
          int currentPoints = snapshot.data()!['points'];
          int currentCodes = snapshot2.data()!['codes'];
          int currentsCodesUsedByUser = snapshot.data()!['totalCodesUsed'];
          int currentCodesGivenByBuss = snapshot3.data()!['totalCodesGiven'];
          if (currentCodes == 1) {
            transaction.update(offerRef, {'isActive': false});
          }
          //print('Current POINTS AREEEEEEEEEEEEEEEEEEEEE : $currentPoints');
          transaction.update(userRef, {'points': currentPoints + 20});
          transaction.update(offerRef, {'codes': currentCodes - 1});
          transaction
              .update(userRef, {'totalCodesUsed': currentsCodesUsedByUser + 1});
          transaction.update(
              bussRef, {'totalCodesGiven': currentCodesGivenByBuss + 1});
          //print('Points added successfully to user $userId.');
        } catch (error) {
          print('ERROR WHILE TRYING TO READ USER DOCUMENT');
        }
        print('FINIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISH');
      });
    } catch (e) {
      print('ERROR WHILE TRYING TO ADD POINTS TO USER!!!');
    }
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
};
