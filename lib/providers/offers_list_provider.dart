import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/models/offer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/filtering_provider.dart';
import 'package:offers_app/providers/user_provider.dart';

// to .map sta streams leitourgei diaforetika apo tis listes. Edw to .map() eksasfalizei oti tha ginei mia energeia
// otan to stream steilei neo antikeimeno i iparksei kapoia allagi.

// OLES OI ACTIVE PROSFORES
// final activeOffersStreamProvider = StreamProvider<List<Offer>>((ref) {
//   final user = ref.watch(authStateProvider).asData?.value;

//   if (user == null) {
//     return Stream.value([]);
//   }

//   // parakolouthoume ena stream tis basis sto firestore
//   return FirebaseFirestore.instance
//       .collection('offers')
//       .where('isActive', isEqualTo: true)
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Offer(
//           offerId: doc.id,
//           title: data['title'],
//           description: data['description'],
//           codes: data['codes'],
//           businessId: data['business_id'],
//           profileImage: data['business_image_url'],
//           address: data['address'],
//           location: data['location']);
//     }).toList();
//   });
// });

// PROVIDER GIA inactive PROSFORES GIA MIA EPIXEIRISI FILTRARISMA
final inactiveOffersForBusinessStreamProvider =
    StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return Stream.value([]);
  }

  // parakolouthoume ena stream tis basis sto firestore
  return FirebaseFirestore.instance
      .collection('offers')
      .where('isActive', isEqualTo: false)
      .where('business_id', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Offer(
        offerId: doc.id,
        title: data['title'],
        description: data['description'],
        codes: data['codes'],
        address: data['address'],
        location: data['location'],
        businessId: data['business_id'],
        profileImage: data['business_image_url'],
        category: inverseCategoryDict[data['category']],
        businessName: data['businessName'],
      );
    }).toList();
  });
});

// PROVIDER GIA active PROSFORES GIA MIA EPIXEIRISI FILTRARISMA
final activeOffersForBusinessStreamProvider =
    StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return Stream.value([]);
  }

  // parakolouthoume ena stream tis basis sto firestore
  return FirebaseFirestore.instance
      .collection('offers')
      .where('isActive', isEqualTo: true)
      .where('business_id', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Offer(
        offerId: doc.id,
        title: data['title'],
        description: data['description'],
        codes: data['codes'],
        address: data['address'],
        location: data['location'],
        businessId: data['business_id'],
        profileImage: data['business_image_url'],
        category: inverseCategoryDict[data['category']],
        businessName: data['businessName'],
      );
    }).toList();
  });
});

////////////////////////////////////////
final activeOffersStreamProvider = StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  //LatLngBounds bound = ref.watch(boundsProvider);
  if (user == null) {
    return Stream.value([]);
  }

  // parakolouthoume ena stream tis basis sto firestore
  return FirebaseFirestore.instance
      .collection('offers')
      .where('isActive', isEqualTo: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Offer(
        offerId: doc.id,
        title: data['title'],
        description: data['description'],
        codes: data['codes'],
        businessId: data['business_id'],
        profileImage: data['business_image_url'],
        address: data['address'],
        location: data['location'],
        category: inverseCategoryDict[data['category']],
        businessName: data['businessName'],
      );
    }).toList();
  });
});
