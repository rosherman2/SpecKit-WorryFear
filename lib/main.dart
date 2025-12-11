import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'domain/models/game_config.dart';
import 'domain/models/session_scenario.dart';
import 'domain/services/game_config_loader.dart';
import 'presentation/screens/gameplay_screen.dart';
import 'presentation/screens/intro_screen.dart';
import 'presentation/screens/review_screen.dart';

/// Entry point for the config-driven cognitive training game.
/// Initializes the app, logger, loads game config, and starts the UI.
void main() async {
  // Ensure Flutter binding is initialized for async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize structured logging per constitution Principle I
  await AppLogger.initialize(
    format: LogFormat.console,
    minLevel: LogLevel.debug,
  );
  AppLogger.info('main', 'main', () => 'Application starting');

  // Load game configuration synchronously at startup
  AppLogger.info(
    'main',
    'main',
    () => 'Loading game config: ${GameConfigLoader.activeConfig}',
  );
  final gameConfig = await GameConfigLoader.load(GameConfigLoader.activeConfig);
  AppLogger.info(
    'main',
    'main',
    () => 'Config loaded: ${gameConfig.gameId} v${gameConfig.version}',
  );

  runApp(WorryFearApp(gameConfig: gameConfig));
}

/// [StatelessWidget] Root application widget.
/// Purpose: Configures MaterialApp with theme, routes, and navigation.
///
/// Sets up the application with:
/// - Custom theme (AppTheme)
/// - Named routes for navigation
/// - Initial route to IntroScreen
/// - Game configuration passed to all screens
class WorryFearApp extends StatelessWidget {
  /// Creates the root application widget.
  const WorryFearApp({required this.gameConfig, super.key});

  /// The loaded game configuration.
  final GameConfig gameConfig;

  @override
  Widget build(BuildContext context) {
    AppLogger.debug(
      'WorryFearApp',
      'build',
      () => 'Building app with config: ${gameConfig.gameId}',
    );

    return MaterialApp(
      title: gameConfig.intro.title,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(gameConfig: gameConfig),
        '/gameplay': (context) => GameplayScreen(gameConfig: gameConfig),
      },
      onGenerateRoute: (settings) {
        // Handle /review route with arguments
        if (settings.name == '/review') {
          final reviewScenarios = settings.arguments as List<SessionScenario>;
          return MaterialPageRoute(
            builder: (context) => ReviewScreen(
              reviewScenarios: reviewScenarios,
              gameConfig: gameConfig,
            ),
          );
        }
        return null;
      },
    );
  }
}
