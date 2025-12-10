import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Animated drag hint icon for first-time users.
/// Purpose: Shows a bouncing finger icon that indicates drag action.
///
/// Bounces continuously until user performs drag action.
/// Used during onboarding to teach users the drag-and-drop mechanic.
///
/// Example:
/// ```dart
/// DragHintIcon()
/// ```
class DragHintIcon extends StatefulWidget {
  /// Creates a drag hint icon.
  const DragHintIcon({this.onComplete, super.key});

  /// Callback when animation completes (optional, not used for continuous bounce).
  final VoidCallback? onComplete;

  @override
  State<DragHintIcon> createState() => _DragHintIconState();
}

class _DragHintIconState extends State<DragHintIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Bounce up and down continuously
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -15.0, // Move up 15 pixels
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Repeat forever
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: child,
        );
      },
      child: const Text(
        '👇',
        style: TextStyle(
          fontSize: 48, // Increased from 32
          color: AppColors.gold,
          shadows: [Shadow(color: AppColors.glowGold, blurRadius: 10)],
        ),
      ),
    );
  }
}
