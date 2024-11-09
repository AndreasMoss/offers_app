import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/screens/general_screens/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:offers_app/screens/general_screens/offers_main.dart';
import 'package:offers_app/screens/general_screens/splash.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        textTheme: GoogleFonts.workSansTextTheme(),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color.fromRGBO(255, 255, 255, 1)),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 76, 175, 80),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 76, 175, 80),
          onSecondary: Colors.white,
          surface: Color.fromARGB(26, 76, 175, 80),
          onSurface: Color.fromARGB(255, 76, 175, 80),
          error: Colors.red,
          onError: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 129, 136, 152),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 129, 136, 152),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 129, 136, 152),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const OffersMainScreen();
            } else {
              return const AuthScreen();
            }
          }),
    );
  }
}
