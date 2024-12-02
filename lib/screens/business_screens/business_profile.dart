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
                const SizedBox(height: 60),
                Container(
                  height: 136,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFECEFF3), // Χρώμα του border
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      if (businessData['profile_image'] != null)
                        Container(
                          width: 115,
                          height: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image:
                                  NetworkImage(businessData['profile_image']),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 108,
                          decoration: BoxDecoration(
                            color: textGrayB80,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 9, bottom: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Titlee here',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: textBlackB12),
                              ),
                              Text(
                                'Kati allo edw pera',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: textGrayB80),
                              ),
                              const Spacer(),
                              Text(
                                "Kai edw pera kati allo tha mpei",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: textGrayB80),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
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
