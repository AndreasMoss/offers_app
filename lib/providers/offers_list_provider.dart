import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offers_app/models/offer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';

// to .map sta streams leitourgei diaforetika apo tis listes. Edw to .map() eksasfalizei oti tha ginei mia energeia
// otan to stream steilei neo antikeimeno i iparksei kapoia allagi.

final offersStreamProvider = StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return Stream.value([]);
  }

  // parakolouthoume ena stream tis basis sto firestore
  return FirebaseFirestore.instance
      .collection('offers')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Offer(
        id: doc.id,
        title: data['title'],
        description: data['description'],
        codes: data['codes'],
        profileImage: data['business_image_url'],
      );
    }).toList();
  });
});
