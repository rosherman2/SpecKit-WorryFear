import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/savoring_config.dart';
import '../../domain/models/sentence_stem.dart';
import '../../domain/models/word_tile.dart';
import '../../core/utils/app_logger.dart';
import 'savoring_state.dart';

/// [Cubit] Manages savoring game state and logic.
/// Purpose: Handle game flow, tile drops, scoring, and round progression.
///
/// Flow:
/// 1. startGame() - Initialize with first stem
/// 2. dropTile() - Handle tile drop, validate, update state
/// 3. advanceRound() - Move to next stem (called after auto-advance timer)
/// 4. Complete after 10 rounds
///
/// Example:
/// ```dart
/// context.read<SavoringCubit>().startGame();
/// context.read<SavoringCubit>().dropTile(blankIndex: 1, tile: tile);
/// ```
class SavoringCubit extends Cubit<SavoringState> {
  /// Creates a savoring cubit.
  SavoringCubit({required this.config}) : super(const SavoringInitial());

  /// The savoring game configuration.
  final SavoringConfig config;

  /// Session stems (randomly selected).
  late List<SentenceStem> _sessionStems;

  /// Points per correct answer.
  static const int pointsPerCorrect = 10;

  /// Starts a new game session.
  void startGame() {
    AppLogger.info(
      'SavoringCubit',
      'startGame',
      () => 'Starting savoring game session',
    );

    // Get 10 random stems for this session
    _sessionStems = config.getSessionStems();

    // Initialize locked blanks for first stem
    final firstStem = _sessionStems[0];
    final lockedBlanks = <int, bool>{};
    if (firstStem.blankCount == 2) {
      lockedBlanks[2] = true; // Lock blank 2 until blank 1 is correct
    }

    emit(
      SavoringPlaying(
        currentStem: firstStem,
        currentRound: 1,
        totalRounds: _sessionStems.length,
        score: 0,
        lockedBlanks: lockedBlanks,
      ),
    );

    AppLogger.debug(
      'SavoringCubit',
      'startGame',
      () => 'First stem: ${firstStem.id}',
    );
  }

  /// Handles a tile drop on a blank zone.
  void dropTile({required int blankIndex, required WordTile tile}) {
    final currentState = state;
    if (currentState is! SavoringPlaying) return;

    AppLogger.info(
      'SavoringCubit',
      'dropTile',
      () =>
          'Tile dropped on blank $blankIndex: "${tile.text}" (correct: ${tile.isCorrect})',
    );

    // Update filled tiles
    final newFilledTiles = Map<int, WordTile>.from(currentState.filledTiles);
    newFilledTiles[blankIndex] = tile;

    // Update blank states
    final newBlankStates = Map<int, bool>.from(currentState.blankStates);
    newBlankStates[blankIndex] = tile.isCorrect;

    // Calculate new score
    var newScore = currentState.score;
    if (tile.isCorrect) {
      newScore += pointsPerCorrect;
    }

    // Determine feedback message
    String? feedbackMessage;
    if (tile.isCorrect) {
      // For single blank or if this is the last blank
      if (currentState.currentStem.blankCount == 1 ||
          (blankIndex == 2 && newBlankStates[1] == true)) {
        feedbackMessage = currentState.currentStem.correctFeedback;
      } else if (blankIndex == 1 && currentState.currentStem.blankCount == 2) {
        // First blank correct in double-blank, unlock blank 2
        feedbackMessage = null; // No message yet, continue to blank 2
      }
    } else {
      // Find incorrect feedback from the blank config
      final blank = currentState.currentStem.blanks.firstWhere(
        (b) => b.index == blankIndex,
      );
      feedbackMessage = blank.incorrectFeedback;
    }

    // Update locked blanks (unlock blank 2 if blank 1 is now correct)
    final newLockedBlanks = Map<int, bool>.from(currentState.lockedBlanks);
    if (blankIndex == 1 &&
        tile.isCorrect &&
        currentState.currentStem.blankCount == 2) {
      newLockedBlanks[2] = false;
    }

    // Track used tile
    final tileIndex = currentState.currentStem.blanks
        .firstWhere((b) => b.index == blankIndex)
        .tiles
        .indexOf(tile);
    final newUsedTiles = Set<int>.from(currentState.usedTileIndices);
    if (tile.isCorrect) {
      // Only mark as permanently used if correct
      newUsedTiles.add(tileIndex);
    }

    emit(
      currentState.copyWith(
        filledTiles: newFilledTiles,
        blankStates: newBlankStates,
        lockedBlanks: newLockedBlanks,
        score: newScore,
        feedbackMessage: feedbackMessage,
        isCurrentBlankCorrect: tile.isCorrect,
        activeBlankIndex:
            tile.isCorrect &&
                currentState.currentStem.blankCount == 2 &&
                blankIndex == 1
            ? 2
            : blankIndex,
        usedTileIndices: newUsedTiles,
      ),
    );
  }

  /// Advances to the next round or completes the game.
  void advanceRound() {
    final currentState = state;
    if (currentState is! SavoringPlaying) return;

    final nextRound = currentState.currentRound + 1;

    AppLogger.info(
      'SavoringCubit',
      'advanceRound',
      () => 'Advancing from round ${currentState.currentRound} to $nextRound',
    );

    if (nextRound > _sessionStems.length) {
      // Game complete
      AppLogger.info(
        'SavoringCubit',
        'advanceRound',
        () => 'Game completed! Final score: ${currentState.score}',
      );

      emit(
        SavoringCompleted(
          totalScore: currentState.score,
          totalRounds: currentState.totalRounds,
        ),
      );
      return;
    }

    // Get next stem
    final nextStem = _sessionStems[nextRound - 1];
    final lockedBlanks = <int, bool>{};
    if (nextStem.blankCount == 2) {
      lockedBlanks[2] = true;
    }

    emit(
      SavoringPlaying(
        currentStem: nextStem,
        currentRound: nextRound,
        totalRounds: currentState.totalRounds,
        score: currentState.score,
        lockedBlanks: lockedBlanks,
      ),
    );

    AppLogger.debug(
      'SavoringCubit',
      'advanceRound',
      () => 'Next stem: ${nextStem.id}',
    );
  }

  /// Clears the current tile from a blank (for retry).
  void clearBlank(int blankIndex) {
    final currentState = state;
    if (currentState is! SavoringPlaying) return;

    final newFilledTiles = Map<int, WordTile>.from(currentState.filledTiles);
    newFilledTiles.remove(blankIndex);

    final newBlankStates = Map<int, bool>.from(currentState.blankStates);
    newBlankStates.remove(blankIndex);

    emit(
      currentState.copyWith(
        filledTiles: newFilledTiles,
        blankStates: newBlankStates,
        feedbackMessage: null,
        isCurrentBlankCorrect: null,
      ),
    );
  }
}
