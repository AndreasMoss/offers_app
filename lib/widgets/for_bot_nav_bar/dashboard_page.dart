import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/usertype_provider.dart';
import 'package:offers_app/screens/business_screens/add_offer.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.read(userTypeProvider).value;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Dashboard Page'),
          const Spacer(),
          if (userType == 'business')
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const AddOfferScreen();
                  }),
                );
              },
              child: const Center(
                child: Text('Create New Offer'),
              ),
            ),
        ],
      ),
    );
  }
}
