import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For setting preferred orientations


import 'package:era_expenses_tracker/screens/login_screen.dart';

// Define a color scheme for the application
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 59, 98, 181), // A deep purple base color
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark, // Specify dark mode
  seedColor: const Color.fromARGB(255, 5, 22, 46), // A darker teal base color
);


void main() {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred device orientations (e.g., only portrait)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      MaterialApp(
        // Dark theme configuration
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: kDarkColorScheme,
          // --- FIX START ---
          cardTheme: CardThemeData().copyWith( // Changed CardTheme to CardThemeData
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          // --- FIX END ---
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer,
            ),
          ),
        ),
        // Light theme configuration
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          // --- FIX START ---
          cardTheme: CardThemeData().copyWith( // Changed CardTheme to CardThemeData
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          // --- FIX END ---
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 16,
                ),
              ),
        ),
        home: const LoginScreen(), // Set LoginScreen as the initial screen
      ),
    );
  });
}