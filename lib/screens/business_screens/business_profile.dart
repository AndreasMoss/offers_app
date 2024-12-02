import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_app/functions.dart/checkers.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/theme/map_theme.dart';

class BusinessProfile extends ConsumerWidget {
  const BusinessProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ref.read(userIdProvider);
    final businessData = ref.watch(userDataProvider).asData?.value;

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'My Business Profile',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: textBlackB12),
          ),
          const SizedBox(height: 24),
          Container(
            padding:
                const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFFECEFF3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: businessData?['profile_image'] != null
                          ? NetworkImage(
                              businessData!['profile_image']) // Εικόνα από URL
                          : const AssetImage('assets/nophoto.jpg')
                              as ImageProvider, // Εικόνα από τοπικά assets
                    ),
                    const SizedBox(width: 8),
                    Text(
                      businessData!['business_name'],
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'email:',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  businessData['email'],
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF687588),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Address:',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  businessData['address'] ?? 'No address added yet.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF687588),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (businessData['location'] != null)
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 320,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    style: mapTheme,
                    initialCameraPosition: CameraPosition(
                        zoom: 14,
                        target: LatLng(businessData['location'].latitude,
                            businessData['location'].longitude)),
                    markers: {
                      Marker(
                        markerId: const MarkerId('1'),
                        position: LatLng(businessData['location'].latitude,
                            businessData['location'].longitude),
                      )
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 65),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have given',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textGrayB80,
                ),
              ),
              Text(
                ' ${businessData['totalCodesGiven']} Codes!',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
