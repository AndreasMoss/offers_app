import 'package:flutter/material.dart';
import 'package:offers_app/screens/general_screens/map.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/offers_list.dart';

class OffersListPage extends StatelessWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Offers!👋',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: textBlackB12),
            ),
            const Expanded(
              child: OffersList(),
            ),
          ],
        ),
        Positioned(
          top: 576,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary),
                child: Center(
                  child: Text(
                    'View Map',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const MapScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
