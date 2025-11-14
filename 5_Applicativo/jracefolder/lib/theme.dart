import 'package:flutter/material.dart';

final ThemeData raceTheme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFFFFC311),
    unselectedItemColor: Colors.white,
    backgroundColor: Color(0xFF149109),
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color(0xFFB6962E),           // colore principale
    //linearTrackColor: Color(0xFF2C2C2C), // sfondo lineare
    //circularTrackColor: Color(0xFF2C2C2C), // sfondo rotella
  ),
  /*primaryColor: Color(0xFFFFCC00),
  scaffoldBackgroundColor: Color(0xFF0B3D2E),
  fontFamily: "RobotoCondensed",
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFD4AF37),
    primary: Color(0xFFD4AF37),
    secondary: Color(0xFF3E6818),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0B3D2E),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardThemeData(
    color: Color(0xFF298A45),
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFD4AF37),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  ),*/
);
