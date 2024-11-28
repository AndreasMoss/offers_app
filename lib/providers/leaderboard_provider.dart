import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/regular_user.dart';
import 'package:offers_app/providers/user_provider.dart';

// xreiastike na dimiourgisoume index sto firestore giati kanoume where kai orderby.
final userRankingProvider = StreamProvider<List<RegularUser>>(
  (ref) {
    final user = ref.watch(authStateProvider).asData?.value;

    if (user == null) {
      return Stream.value([]);
    }

    // parakolouthoume ena stream tis basis sto firestore
    return FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'regular')
        .orderBy('points', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final data = doc.data();
            return RegularUser(
              userId: doc.id,
              points: data['points'],
              username: data['username'],
            );
          },
        ).toList();
      },
    );
  },
);

final userRankProvider = Provider<int?>((ref) {
  final users = ref.watch(userRankingProvider).asData?.value;
  if (users == null) {
    return null;
  }

  final userId = ref.read(userIdProvider);

  int index = users.indexWhere((user) => user.userId == userId);

  if (index == -1) {
    return null;
  }

  return index + 1;
});
