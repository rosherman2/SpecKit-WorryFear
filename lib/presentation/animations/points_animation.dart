import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Animated "+2" points text that flies from start position
/// to screen center, then fades out.
/// Purpose: Visual feedback showing points earned for correct answer (FR-027).
///
/// Features:
/// - Displays "+2" in gold color
/// - If startPosition is provided, flies from that position toward center
/// - Otherwise, starts from center and slides up
/// - Fades out (opacity 1.0 → 0.0)
/// - Sparkle effect with scale animation
/// - 1 second duration
/// - Calls onComplete when finished
///
/// Example:
/// ```dart
/// PointsAnimation(
///   startPosition: Offset(100, 500), // Bottom-left bottle position
///   onComplete: () {
///     print('Points animation finished');
///   },
/// )
/// ```
class PointsAnimation extends StatefulWidget {
  /// Creates a points animation.
  const PointsAnimation({this.startPosition, this.onComplete, super.key});

  /// Starting position for the animation in global coordinates.
  /// If provided, points fly from this position toward screen center.
  /// If null, uses default slide-up animation from center.
  final Offset? startPosition;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  @override
  State<PointsAnimation> createState() => _PointsAnimationState();
}

class _PointsAnimationState extends State<PointsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // For flying animation
  Offset? _startLocal;
  Offset? _targetLocal;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fade out animation (1.0 to 0.0) - starts at 70% of animation
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Scale animation: starts small, grows, then shrinks
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);

    // Start animation and call onComplete when done
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculatePositions();
  }

  void _calculatePositions() {
    if (widget.startPosition != null) {
      // Convert global start position to local
      final screenSize = MediaQuery.of(context).size;
      final center = Offset(screenSize.width / 2, screenSize.height / 2);

      // Start position is in global coordinates
      _startLocal = widget.startPosition;
      _targetLocal = center;
    }
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
        Widget pointsWidget = Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );

        // If flying animation, position absolutely
        if (_startLocal != null && _targetLocal != null) {
          // Interpolate position from start to target
          final progress = CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ).value;

          final currentX =
              _startLocal!.dx + (_targetLocal!.dx - _startLocal!.dx) * progress;
          final currentY =
              _startLocal!.dy + (_targetLocal!.dy - _startLocal!.dy) * progress;

          // Offset by half the widget size (approximately)
          return Positioned(
            left: currentX - 40,
            top: currentY - 25,
            child: pointsWidget,
          );
        }

        // Default: slide up animation
        final slideUp = Tween<double>(
          begin: 0.0,
          end: -50.0,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

        return Transform.translate(
          offset: Offset(0, slideUp.value),
          child: pointsWidget,
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
