import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/general_screens/leaderboard.dart';
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
    //perimenw o provider na exei data, kathws einai futureProvider

    //parakolouthw ton provider pou moy dinei ta offers.
    return userDataProvidedAsync.when(
      data: (userData) {
        // final userIdProvided = ref.watch(userIdProvider);

        return Scaffold(
          appBar: currentIndex == 0
              ? AppBar(
                  title: Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const LeaderboardScreen()));
                        },
                        icon: const Icon(Icons.emoji_events))
                  ],
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
        );
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
