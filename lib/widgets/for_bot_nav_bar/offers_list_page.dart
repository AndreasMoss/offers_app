import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/filtering_provider.dart';
import 'package:offers_app/providers/map_provider.dart';
import 'package:offers_app/screens/general_screens/map.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/offers_list.dart';

class OffersListPage extends ConsumerWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStartingLocationFuture =
        ref.watch(userStartingLocationProvider.future);

    final filteredOffers = ref.watch(filteredListProvider);

    var selectedCategoryFilter = OfferCategory.all;

    return Padding(
      padding: const EdgeInsets.only(top: 58, left: 24, right: 24),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Row(
                children: [
                  Text(
                    'Available Offers! 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: textBlackB12),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 320,
                            width: double.infinity,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filter Offers',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: textBlackB12),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Select Category',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: textGrayB80),
                                      ),
                                    ],
                                  ),
                                  DropdownButton(
                                      value: selectedCategoryFilter,
                                      items: OfferCategory.values
                                          .map(
                                            (category) => DropdownMenuItem(
                                              value: category,
                                              child:
                                                  Text(categoryDict[category]),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectedCategoryFilter = value;
                                          print(selectedCategoryFilter);
                                        }
                                      }),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () {}, child: Text('Apply'))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFECEFF3), // Χρώμα του border
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color.fromARGB(183, 129, 136, 152),
                        size: 26,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: OffersList(
                offers: filteredOffers,
              ),
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
                child: FutureBuilder(
                  future: userStartingLocationFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        child: const Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())),
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
                    return FloatingActionButton(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
