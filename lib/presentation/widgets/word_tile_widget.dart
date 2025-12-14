import 'package:flutter/material.dart';
import '../../domain/models/word_tile.dart';
import '../../core/theme/app_colors.dart';

/// [StatelessWidget] A draggable word tile for savoring game.
/// Purpose: Display a word option that can be dragged to blank zones.
///
/// Features:
/// - Draggable<WordTile> for drag-and-drop interaction
/// - Visual feedback while dragging
/// - Disabled state for used tiles
/// - Chip-like styling with rounded corners
///
/// Example:
/// ```dart
/// WordTileWidget(
///   tile: WordTile(text: 'enjoy', isCorrect: true),
///   isEnabled: true,
/// )
/// ```
class WordTileWidget extends StatelessWidget {
  /// Creates a word tile widget.
  const WordTileWidget({required this.tile, this.isEnabled = true, super.key});

  /// The word tile data.
  final WordTile tile;

  /// Whether the tile can be dragged.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final tileContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isEnabled ? AppColors.cardBackground : AppColors.lightGray,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isEnabled
              ? AppColors.textSecondary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: isEnabled
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
        tile.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isEnabled ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );

    if (!isEnabled) {
      return Opacity(opacity: 0.5, child: tileContent);
    }

    return Draggable<WordTile>(
      data: tile,
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
              tile.text,
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
      child: tileContent,
    );
  }
}
