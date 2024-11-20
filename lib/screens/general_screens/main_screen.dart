import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/providers/map_provider.dart';

import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/general_screens/leaderboard.dart';
import 'package:offers_app/theme/colors_for_text.dart';
import 'package:offers_app/widgets/for_bot_nav_bar/dashboard_page.dart';

import 'package:offers_app/widgets/for_bot_nav_bar/offers_list_page.dart';
import 'package:offers_app/widgets/for_bot_nav_bar/profile_page.dart';
import 'package:offers_app/widgets/for_bot_nav_bar/settings_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _OffersMainScreenState();
}

class _OffersMainScreenState extends ConsumerState<MainScreen> {
  final bottomNavPages = const [
    DashboardPage(),
    OffersListPage(),
    SettingsPage(),
    ProfilePage()
  ];
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // STIN OUSIA DEN TON XRISIMOPOIW KAPOU AUTON TON PROVIDER SE AUTO TO SCREEN, ALLA THELW NA TON FORTWSW NA TON EXW STO YPOLOIPO TIS EFARMOGIS.
    final userDataProvidedAsync = ref.watch(userDataProvider);

    return userDataProvidedAsync.when(
      data: (userData) {
        // final userIdProvided = ref.watch(userIdProvider);

        return Stack(children: [
          Scaffold(
            appBar: currentIndex == 0
                ? AppBar(
                    toolbarHeight: 174,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dashboard',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        const LeaderboardScreen()));
                              },
                              icon: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    //borderRadius: BorderRadius.circular(48),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.54))),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [],
                  )
                : null,
            backgroundColor: const Color.fromARGB(255, 246, 245, 245),
            body: bottomNavPages[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.space_dashboard),
                  label: 'Dashboard',
                  activeIcon: Icon(Icons.dashboard,
                      color: Theme.of(context).colorScheme.primary),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.local_offer),
                  label: 'Offers',
                  activeIcon: Icon(Icons.local_offer,
                      color: Theme.of(context).colorScheme.primary),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                  activeIcon: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.primary),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: 'Profile',
                  activeIcon: Icon(Icons.person,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
          if (currentIndex == 0)
            Positioned(
              top: 160,
              left: 24,
              right: 24, // 24 epeidi kai to padding to exw toso

              child: Card(
                elevation: 2,
                shadowColor: const Color.fromARGB(179, 255, 255, 255),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  height: 114,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData!['userType'] == 'business'
                            ? 'Total Codes Redeemed:'
                            : 'Total Codes Used:',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF687588),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            userData['userType'] == 'business'
                                ? userData['totalCodesGiven'].toString()
                                : userData['totalCodesUsed'].toString(),
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.primary),
                            width: 86,
                            height: 24,
                            child: Text(
                              'Redeemed',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        ]);
      },
      error: (error, stack) => Scaffold(
        body:
            Center(child: Text('ErrorAAAAAAAAIIIIIIIIIIAAAAAAAAAAAA: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
