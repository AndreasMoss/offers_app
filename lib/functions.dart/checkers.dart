import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> profileImageChecker(businessId) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(businessId)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        final hasProfileImage = data.containsKey('profile_image') &&
            data['profile_image'] != null &&
            data['profile_image'].toString().isNotEmpty;

        if (hasProfileImage) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  } catch (e) {
    print(
        'Error checking profile image and location FOR THE DASHBOARD SCREEN: $e');
    return false; // Επιστρέφει false αν προκύψει σφάλμα.
  }
}

Future<bool> locationChecker(businessId) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(businessId)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        final hasLocation = data.containsKey('location') &&
            data['location'] != null &&
            data['location'] is GeoPoint;

        if (hasLocation) {
          final GeoPoint location = data['location'];

          return location.latitude != 0.0 || location.longitude != 0.0;
        }
      }
    }
    return false;
  } catch (e) {
    print('Error checking location FOR THE DASHBOARD SCREEN: $e');
    return false;
  }
}
