import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  Offer(
      {required this.offerId,
      required this.title,
      required this.description,
      required this.codes,
      required this.businessId,
      this.profileImage});

  final String offerId;
  final String title;
  final String description;
  final int codes;
  final String businessId;
  final String? profileImage;

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
