import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pou parakolouthei tin katastasi tis sindesis tou xristi
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userTypeProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return null;
  }

  final uid = user.uid;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (doc.exists) {
    return doc['userType'] as String;
  } else {
    throw Exception("User document does not exist");
  }
});
