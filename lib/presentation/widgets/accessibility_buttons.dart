import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';
import '../../domain/models/category_config.dart';

/// [StatelessWidget] Accessibility buttons for alternative input.
/// Purpose: Provides category buttons as alternative to drag-and-drop.
///
/// Now config-driven - uses CategoryConfig for button appearance.
/// Shown when user double-taps on scenario card.
/// Useful for users who have difficulty with drag gestures.
///
/// Example:
/// ```dart
/// AccessibilityButtons(
///   categoryA: gameConfig.categoryA,
///   categoryB: gameConfig.categoryB,
///   onCategorySelected: (categoryRole) {
///     // Handle category selection
///   },
/// )
/// ```
class AccessibilityButtons extends StatelessWidget {
  /// Creates accessibility buttons with category configs.
  const AccessibilityButtons({
    required this.categoryA,
    required this.categoryB,
    required this.onCategorySelected,
    super.key,
  });

  /// Config for the first category button.
  final CategoryConfig categoryA;

  /// Config for the second category button.
  final CategoryConfig categoryB;

  /// Callback when a category button is tapped.
  final void Function(CategoryRole) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          // CategoryA button
          Expanded(
            child: _buildCategoryButton(
              config: categoryA,
              onPressed: () => onCategorySelected(CategoryRole.categoryA),
            ),
          ),
          const SizedBox(width: 8),
          // CategoryB button
          Expanded(
            child: _buildCategoryButton(
              config: categoryB,
              onPressed: () => onCategorySelected(CategoryRole.categoryB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required CategoryConfig config,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.colorStart,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(config.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 2),
          Text(
            config.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(config.subtitle, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
