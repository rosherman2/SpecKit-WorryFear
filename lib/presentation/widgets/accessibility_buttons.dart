import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';

/// [StatelessWidget] Accessibility buttons for alternative input.
/// Purpose: Provides Fear/Worry buttons as alternative to drag-and-drop.
///
/// Shown when user double-taps on scenario card.
/// Useful for users who have difficulty with drag gestures.
///
/// Example:
/// ```dart
/// AccessibilityButtons(
///   onCategorySelected: (category) {
///     // Handle category selection
///   },
/// )
/// ```
class AccessibilityButtons extends StatelessWidget {
  /// Creates accessibility buttons.
  const AccessibilityButtons({required this.onCategorySelected, super.key});

  /// Callback when a category button is tapped.
  final void Function(Category) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fear button
          Expanded(
            child: ElevatedButton(
              onPressed: () => onCategorySelected(Category.fear),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fearPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ), // Reduced
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 28), // Reduced from 32
                  ),
                  SizedBox(height: 2), // Reduced from 4
                  Text(
                    'Fear',
                    style: TextStyle(
                      fontSize: 16, // Reduced from 18
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(Immediate)',
                    style: TextStyle(fontSize: 10), // Reduced from 12
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8), // Reduced from 16
          // Worry button
          Expanded(
            child: ElevatedButton(
              onPressed: () => onCategorySelected(Category.worry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.worryPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ), // Reduced
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '☁️',
                    style: TextStyle(fontSize: 28), // Reduced from 32
                  ),
                  SizedBox(height: 2), // Reduced from 4
                  Text(
                    'Worry',
                    style: TextStyle(
                      fontSize: 16, // Reduced from 18
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(Future)',
                    style: TextStyle(fontSize: 10), // Reduced from 12
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
