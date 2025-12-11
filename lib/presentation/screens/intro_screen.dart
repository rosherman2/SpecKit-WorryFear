import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/models/game_config.dart';
import '../../domain/services/onboarding_service.dart';
import '../animations/floating_animation.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/expandable_section.dart';

/// [StatefulWidget] Intro screen with educational text and start button.
/// Purpose: First screen users see, explains the game concept.
/// Navigation: Default route, navigates to gameplay on Start button tap.
///
/// Now fully config-driven - displays content from GameConfig:
/// - Title from config.intro.title
/// - Educational text from config.intro.educationalText
/// - Two 3D bottles (categoryA and categoryB)
/// - Start button to begin game
/// - Expandable Scientific Background from config
///
/// Example:
/// ```dart
/// IntroScreen(gameConfig: loadedConfig)
/// ```
class IntroScreen extends StatefulWidget {
  /// Creates the intro screen with game configuration.
  const IntroScreen({required this.gameConfig, super.key});

  /// The game configuration containing intro content.
  final GameConfig gameConfig;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    AppLogger.debug(
      'IntroScreen',
      'build',
      () => 'Building intro screen for: ${widget.gameConfig.gameId}',
    );

    final intro = widget.gameConfig.intro;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title from config
                Text(
                  intro.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Educational text from config
                ...intro.educationalText.map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Bottles from config
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingAnimation(
                      duration: const Duration(milliseconds: 2000),
                      offset: 6.0,
                      child: BottleWidget(
                        categoryConfig: widget.gameConfig.categoryA,
                        isGlowing: false,
                      ),
                    ),
                    FloatingAnimation(
                      duration: const Duration(milliseconds: 2300),
                      offset: 6.0,
                      child: BottleWidget(
                        categoryConfig: widget.gameConfig.categoryB,
                        isGlowing: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Start button (FR-004 to FR-006)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to gameplay screen
                    Navigator.pushNamed(context, '/gameplay');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.textLight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 32),

                // Expandable Scientific Background from config
                ExpandableSection(
                  title: intro.scientificTitle,
                  content: Text(
                    intro.scientificContent,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // DEBUG: Reset onboarding button (only visible in debug mode)
                if (kDebugMode)
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final service = OnboardingService(prefs);
                      await service.reset();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Onboarding reset! Restart the game to see hints.',
                            ),
                            backgroundColor: AppColors.gold,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      '🔄 Reset Onboarding (Debug)',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
