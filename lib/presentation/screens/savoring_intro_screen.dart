import 'package:flutter/material.dart';
import '../../domain/models/savoring_config.dart';
import '../../core/utils/app_logger.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/expandable_section.dart';

/// [StatelessWidget] Intro screen for the Savoring Choice game.
/// Purpose: Explain the game concept, show educational content, and start gameplay.
///
/// Displays:
/// - Game title
/// - Character (placeholder for now)
/// - Educational concept text
/// - Benefit statement
/// - Scientific background (expandable)
/// - Start button
///
/// Example:
/// ```dart
/// final config = await SavoringConfigLoader.load('assets/configs/savoring.json');
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => SavoringIntroScreen(savoringConfig: config),
///   ),
/// );
/// ```
class SavoringIntroScreen extends StatelessWidget {
  /// Creates a savoring intro screen.
  const SavoringIntroScreen({required this.savoringConfig, super.key});

  /// The savoring game configuration containing intro content.
  final SavoringConfig savoringConfig;

  @override
  Widget build(BuildContext context) {
    AppLogger.info(
      'SavoringIntroScreen',
      'build',
      () => 'Displaying savoring intro: ${savoringConfig.intro.title}',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                savoringConfig.intro.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Character placeholder
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('✨', style: TextStyle(fontSize: 64)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Educational concept text (paragraphs)
              ...savoringConfig.intro.conceptText.map(
                (paragraph) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    paragraph,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Benefit statement
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  savoringConfig.intro.benefitText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Start button
              ElevatedButton(
                onPressed: () {
                  AppLogger.info(
                    'SavoringIntroScreen',
                    'onStartPressed',
                    () => 'User started savoring game',
                  );
                  Navigator.pushNamed(context, '/savoring/gameplay');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.textLight,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              // Expandable scientific background
              ExpandableSection(
                title: savoringConfig.intro.scientificTitle,
                content: Text(
                  savoringConfig.intro.scientificContent,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
