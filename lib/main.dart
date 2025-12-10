import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/gameplay_screen.dart';
import 'presentation/screens/intro_screen.dart';

/// Entry point for the Worry vs Fear cognitive training game.
/// Initializes the app and routes.
void main() {
  // TODO: Initialize AppLogger in future iteration
  // AppLogger.initialize(format: LogFormat.console);

  runApp(const WorryFearApp());
}

/// [StatelessWidget] Root application widget.
/// Purpose: Configures MaterialApp with theme, routes, and navigation.
///
/// Sets up the application with:
/// - Custom theme (AppTheme)
/// - Named routes for navigation
/// - Initial route to IntroScreen
class WorryFearApp extends StatelessWidget {
  /// Creates the root application widget.
  const WorryFearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worry vs Fear Game',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/gameplay': (context) => const GameplayScreen(),
      },
    );
  }
}
