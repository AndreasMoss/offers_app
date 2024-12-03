import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/business_profile_edit2.dart';
import 'package:offers_app/screens/regular_user_screens/user_profile_edit.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.read(userDataProvider).value;
    final userType = userData!['userType'];

    return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (userType == 'business') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const BusinessProfileEditScreen2();
                        },
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const UserProfileEditScreen();
                        },
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit your Profile'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        ));
  }
}
