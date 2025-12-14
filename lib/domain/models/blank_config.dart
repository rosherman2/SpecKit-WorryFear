import 'package:equatable/equatable.dart';
import 'word_tile.dart';

/// [Model] Configuration for a single blank within a sentence stem.
/// Purpose: Defines the word tiles available for a blank and feedback.
///
/// Each blank has:
/// - An index (1 or 2)
/// - Exactly 3 word tiles to choose from
/// - Feedback message for incorrect selections
///
/// Example:
/// ```dart
/// final blank = BlankConfig(
///   index: 1,
///   tiles: [
///     WordTile(text: 'enjoy this moment', isCorrect: true),
///     WordTile(text: 'keep moving', isCorrect: false),
///     WordTile(text: 'focus on what's wrong', isCorrect: false),
///   ],
///   incorrectFeedback: 'That focuses away from the good. Try again.',
/// );
/// ```
class BlankConfig extends Equatable {
  /// Creates a blank configuration.
  const BlankConfig({
    required this.index,
    required this.tiles,
    required this.incorrectFeedback,
  });

  /// Blank number (1 or 2).
  /// For single-blank sentences, always 1.
  /// For double-blank sentences, 1 or 2.
  final int index;

  /// Available word options for this blank.
  /// Always exactly 3 tiles, with one isCorrect = true.
  final List<WordTile> tiles;

  /// Message displayed when user selects an incorrect tile.
  /// Should be neutral and encouraging retry.
  final String incorrectFeedback;

  /// Creates a BlankConfig from JSON data.
  ///
  /// Expects a map with keys: index, tiles, incorrectFeedback.
  factory BlankConfig.fromJson(Map<String, dynamic> json) {
    return BlankConfig(
      index: json['index'] as int,
      tiles: (json['tiles'] as List<dynamic>)
          .map((tile) => WordTile.fromJson(tile as Map<String, dynamic>))
          .toList(),
      incorrectFeedback: json['incorrectFeedback'] as String,
    );
  }

  /// Converts this BlankConfig to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'tiles': tiles.map((tile) => tile.toJson()).toList(),
      'incorrectFeedback': incorrectFeedback,
    };
  }

  /// Gets the correct tile for this blank.
  /// Returns the first tile where isCorrect = true.
  WordTile get correctTile => tiles.firstWhere((tile) => tile.isCorrect);

  @override
  List<Object?> get props => [index, tiles, incorrectFeedback];

  @override
  String toString() =>
      'BlankConfig(index: $index, tiles: ${tiles.length}, incorrectFeedback: ${incorrectFeedback.substring(0, 20)}...)';
}
