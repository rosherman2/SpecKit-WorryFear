import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/word_tile.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] A draggable word tile for savoring game.
/// Purpose: Display a word option that can be dragged to blank zones.
///
/// Features:
/// - Draggable<WordTile> for drag-and-drop interaction
/// - Visual feedback while dragging
/// - Disabled state for used tiles
/// - Chip-like styling with rounded corners
/// - Optional animated pulsing glow for first-time hints
///
/// Example:
/// ```dart
/// WordTileWidget(
///   tile: WordTile(text: 'enjoy', isCorrect: true),
///   isEnabled: true,
///   showGlow: true, // First-time hint
///   onDragStarted: () => hideGlow(),
/// )
/// ```
class WordTileWidget extends StatefulWidget {
  /// Creates a word tile widget.
  const WordTileWidget({
    required this.tile,
    this.isEnabled = true,
    this.showGlow = false,
    this.onDragStarted,
    super.key,
  });

  /// The word tile data.
  final WordTile tile;

  /// Whether the tile can be dragged.
  final bool isEnabled;

  /// Whether to show animated glow effect (first-time hint).
  final bool showGlow;

  /// Callback when drag starts (to hide glow).
  final VoidCallback? onDragStarted;

  @override
  State<WordTileWidget> createState() => _WordTileWidgetState();
}

class _WordTileWidgetState extends State<WordTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _glowStarted = false;
  Timer? _glowDelayTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulsing animation (0.0 → 1.0 → 0.0)
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.showGlow) {
      // Start glow after 0.5s delay (matching BottleGlowEffect's 2.5s adjusted for tiles)
      _glowDelayTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _glowStarted = true;
          });
          _controller.repeat(reverse: true); // Pulse continuously
        }
      });
    }
  }

  @override
  void dispose() {
    _glowDelayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStarted() {
    if (_glowStarted) {
      setState(() {
        _glowStarted = false;
      });
      _controller.stop();
    }
    widget.onDragStarted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tileContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? AppColors.cardBackground
            : AppColors.lightGray,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isEnabled
              ? AppColors.textSecondary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: widget.isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        widget.tile.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: widget.isEnabled
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
    );

    Widget child = tileContent;

    // Add animated pulsing glow if enabled and started
    if (_glowStarted) {
      child = AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, animChild) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(_glowAnimation.value * 0.8),
                  blurRadius: 40 * _glowAnimation.value,
                  spreadRadius: 10 * _glowAnimation.value,
                ),
              ],
            ),
            child: animChild,
          );
        },
        child: tileContent,
      );
    }

    if (!widget.isEnabled) {
      return Opacity(opacity: 0.5, child: child);
    }

    return Draggable<WordTile>(
      data: widget.tile,
      onDragStarted: _handleDragStarted,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.tile.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: tileContent),
      child: child,
    );
  }
}
