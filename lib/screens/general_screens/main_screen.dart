import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:offers_app/providers/usertype_provider.dart';
import 'package:offers_app/screens/business_screens/add_offer.dart';
import 'package:offers_app/screens/business_screens/business_profile_edit.dart';
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
    final userTypeAsyncValue = ref.watch(userTypeProvider);
    //perimenw o provider na exei data, kathws einai futureProvider

    //parakolouthw ton provider pou moy dinei ta offers.
    return userTypeAsyncValue.when(
      data: (userType) {
        final userIdProvided = ref.watch(userIdProvider);

        return Scaffold(
          // TA EXW KANEI COMMENT GIA NA BLEPW KANONIKA OPWS THELW TIN OTHONI, ALLA EXW TIS LEITOURGIKOTHTES STA BUTTON ICONS
          // !!!!!!!!!!!!!!

          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
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
              if (userType == 'business')
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const BusinessProfileEditScreen();
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              if (userType == 'business')
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return const AddOfferScreen();
                      }),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
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
                icon: const Icon(Icons.home),
                label: 'Home',
                activeIcon: Icon(Icons.home,
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
        body: Center(child: Text('ErrorAAAAAAAAAAAAAAAAAAAA: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
