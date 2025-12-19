import 'package:flutter/material.dart';

// Definisce il tema personalizzato dell'applicazione
final ThemeData raceTheme = ThemeData(
  // Tema per la BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFFFFC311),   // Colore dell'icona e label selezionata
    unselectedItemColor: Colors.white,      // Colore delle icone e label non selezionate
    backgroundColor: Color(0xFF149109),     // Colore di sfondo della barra di navigazione
  ),

  // Tema per gli indicatori di progresso
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color(0xFFB6962E),               // Colore principale dell'indicatore
  ),
);
