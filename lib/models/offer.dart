import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  Offer(
      {required this.id,
      required this.title,
      required this.description,
      required this.codes,
      required this.businessId,
      this.profileImage});

  final String id;
  final String title;
  final String description;
  final int codes;
  final String businessId;
  final String? profileImage;

  int redeemedCodes = 0;

  int get availableCodes {
    return codes - redeemedCodes;
  }

  void printOfferId() async {
    print("OFFFFEEEEERRRR ID: ---------------$id------------------");
  }

  Future<void> redeemCode(String userId) async {
    final firestoreDb = FirebaseFirestore.instance;
    try {
      final userRef = firestoreDb.collection('users').doc(userId);
      await firestoreDb.runTransaction((transaction) async {
        print('STAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAART');
        final snapshot = await transaction.get(userRef);

        try {
          print(snapshot.data());
          int currentPoints = snapshot.data()!['points'];
          print('Current POINTS AREEEEEEEEEEEEEEEEEEEEE : $currentPoints');
          transaction.update(userRef, {'points': currentPoints + 20});
          print('Points added successfully to user $userId.');
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
