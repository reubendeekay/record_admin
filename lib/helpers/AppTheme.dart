import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record_admin/helpers/AppColors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColorLight: Colors.black45,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xfff7f8fa),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.grey,
      onPrimary: Colors.black,
      primaryVariant: Colors.black54,
      surface: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    primaryTextTheme: GoogleFonts.montserratTextTheme().copyWith(
      headline1: const TextStyle(color: Colors.red, fontSize: 12),
      headline3: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: Colors.black87,
      ),
      headline5: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      //  bodyText1: TextStyle(color: Colors.white54, height: 1.5, fontSize: 12),
      headline1:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
      subtitle1: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),
      subtitle2:
          const TextStyle(color: Colors.black, height: 1.5, fontSize: 12),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: const Color(0xff131722),
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      color: surface,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.grey,
      onPrimary: Colors.white,
      primaryVariant: Colors.white54,
      surface: surface,
    ),
    cardColor: surface,
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      headline3: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: primary,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      subtitle1: TextStyle(
        color: Colors.white70,
        fontSize: 14.0,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      subtitle2: TextStyle(
        color: Colors.white54,
        height: 1.5,
        fontSize: 12,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
    ),
  );
}
