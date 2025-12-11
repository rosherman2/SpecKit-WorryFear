import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'domain/models/session_scenario.dart';
import 'presentation/screens/gameplay_screen.dart';
import 'presentation/screens/intro_screen.dart';
import 'presentation/screens/review_screen.dart';

/// Entry point for the Worry vs Fear cognitive training game.
/// Initializes the app, logger, and routes.
void main() async {
  // Ensure Flutter binding is initialized for async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize structured logging per constitution Principle I
  await AppLogger.initialize(
    format: LogFormat.console,
    minLevel: LogLevel.debug,
  );
  AppLogger.info('main', 'main', () => 'Application starting');

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
      onGenerateRoute: (settings) {
        // Handle /review route with arguments
        if (settings.name == '/review') {
          final reviewScenarios = settings.arguments as List<SessionScenario>;
          return MaterialPageRoute(
            builder: (context) =>
                ReviewScreen(reviewScenarios: reviewScenarios),
          );
        }
        return null;
      },
    );
  }
}
