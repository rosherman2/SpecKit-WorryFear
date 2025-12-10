import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Animated "+2" points text that flies upward and fades.
/// Purpose: Visual feedback showing points earned for correct answer (FR-027).
///
/// Features:
/// - Displays "+2" in gold color
/// - Animates upward (translates Y by -50 pixels)
/// - Fades out (opacity 1.0 → 0.0)
/// - Sparkle effect with scale animation
/// - 1 second duration
/// - Calls onComplete when finished
///
/// Example:
/// ```dart
/// PointsAnimation(
///   onComplete: () {
///     print('Points animation finished');
///   },
/// )
/// ```
class PointsAnimation extends StatefulWidget {
  /// Creates a points animation.
  const PointsAnimation({this.onComplete, super.key});

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  @override
  State<PointsAnimation> createState() => _PointsAnimationState();
}

class _PointsAnimationState extends State<PointsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Slide up animation (0 to -50 pixels)
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: -50.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Fade out animation (1.0 to 0.0)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Sparkle scale animation (1.0 to 1.3 to 1.0)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_controller);

    // Start animation and call onComplete when done
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          '+2',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
            shadows: [Shadow(color: AppColors.glowGold, blurRadius: 8)],
          ),
        ),
      ),
    );
  }
}
