import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'core/utils/app_bloc_observer.dart';
import 'domain/models/game_config.dart';
import 'domain/models/savoring_config.dart';
import 'domain/models/session_scenario.dart';
import 'domain/services/game_config_loader.dart';
import 'domain/services/savoring_config_loader.dart';
import 'presentation/screens/gameplay_screen.dart';
import 'presentation/screens/intro_screen.dart';
import 'presentation/screens/review_screen.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/savoring_intro_screen.dart';
import 'presentation/screens/savoring_gameplay_screen.dart';

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

  // Register BLoC observer for debugging in debug mode
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
    AppLogger.debug('main', 'main', () => 'AppBlocObserver registered');
  }

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

  // Load savoring game configuration
  AppLogger.info('main', 'main', () => 'Loading savoring config');
  final savoringConfig = await SavoringConfigLoader.load(
    'assets/configs/savoring.json',
  );
  AppLogger.info(
    'main',
    'main',
    () =>
        'Savoring config loaded: ${savoringConfig.gameId} v${savoringConfig.version}',
  );

  runApp(MindGOApp(gameConfig: gameConfig, savoringConfig: savoringConfig));
}

/// [StatelessWidget] Root application widget for MindGO multi-game app.
/// Purpose: Configures MaterialApp with theme, routes, and navigation.
///
/// Sets up the application with:
/// - Custom theme (AppTheme)
/// - Named routes for navigation
/// - Initial route to WelcomeScreen
/// - Game configuration passed to all screens
class MindGOApp extends StatelessWidget {
  /// Creates the root application widget.
  const MindGOApp({
    required this.gameConfig,
    required this.savoringConfig,
    super.key,
  });

  /// The loaded game configuration for Good Moment game.
  final GameConfig gameConfig;

  /// The loaded savoring game configuration.
  final SavoringConfig savoringConfig;

  @override
  Widget build(BuildContext context) {
    AppLogger.debug(
      'MindGOApp',
      'build',
      () => 'Building app with config: ${gameConfig.gameId}',
    );

    return MaterialApp(
      title: 'MindGO',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/good-moments/intro': (context) => IntroScreen(gameConfig: gameConfig),
        '/savoring/intro': (context) =>
            SavoringIntroScreen(savoringConfig: savoringConfig),
        '/gameplay': (context) => GameplayScreen(gameConfig: gameConfig),
        '/savoring/gameplay': (context) =>
            SavoringGameplayScreen(savoringConfig: savoringConfig),
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
