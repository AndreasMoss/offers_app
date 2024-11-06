import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//dummydata
import 'package:offers_app/dummy_data_for_test/dummy_offers.dart';
import 'package:offers_app/providers/usertype_provider.dart';
import 'package:offers_app/screens/map.dart';
import 'package:offers_app/screens/offers_details.dart';

class OffersMainScreen extends ConsumerWidget {
  const OffersMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////
    final userTypeAsyncValue = ref.watch(userTypeFutureProvider);

/////////////////////////
    return userTypeAsyncValue.when(
      data: (userType) {
        //final userTypeLoaded = ref.read(userTypeProvider);
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
              IconButton(
                onPressed: FirebaseAuth.instance.signOut,
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  itemCount: dummyOffers.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return OffersDetails(offer: dummyOffers[index]);
                              },
                            ),
                          );
                        },
                        title: Text(
                          dummyOffers[index].title,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        trailing: Text(
                            '${dummyOffers[index].availableCodes} Codes left'),
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
                        MaterialPageRoute(builder: (ctx) => const MapScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.9) // Full width button
                      ),
                  label: const Text('View on Map'),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
