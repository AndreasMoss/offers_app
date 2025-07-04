import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/functions.dart/checkers.dart';
import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/add_offer.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/widgets/offers_list.dart';

class BusinessDashboard extends ConsumerWidget {
  const BusinessDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ref.read(userIdProvider);
    final userDataAsync = ref.watch(userDataProvider);
    final activeOffersAsyncValue =
        ref.watch(activeOffersForBusinessStreamProvider);
    final inactiveOffersAsyncValue =
        ref.watch(inactiveOffersForBusinessStreamProvider);
    return activeOffersAsyncValue.when(
      data: (activeOffers) {
        return inactiveOffersAsyncValue.when(
          data: (inactiveOffers) {
            return userDataAsync.when(
              data: (userData) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 90, left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Offers',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: textBlackB12),
                      ),
                      Expanded(
                        child: OffersList(
                          offers: activeOffers,
                          color: const Color.fromARGB(120, 76, 175, 80),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expired Offers',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: textBlackB12),
                      ),
                      Expanded(
                        child: OffersList(
                          offers: inactiveOffers,
                          color: const Color.fromARGB(120, 244, 67, 54),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final hasProfileImage =
                              await profileImageChecker(businessId);

                          final hasLocation = await locationChecker(businessId);

                          // final hasLocation =
                          //     data.containsKey('location') &&
                          //         data['location'] != null &&
                          //         data['location'].toString().isNotEmpty;

                          if (hasProfileImage && hasLocation) {
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (ctx) {
                                  return const AddOfferScreen();
                                }),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please finish your Business Profile before creating an offer.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black87,
                                  duration: Duration(
                                      seconds: 2), // Προσαρμογή διάρκειας.
                                ),
                              );
                            }

                            return;
                          }

                          return;
                        },
                        child: const Center(
                          child: Text('Create New Offer'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                    'ErrorINDASHBOARD_ACTIVE_LISTTTTTTTTTTTTTTT_LOADING: $error'),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
                'ErrorINDASHBOARD_INACTIVE_LISTTTTTTTTTTTTTTT_LOADING: $error'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child:
            Text('ErrorINDASHBOARD_ACTIVE_LISTTTTTTTTTTTTTTT_LOADING: $error'),
      ),
    );
  }
}
