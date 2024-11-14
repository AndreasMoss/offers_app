import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/business_profile.dart';
import 'package:offers_app/screens/regular_user_screens/user_profile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(userTypeProvider).value;

    return userType == 'business'
        ? const BusinessProfile()
        : const UserProfile();
  }
}
