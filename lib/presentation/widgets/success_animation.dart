import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Success animation with 5 random variations.
/// Purpose: Provides visual delight with variety on correct answers.
///
/// Randomly selects from 5 different animations:
/// 1. High-five (👏 with scale + rotation)
/// 2. Thumbs up (👍 with slide up)
/// 3. Star burst (⭐ with expanding particles)
/// 4. Confetti (🎉 with falling pieces)
/// 5. Checkmark (✓ with draw animation)
///
/// Example:
/// ```dart
/// SuccessAnimation(
///   onComplete: () {
///     // Navigate to next scenario
///   },
/// )
/// ```
class SuccessAnimation extends StatefulWidget {
  /// Creates a success animation.
  const SuccessAnimation({this.onComplete, super.key});

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _animationType;

  @override
  void initState() {
    super.initState();

    // Randomly select animation type (0-4 for 5 different types)
    _animationType = Random().nextInt(5);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _controller.forward().then((_) {
      // Trigger callback when animation completes
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
        return switch (_animationType) {
          0 => _buildHighFive(),
          1 => _buildThumbsUp(),
          2 => _buildStarBurst(),
          3 => _buildConfetti(),
          4 => _buildCheckmark(),
          _ => _buildHighFive(),
        };
      },
    );
  }

  // Animation 1: High-five with scale and rotation
  Widget _buildHighFive() {
    final scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    final rotation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    return Transform.scale(
      scale: scale.value,
      child: Transform.rotate(
        angle: rotation.value,
        child: const Text('👏', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  // Animation 2: Thumbs up sliding up
  Widget _buildThumbsUp() {
    final slideUp = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    return SlideTransition(
      position: slideUp,
      child: FadeTransition(
        opacity: fade,
        child: const Text('👍', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  // Animation 3: Star burst with expanding particles
  Widget _buildStarBurst() {
    final scale = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return Stack(
      alignment: Alignment.center,
      children: [
        // Central star
        Transform.scale(
          scale: scale.value,
          child: const Text('⭐', style: TextStyle(fontSize: 60)),
        ),
        // Expanding ring effect
        if (_controller.value > 0.3)
          Transform.scale(
            scale: (_controller.value - 0.3) * 3,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withOpacity(1 - _controller.value),
                  width: 3,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Animation 4: Confetti falling
  Widget _buildConfetti() {
    final fall = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0.5),
    ).animate(_controller);

    return Stack(
      alignment: Alignment.center,
      children: [
        SlideTransition(
          position: fall,
          child: const Text('🎉', style: TextStyle(fontSize: 80)),
        ),
        // Additional confetti pieces
        Positioned(
          left: 50 + (50 * _controller.value),
          top: 100 - (50 * _controller.value),
          child: Transform.rotate(
            angle: _controller.value * 6.28,
            child: const Text('🎊', style: TextStyle(fontSize: 40)),
          ),
        ),
        Positioned(
          right: 50 + (50 * _controller.value),
          top: 100 - (30 * _controller.value),
          child: Transform.rotate(
            angle: -_controller.value * 6.28,
            child: const Text('✨', style: TextStyle(fontSize: 30)),
          ),
        ),
      ],
    );
  }

  // Animation 5: Checkmark with draw effect
  Widget _buildCheckmark() {
    final scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    return Stack(
      alignment: Alignment.center,
      children: [
        // Green circle background
        Transform.scale(
          scale: scale.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Checkmark icon
        if (_controller.value > 0.3)
          Transform.scale(
            scale: (_controller.value - 0.3) / 0.7,
            child: const Icon(Icons.check, size: 80, color: Colors.white),
          ),
      ],
    );
  }
}
