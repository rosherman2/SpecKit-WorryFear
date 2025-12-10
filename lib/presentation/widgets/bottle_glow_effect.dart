import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Pulsing glow effect for onboarding hints.
/// Purpose: Draws attention to bottles during first-time user onboarding.
///
/// Shows a gold pulsing glow around the child widget after a delay.
/// Used to hint at drag targets for first-time users.
///
/// Example:
/// ```dart
/// BottleGlowEffect(
///   onStart: () => print('Glow started'),
///   onComplete: () => print('Glow complete'),
///   child: BottleWidget(...),
/// )
/// ```
class BottleGlowEffect extends StatefulWidget {
  /// Creates a bottle glow effect.
  const BottleGlowEffect({
    required this.child,
    this.onStart,
    this.onComplete,
    super.key,
  });

  /// The widget to wrap with glow effect.
  final Widget child;

  /// Callback when glow animation starts (after delay).
  final VoidCallback? onStart;

  /// Callback when glow animation completes.
  final VoidCallback? onComplete;

  @override
  State<BottleGlowEffect> createState() => _BottleGlowEffectState();
}

class _BottleGlowEffectState extends State<BottleGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _started = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Faster blink
      vsync: this,
    );

    // Simple blink animation (0.0 → 1.0 → 0.0)
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start after delay and repeat forever
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!_disposed && mounted) {
        setState(() => _started = true);
        widget.onStart?.call();

        _controller.repeat(reverse: true); // Blink continuously
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      // Before glow starts, just show child
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(
                  _glowAnimation.value * 0.8,
                ), // Increased from 0.6
                blurRadius: 40 * _glowAnimation.value, // Increased from 20
                spreadRadius: 10 * _glowAnimation.value, // Increased from 5
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
