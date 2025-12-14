import 'package:equatable/equatable.dart';

/// [Model] A draggable word option for filling sentence blanks.
/// Purpose: Represents a word tile that users drag into blanks.
///
/// Each tile has text content and a flag indicating if it's the correct
/// savoring choice for that blank.
///
/// Example:
/// ```dart
/// final tile = WordTile(
///   text: 'enjoy this moment',
///   isCorrect: true,
/// );
/// ```
class WordTile extends Equatable {
  /// Creates a word tile.
  const WordTile({required this.text, required this.isCorrect});

  /// The word or phrase displayed on the tile.
  /// Example: "enjoy this moment", "keep moving", "focus on what's wrong"
  final String text;

  /// Whether this tile is the correct savoring choice for its blank.
  /// Exactly one tile per blank should have isCorrect = true.
  final bool isCorrect;

  /// Creates a WordTile from JSON data.
  ///
  /// Expects a map with keys: text, isCorrect.
  factory WordTile.fromJson(Map<String, dynamic> json) {
    return WordTile(
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  /// Converts this WordTile to JSON format.
  Map<String, dynamic> toJson() {
    return {'text': text, 'isCorrect': isCorrect};
  }

  @override
  List<Object?> get props => [text, isCorrect];

  @override
  String toString() => 'WordTile(text: $text, isCorrect: $isCorrect)';
}
