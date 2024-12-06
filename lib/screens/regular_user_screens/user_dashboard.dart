import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/widgets/user_log_tile.dart';

class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).asData?.value;
    List history = userData!['redeemedOffers'] ?? [];
    return Padding(
      padding:
          const EdgeInsets.only(top: 90.0, bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: textBlackB12),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (ctx, index) {
                  final logInverseIndex = history.length - 1;
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      UserLogTile(
                        businessName: history[logInverseIndex - index]
                            ['businessName'],
                        date: history[logInverseIndex - index]['redeemDate'],
                        offerTitle: history[logInverseIndex - index]['title'],
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
