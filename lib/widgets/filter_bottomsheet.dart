import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/filtering_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class FilterBottomsheet extends ConsumerWidget {
  const FilterBottomsheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryFilterNotifier = ref.read(categoryFilterProvider.notifier);
    final currentFilter = ref.watch(categoryFilterProvider);
    return Container(
      height: 320,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              'Filter Offers',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: textBlackB12),
            ),
            const SizedBox(
              height: 24,
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
                dropdownColor: Colors.white,
                value: currentFilter,
                items: OfferCategory.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(categoryDict[category]),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    categoryFilterNotifier.setCategory(value);
                  }
                }),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Return to Offers'))
          ],
        ),
      ),
    );
  }
}
