import 'package:flutter/material.dart';
import '../../application/savoring/savoring_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';

/// [StatelessWidget] Completion screen for savoring game.
/// Purpose: Display final score, celebration, and navigation back to welcome.
///
/// Features:
/// - Shows final score prominently
/// - Displays celebration message
/// - Character celebration animation placeholder
/// - Finish button to return to welcome screen
///
/// Example:
/// ```dart
/// Navigator.pushReplacementNamed(
///   context,
///   '/savoring/completion',
///   arguments: SavoringCompleted(totalScore: 80, totalRounds: 10),
/// );
/// ```
class SavoringCompletionScreen extends StatelessWidget {
  /// Creates a savoring completion screen.
  const SavoringCompletionScreen({required this.state, super.key});

  /// The completed game state containing final score and rounds.
  final SavoringCompleted state;

  @override
  Widget build(BuildContext context) {
    AppLogger.info(
      'SavoringCompletionScreen',
      'build',
      () =>
          'Displaying completion: ${state.totalScore} pts in ${state.totalRounds} rounds',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Character celebration
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('✨', style: TextStyle(fontSize: 64)),
                  ),
                ),
                const SizedBox(height: 32),

                // Celebration title
                const Text(
                  'Great Work!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Completion message
                Text(
                  'You completed ${state.totalRounds} rounds!',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Score display
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.gold.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Final Score',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${state.totalScore}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                      const Text(
                        'points',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Finish button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      AppLogger.info(
                        'SavoringCompletionScreen',
                        'onFinishPressed',
                        () =>
                            'User finished savoring game, returning to welcome',
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/welcome',
                        (route) => false,
                      );
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
                      'Finish',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
