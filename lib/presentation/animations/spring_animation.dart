import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// [StatefulWidget] Spring animation wrapper for tap interactions.
/// Purpose: Provides bouncy scale animation using SpringSimulation.
///
/// When tapped, the widget scales down then springs back to original size
/// using physics-based spring simulation for natural motion.
///
/// Example:
/// ```dart
/// SpringAnimation(
///   onTap: () {
///     print('Tapped!');
///   },
///   child: MyWidget(),
/// )
/// ```
class SpringAnimation extends StatefulWidget {
  /// Creates a spring animation wrapper.
  const SpringAnimation({required this.child, this.onTap, super.key});

  /// The widget to wrap with spring animation.
  final Widget child;

  /// Optional callback when tapped.
  final VoidCallback? onTap;

  @override
  State<SpringAnimation> createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Spring simulation parameters
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: 500.0,
      damping: 15.0,
    );

    // Create spring animation from 0.9 (pressed) to 1.0 (normal)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Trigger spring animation
    _controller.forward(from: 0.0);

    // Call the onTap callback
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          // Scale from 0.9 to 1.0 for bounce effect
          final scale = 0.9 + (_scaleAnimation.value * 0.1);

          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
