import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category_config.dart';

/// [StatelessWidget] 3D-style bottle widget for any category.
/// Purpose: Visual drop zone with glass effect, floating animation, and glow state.
///
/// The bottle uses layered gradients and shadows to create a 3D glass effect.
/// Displays category icon, label, subtitle, and optional glow when card is hovering.
/// Now fully config-driven - supports any category from GameConfig.
///
/// Example:
/// ```dart
/// BottleWidget(
///   categoryConfig: gameConfig.categoryA,
///   isGlowing: true, // Card is hovering
/// )
/// ```
class BottleWidget extends StatelessWidget {
  /// Creates a bottle widget for the given category config.
  const BottleWidget({
    required this.categoryConfig,
    required this.isGlowing,
    super.key,
  });

  /// The category configuration this bottle represents.
  final CategoryConfig categoryConfig;

  /// Whether the bottle should glow (card is hovering over it).
  final bool isGlowing;

  @override
  Widget build(BuildContext context) {
    // Get gradient from category config
    final gradient = categoryConfig.createGradient();

    // RepaintBoundary isolates repaints from parent widgets for better performance
    return RepaintBoundary(
      child: Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isGlowing)
              BoxShadow(
                color: categoryConfig.colorStart.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(categoryConfig.icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              categoryConfig.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            Text(
              categoryConfig.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
