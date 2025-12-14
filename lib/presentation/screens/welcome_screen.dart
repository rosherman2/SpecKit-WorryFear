import 'package:flutter/material.dart';
import '../widgets/game_card.dart';
import '../../core/utils/app_logger.dart';

/// [StatelessWidget] Welcome screen for game selection.
/// Purpose: Display available games and handle navigation to game intros.
///
/// This is the app's initial screen (per spec). Shows 2 game cards:
/// - Good Moment vs Other Moment (existing game)
/// - Savoring Choice (new game)
///
/// Tapping a card navigates to that game's intro screen.
///
/// Example navigation:
/// ```dart
/// Navigator.pushNamed(context, '/welcome'); // Show this screen
/// ```
class WelcomeScreen extends StatelessWidget {
  /// Creates the welcome screen.
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.info(
      'WelcomeScreen',
      'build',
      () => 'Displaying game selection screen',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindGO'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  'Choose a Game',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Game Card 1: Good Moment vs Other Moment
              GameCard(
                title: 'Good Moment vs Other Moment',
                subtitle: 'Recognize and sort positive experiences',
                iconEmoji: '🎯',
                onTap: () {
                  AppLogger.info(
                    'WelcomeScreen',
                    'onTap',
                    () => 'User selected: Good Moment game',
                  );
                  Navigator.pushNamed(context, '/good-moments/intro');
                },
              ),

              // Game Card 2: Savoring Choice
              GameCard(
                title: 'Savoring Choice',
                subtitle: 'Notice and appreciate good moments',
                iconEmoji: '✨',
                onTap: () {
                  AppLogger.info(
                    'WelcomeScreen',
                    'onTap',
                    () => 'User selected: Savoring Choice game',
                  );
                  Navigator.pushNamed(context, '/savoring/intro');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
