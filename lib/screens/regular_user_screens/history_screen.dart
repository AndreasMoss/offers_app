import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/other_colors.dart';
import 'package:offers_app/widgets/user_log_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).asData?.value;
    List history = userData!['redeemedOffers'] ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 88,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textBlackB12),
        title: Text(
          'Your History',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: textBlackB12),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  UserLogTile(
                    businessName: history[index]['businessName'],
                    date: history[index]['redeemDate'],
                    offerTitle: history[index]['title'],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
