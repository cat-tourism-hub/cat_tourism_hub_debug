import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardTheme: const CardTheme(
        color: Color.fromARGB(255, 247, 247, 247),
        shadowColor: Color.fromARGB(255, 41, 102, 233),
        elevation: 3),
    indicatorColor: Colors.blue[900],
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.normal),
        headlineSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold),
        labelLarge: TextStyle(
            fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(
            fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
        labelSmall: TextStyle(
            fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),
        bodyLarge: TextStyle(
            fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(
            fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.normal)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[900],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 58, 123, 183)),
    useMaterial3: true,
  );
}
