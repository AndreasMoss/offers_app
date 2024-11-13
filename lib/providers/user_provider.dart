import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pou parakolouthei tin katastasi tis sindesis tou xristi
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// o futureprovider parakolouthei ton streamprovider (pou parakolouthei ti sindesi), opote otan allazei ekeinos, o futureprovider epanekteleitai
final userTypeProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authStateProvider).asData?.value;
  // me to asData pairnoyme tin trexousa katastasi tou AsyncData (an einai stin katatasi data:) kai me to value pairnoyme tin timi pou periexei.

  if (user == null) {
    return null;
  }

  final uid = user.uid;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  try {
    if (doc.exists) {
      return doc['userType'] as String;
    }
  } catch (e) {
    print(
        'PROBLEM WITH THE USERTYPEPROVIDERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
    return null;
  }
});

// autos o provider mou dinei to userid
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    return null;
  }

  // Returns userid if exists
  return user.uid;
});

// //AN DEN YPARXEI I EIKONA , NA EPISTREFW NULL.
// final userProfileImageProvider = FutureProvider<String?>((ref) async {
//   final user = ref.watch(authStateProvider).asData?.value;
//   // me to asData pairnoyme tin trexousa katastasi tou AsyncData (an einai stin katatasi data:) kai me to value pairnoyme tin timi pou periexei.

//   if (user == null) {
//     return null;
//   }

//   final uid = user.uid;
//   final doc =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();

//   try {
//     if (doc.exists) {
//       return doc['profile_image'] as String;
//     }
//   } catch (e) {
//     return null;
//   }
// });

final userProfileImageProvider = StreamProvider<String?>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return const Stream.empty();
  }

  final uid = user.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) {
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data.containsKey('profile_image')) {
        return data['profile_image'] as String?;
      }
    }
    return null;
  });
});
