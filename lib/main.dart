import 'package:flutter/material.dart';
import 'package:offers_app/screens/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 20, 33, 61),
            foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 20, 33, 61))
            .copyWith(
          primary: const Color.fromARGB(255, 20, 33, 61),
          onPrimary: Colors.white,
          secondary: const Color.fromARGB(255, 252, 163, 17),
          onSecondary: Colors.white,
          surface: const Color.fromARGB(255, 229, 229, 229),
          onSurface: const Color.fromARGB(255, 18, 1, 7),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
