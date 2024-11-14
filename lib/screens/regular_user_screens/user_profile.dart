import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Profile',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: textBlackB12),
            ),
            const SizedBox(height: 200),
            if (userId != null)
              QrImageView(
                data: userId,
                version: QrVersions.auto,
                size: 260.0,
              )
            else
              const Text('ERROR: NO USER FOUND IN THE SYSTEM'),
          ],
        ),
      ),
    );
  }
}
