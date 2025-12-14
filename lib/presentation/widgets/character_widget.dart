import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Character state enum for different expressions.
enum CharacterState {
  /// Idle/breathing state during normal gameplay.
  idle,

  /// Affirming state when user answers correctly.
  affirming,

  /// Celebration state on game completion.
  celebration,
}

/// [StatefulWidget] Animated character widget.
/// Purpose: Display character with different expressions based on game state.
///
/// Features:
/// - Idle state with subtle breathing animation
/// - Affirming state for correct answers
/// - Celebration state for completion
/// - Smooth transitions between states using AnimatedSwitcher
/// - RepaintBoundary for 60fps performance
///
/// Example:
/// ```dart
/// CharacterWidget(
///   state: isCorrect ? CharacterState.affirming : CharacterState.idle,
/// )
/// ```
class CharacterWidget extends StatefulWidget {
  /// Creates a character widget.
  const CharacterWidget({required this.state, super.key});

  /// The current character state.
  final CharacterState state;

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // Setup breathing animation (subtle scale pulse)
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: _buildCharacterForState(widget.state),
      ),
    );
  }

  Widget _buildCharacterForState(CharacterState state) {
    // Use different keys for AnimatedSwitcher to detect changes
    final key = ValueKey(state);

    switch (state) {
      case CharacterState.idle:
        return _buildIdleCharacter(key);
      case CharacterState.affirming:
        return _buildAffirmingCharacter(key);
      case CharacterState.celebration:
        return _buildCelebrationCharacter(key);
    }
  }

  Widget _buildIdleCharacter(Key key) {
    return AnimatedBuilder(
      key: key,
      animation: _breathingAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _breathingAnimation.value, child: child);
      },
      child: _buildCharacterContainer(
        emoji: '✨',
        backgroundColor: AppColors.lightGray,
      ),
    );
  }

  Widget _buildAffirmingCharacter(Key key) {
    return _buildCharacterContainer(
      key: key,
      emoji: '🌟',
      backgroundColor: AppColors.success.withOpacity(0.2),
    );
  }

  Widget _buildCelebrationCharacter(Key key) {
    return _buildCharacterContainer(
      key: key,
      emoji: '🎉',
      backgroundColor: AppColors.gold.withOpacity(0.2),
    );
  }

  Widget _buildCharacterContainer({
    Key? key,
    required String emoji,
    required Color backgroundColor,
  }) {
    return Container(
      key: key,
      constraints: const BoxConstraints(
        minWidth: 80,
        minHeight: 80,
        maxWidth: 120,
        maxHeight: 120,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
    );
  }
}
