// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:era_expenses_tracker/screens/home_screen.dart'; // Import your HomeScreen
import 'package:era_expenses_tracker/main.dart'; // Import main.dart for theme setup

void main() {
  testWidgets('Renders HomeScreen and finds app title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We wrap HomeScreen in a MaterialApp because HomeScreen itself expects
    // to be inside one for things like AppBar and Theme data.
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme, // Use your defined color scheme
        ),
        home: const HomeScreen(),
      ),
    );

    // Verify that our AppBar title 'ERA Expenses Tracker' appears.
    expect(find.text('ERA Expenses Tracker'), findsOneWidget);

    // Verify that the initial "No expenses found" message appears
    // if there are no expenses, or if the default expenses are rendered.
    // This is just a basic check. You might expand on this.
    expect(find.text('No expenses found. Start adding some!'), findsOneWidget);

    // Example of finding an icon (e.g., the add button)
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}