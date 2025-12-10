import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatelessWidget] Custom progress bar for gameplay sessions.
/// Purpose: Shows visual progress through 10 scenarios with gold theme.
///
/// Displays:
/// - Scenario counter (e.g., "Scenario 3 of 10")
/// - Animated progress bar with gold fill
/// - Smooth transitions between states
///
/// Example:
/// ```dart
/// ProgressBar(
///   current: 3,
///   total: 10,
/// )
/// ```
class ProgressBar extends StatelessWidget {
  /// Creates a progress bar widget.
  const ProgressBar({required this.current, required this.total, super.key});

  /// Current scenario number (1-indexed).
  final int current;

  /// Total number of scenarios.
  final int total;

  @override
  Widget build(BuildContext context) {
    // Calculate progress percentage
    final progress = current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scenario counter text
        Text(
          'Scenario $current of $total',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Animated progress bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.lightGray,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
