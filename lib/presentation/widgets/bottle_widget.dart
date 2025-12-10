import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';

/// [StatelessWidget] 3D-style bottle widget for Fear or Worry category.
/// Purpose: Visual drop zone with glass effect, floating animation, and glow state.
///
/// The bottle uses layered gradients and shadows to create a 3D glass effect.
/// Displays category icon, label, and optional glow when card is hovering.
///
/// Example:
/// ```dart
/// BottleWidget(
///   category: Category.fear,
///   isGlowing: true, // Card is hovering
/// )
/// ```
class BottleWidget extends StatelessWidget {
  /// Creates a bottle widget for the given category.
  const BottleWidget({
    required this.category,
    required this.isGlowing,
    super.key,
  });

  /// The category this bottle represents (fear or worry).
  final Category category;

  /// Whether the bottle should glow (card is hovering over it).
  final bool isGlowing;

  @override
  Widget build(BuildContext context) {
    final isFear = category == Category.fear;
    final gradient = isFear ? AppColors.fearGradient : AppColors.worryGradient;
    final icon = isFear ? '🔥' : '☁️';
    final label = isFear ? 'Fear' : 'Worry';
    final subtitle = isFear ? '(Immediate)' : '(Future)';

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
              const BoxShadow(
                color: AppColors.glowGold,
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
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            Text(
              subtitle,
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
