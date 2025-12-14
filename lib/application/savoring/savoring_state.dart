import 'package:equatable/equatable.dart';
import '../../domain/models/sentence_stem.dart';
import '../../domain/models/word_tile.dart';

/// [Equatable] Base state for savoring game.
/// Purpose: Represent different stages of the savoring gameplay.
sealed class SavoringState extends Equatable {
  const SavoringState();
}

/// Initial state before game starts.
///
/// This state is emitted when the cubit is first created,
/// before [SavoringCubit.startGame] is called.
/// The UI typically shows a loading indicator during this state.
class SavoringInitial extends SavoringState {
  /// Creates an initial savoring state.
  const SavoringInitial();

  @override
  List<Object?> get props => [];
}

/// State during active gameplay.
class SavoringPlaying extends SavoringState {
  /// Creates a savoring playing state with the current game data.
  const SavoringPlaying({
    required this.currentStem,
    required this.currentRound,
    required this.totalRounds,
    required this.score,
    this.filledTiles = const {},
    this.blankStates = const {},
    this.lockedBlanks = const {},
    this.feedbackMessage,
    this.isCurrentBlankCorrect,
    this.activeBlankIndex = 1,
    this.usedTileIndices = const {},
  });

  /// The current sentence stem being displayed.
  final SentenceStem currentStem;

  /// Current round number (1-indexed).
  final int currentRound;

  /// Total number of rounds in the session.
  final int totalRounds;

  /// Current score.
  final int score;

  /// Map of blank index to filled tile.
  final Map<int, WordTile> filledTiles;

  /// Map of blank index to correct state.
  final Map<int, bool> blankStates;

  /// Map of blank index to locked state.
  final Map<int, bool> lockedBlanks;

  /// Current feedback message to display.
  final String? feedbackMessage;

  /// Whether the most recent drop was correct.
  final bool? isCurrentBlankCorrect;

  /// The currently active blank index (1 or 2).
  final int activeBlankIndex;

  /// Set of tile indices that have been used (for disabling).
  final Set<int> usedTileIndices;

  /// Whether all blanks in the current stem are correctly filled.
  bool get isRoundComplete {
    if (currentStem.blankCount == 1) {
      return blankStates[1] == true;
    } else {
      return blankStates[1] == true && blankStates[2] == true;
    }
  }

  /// Create a copy with updated fields.
  SavoringPlaying copyWith({
    SentenceStem? currentStem,
    int? currentRound,
    int? totalRounds,
    int? score,
    Map<int, WordTile>? filledTiles,
    Map<int, bool>? blankStates,
    Map<int, bool>? lockedBlanks,
    String? feedbackMessage,
    bool? isCurrentBlankCorrect,
    int? activeBlankIndex,
    Set<int>? usedTileIndices,
  }) {
    return SavoringPlaying(
      currentStem: currentStem ?? this.currentStem,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      score: score ?? this.score,
      filledTiles: filledTiles ?? this.filledTiles,
      blankStates: blankStates ?? this.blankStates,
      lockedBlanks: lockedBlanks ?? this.lockedBlanks,
      feedbackMessage: feedbackMessage,
      isCurrentBlankCorrect: isCurrentBlankCorrect,
      activeBlankIndex: activeBlankIndex ?? this.activeBlankIndex,
      usedTileIndices: usedTileIndices ?? this.usedTileIndices,
    );
  }

  @override
  List<Object?> get props => [
    currentStem,
    currentRound,
    totalRounds,
    score,
    filledTiles,
    blankStates,
    lockedBlanks,
    feedbackMessage,
    isCurrentBlankCorrect,
    activeBlankIndex,
    usedTileIndices,
  ];
}

/// State when game session is completed.
class SavoringCompleted extends SavoringState {
  /// Creates a savoring completed state with final scores.
  const SavoringCompleted({
    required this.totalScore,
    required this.totalRounds,
  });

  /// Final score.
  final int totalScore;

  /// Total rounds played.
  final int totalRounds;

  @override
  List<Object?> get props => [totalScore, totalRounds];
}
