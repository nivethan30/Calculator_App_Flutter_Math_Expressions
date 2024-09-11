import 'screens/main_screen.dart';
import 'package:flutter/material.dart';

/// The main entry point for the application.
///
/// This function runs the application, which is a [MaterialApp] with a dark
/// theme and the 'Skate-Sonic' font family.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  /// Returns the root widget for the application, which is a [MaterialApp] with
  /// a dark theme and the 'Skate-Sonic' font family.
  ///
  /// The [MaterialApp] is configured to not show the debug banner, and to use
  /// the [MainScreen] as its home widget.
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            textTheme:
                ThemeData.dark().textTheme.apply(fontFamily: 'Skate-Sonic')),
        home: const MainScreen());
  }
}
