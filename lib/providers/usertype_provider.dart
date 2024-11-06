import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Arxiki fortwsi userType me FutureProvider
final userTypeFutureProvider = FutureProvider<String?>((ref) async {
  // print(
  //     "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    String uid = currentUser.uid;

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc['userType'] as String;
    } else {
      throw Exception("User document does not exist");
    }
  } else {
    throw Exception("User is not logged in");
  }
});

// Provider pou apothikeuei monima ton userType meta tin arxiki fortwsi
final userTypeProvider = Provider<String?>((ref) {
  final userType = ref.watch(userTypeFutureProvider).maybeWhen(
        data: (value) => value,
        orElse: () => null,
      );
  return userType;
});
