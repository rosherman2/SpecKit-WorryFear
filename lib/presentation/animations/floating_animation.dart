import 'package:flutter/material.dart';

/// [StatefulWidget] Continuous floating animation widget.
/// Purpose: Creates a smooth up-and-down motion for visual appeal.
///
/// Uses AnimationController with repeat mode to create an infinite loop.
/// Applies a subtle vertical translation using Transform.translate.
///
/// Example:
/// ```dart
/// FloatingAnimation(
///   child: MyWidget(),
///   duration: Duration(seconds: 2),
///   offset: 10.0, // Pixels to move up/down
/// )
/// ```
class FloatingAnimation extends StatefulWidget {
  /// Creates a floating animation wrapper.
  const FloatingAnimation({
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.offset = 8.0,
    this.curve = Curves.easeInOut,
    super.key,
  });

  /// The widget to animate.
  final Widget child;

  /// Duration of one complete up-down cycle.
  final Duration duration;

  /// Maximum vertical offset in pixels.
  final double offset;

  /// Animation curve for smooth motion.
  final Curve curve;

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create repeating animation controller
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    // Create tween animation for vertical offset
    _animation = Tween<double>(
      begin: -widget.offset,
      end: widget.offset,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
