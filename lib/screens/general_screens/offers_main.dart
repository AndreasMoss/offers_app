import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:offers_app/providers/offers_list_provider.dart';
import 'package:offers_app/providers/usertype_provider.dart';
import 'package:offers_app/screens/business_screens/add_offer.dart';
import 'package:offers_app/screens/general_screens/map.dart';
import 'package:offers_app/screens/general_screens/offers_details.dart';

class OffersMainScreen extends ConsumerWidget {
  const OffersMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTypeAsyncValue = ref.watch(userTypeProvider);
    //perimenw o provider na exei data, kathws einai futureProvider

    //parakolouthw ton provider pou moy dinei ta offers.
    return userTypeAsyncValue.when(
      data: (userType) {
        final offersListStreamDataProvided = ref.watch(offersStreamProvider);
        final userIdProvided = ref.watch(userIdProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Offers Screen'),
            actions: [
              //Test for userType
              // IconButton(
              //   onPressed: () {
              //     print('User Type: $userType');
              //     print('User Type: $userTypeLoaded');
              //   },
              //   icon: Icon(
              //     Icons.person,
              //     color: Theme.of(context).colorScheme.onPrimary,
              //   ),
              // ),
              if (userType == 'business')
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return const AddOfferScreen();
                      }),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          body: offersListStreamDataProvided.when(
            data: (offers) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    itemCount: offers.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return OffersDetails(offer: offers[index]);
                                },
                              ),
                            );
                          },
                          title: Text(
                            offers[index].title,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          trailing: Text('${offers[index].codes} Codes left'),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const MapScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.9),
                    ),
                    label: const Text('View on Map'),
                  ),
                ),
                Text('You are user: \n$userIdProvided'),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('ErrorBBBBBBBBBBBBBBBBBBBB: $error')),
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(child: Text('ErrorAAAAAAAAAAAAAAAAAAAA: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
