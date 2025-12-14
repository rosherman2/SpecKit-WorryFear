import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/session.dart';

/// [StatelessWidget] Completion screen showing session results.
/// Purpose: Display final score, percentage, and review recommendations.
///
/// Shows:
/// - Celebration title
/// - Total score and points
/// - Accuracy percentage
/// - Number of scenarios to review
/// - Finish button to return to intro
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => CompletionScreen(session: mySession),
///   ),
/// );
/// ```
class CompletionScreen extends StatelessWidget {
  /// Creates a completion screen.
  const CompletionScreen({required this.session, super.key});

  /// The completed session with results.
  final Session session;

  @override
  Widget build(BuildContext context) {
    final score = session.score;
    final totalScenarios = session.scenarios.length;
    // Count scenarios that were correct on first attempt (never incorrect)
    final correctCount = session.scenarios
        .where((s) => s.isAnswered && !s.wasEverIncorrect)
        .length;
    final percentage = ((correctCount / totalScenarios) * 100).round();
    final reviewCount = session.incorrectScenarios.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration emoji
                const Text('🎉', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Session Complete!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Score card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Score
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                      const Text(
                        'points',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Percentage
                      Text(
                        '$percentage% Correct',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Review count
                      if (reviewCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$reviewCount scenario${reviewCount == 1 ? '' : 's'} to review',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Review Mistakes button (if there are errors)
                if (reviewCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/review',
                          arguments: session.incorrectScenarios,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Review Mistakes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Finish button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to welcome screen to choose next game
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                      (route) => false,
                    );
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
                    'Finish',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
