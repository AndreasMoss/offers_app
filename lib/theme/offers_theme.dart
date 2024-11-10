import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData offersTheme = ThemeData().copyWith(
  textTheme: GoogleFonts.workSansTextTheme().copyWith(
    //gia ta headers stin arxi tis selidas
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.workSans().fontFamily,
    ),
    //gia ta ligo mikrotera headers
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.workSans().fontFamily,
    ),
    //gia tous titlous twn offers
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.workSans().fontFamily,
    ),
    //gia ta mini description katw apo ton titlo tou offer
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.workSans().fontFamily,
    ),
    //label gia tis eksigiseis dipla se topothesia tilefono klp
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.workSans().fontFamily,
    ),
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 76, 175, 80),
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Προσθήκη borderRadius εδώ
      ),
    ),
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
);
