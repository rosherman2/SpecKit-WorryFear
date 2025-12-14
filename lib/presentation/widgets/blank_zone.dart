import 'package:flutter/material.dart';
import '../../domain/models/word_tile.dart';
import '../../core/theme/app_colors.dart';

/// [StatelessWidget] A drop zone for word tiles in savoring game.
/// Purpose: Accept dropped tiles and display filled/empty state.
///
/// States:
/// - Empty: Shows underline/dashed placeholder
/// - Filled: Shows the dropped tile text
/// - Correct: Green background after correct answer
/// - Incorrect: Red shake after wrong answer
/// - Locked: Grayed out, cannot receive drops (for blank 2 before blank 1)
///
/// Example:
/// ```dart
/// BlankZone(
///   blankIndex: 1,
///   filledTile: currentTile,
///   isCorrect: true,
///   onTileDropped: (tile) => cubit.dropTile(1, tile),
/// )
/// ```
class BlankZone extends StatelessWidget {
  /// Creates a blank zone.
  const BlankZone({
    required this.blankIndex,
    required this.onTileDropped,
    this.filledTile,
    this.isLocked = false,
    this.isCorrect,
    super.key,
  });

  /// The index of this blank (1 or 2).
  final int blankIndex;

  /// Callback when a tile is dropped.
  final void Function(WordTile tile) onTileDropped;

  /// The tile currently filling this blank, if any.
  final WordTile? filledTile;

  /// Whether this blank is locked (waiting for previous blank).
  final bool isLocked;

  /// Whether the current answer is correct (null = not yet answered).
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    // Determine styling based on state
    Color backgroundColor;
    Color borderColor;

    if (isLocked) {
      backgroundColor = AppColors.lightGray.withOpacity(0.5);
      borderColor = AppColors.textSecondary.withOpacity(0.2);
    } else if (isCorrect == true) {
      backgroundColor = AppColors.success.withOpacity(0.2);
      borderColor = AppColors.success;
    } else if (isCorrect == false) {
      backgroundColor = AppColors.error.withOpacity(0.2);
      borderColor = AppColors.error;
    } else if (filledTile != null) {
      backgroundColor = AppColors.gold.withOpacity(0.2);
      borderColor = AppColors.gold;
    } else {
      backgroundColor = Colors.transparent;
      borderColor = AppColors.textSecondary.withOpacity(0.5);
    }

    return DragTarget<WordTile>(
      onWillAcceptWithDetails: (details) => !isLocked && isCorrect != true,
      onAcceptWithDetails: (details) {
        if (!isLocked && isCorrect != true) {
          onTileDropped(details.data);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minWidth: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isHovering
                ? AppColors.gold.withOpacity(0.3)
                : backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering ? AppColors.gold : borderColor,
              width: isHovering ? 2 : 1,
              style: filledTile == null && !isLocked
                  ? BorderStyle.solid
                  : BorderStyle.solid,
            ),
          ),
          child: filledTile != null
              ? Text(
                  filledTile!.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCorrect == true
                        ? AppColors.success
                        : isCorrect == false
                        ? AppColors.error
                        : AppColors.textPrimary,
                  ),
                )
              : Text(
                  isLocked ? '...' : '______',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                ),
        );
      },
    );
  }
}
