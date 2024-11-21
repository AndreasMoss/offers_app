import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/functions.dart/checkers.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class BusinessProfile extends ConsumerWidget {
  const BusinessProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ref.read(userIdProvider);
    final businessDataProvided = ref.watch(userDataProvider);

    return businessDataProvided.when(
      data: (businessData) {
        return Padding(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'My Business Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: textBlackB12),
                ),
                const SizedBox(height: 40),
                Text(
                  'You are ${businessData!['business_name']}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: textBlackB12),
                ),
                const SizedBox(height: 130),
                FutureBuilder(
                  future: profileImageChecker(businessId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text('Could not fetch location.'),
                      );
                    }
                    if (snapshot.data == true) {
                      return Image.network(businessData['profile_image']);
                    } else {
                      return const Text('No profile picture found');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('ErrorIN_USERPROFILE_LOADING: $error'),
      ),
    );
  }
}
