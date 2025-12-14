import 'package:equatable/equatable.dart';
import 'blank_config.dart';
import '../../core/utils/app_logger.dart';

/// [Model] A sentence with blanks to be filled by dragging word tiles.
/// Purpose: Represents one round of gameplay with 1-2 blanks.
///
/// The templateText uses {1} and {2} markers to indicate blank positions.
/// Each blank has 3 word tile options, with one correct savoring choice.
///
/// Example single-blank:
/// ```dart
/// final stem = SentenceStem(
///   id: 'stem-1',
///   templateText: 'It is okay to {1}',
///   blankCount: 1,
///   blanks: [
///     BlankConfig(
///       index: 1,
///       tiles: [...],
///       incorrectFeedback: 'Try again.',
///     ),
///   ],
///   correctFeedback: 'You let the moment stay.',
/// );
/// ```
class SentenceStem extends Equatable {
  /// Creates a sentence stem.
  const SentenceStem({
    required this.id,
    required this.templateText,
    required this.blankCount,
    required this.blanks,
    required this.correctFeedback,
  });

  /// Unique identifier for this stem.
  /// Example: "stem-1", "stem-5"
  final String id;

  /// Sentence template with blank markers.
  /// Use {1} and {2} to mark blank positions.
  /// Example: "It is okay to {1}", "I can {1} this moment {2}."
  final String templateText;

  /// Number of blanks in this stem (1 or 2).
  /// Single-blank sentences have 1 blank and 3 tile options.
  /// Double-blank sentences have 2 blanks and 2 tile groups.
  final int blankCount;

  /// Configuration for each blank.
  /// Length must equal blankCount.
  final List<BlankConfig> blanks;

  /// Message displayed when all blanks are filled correctly.
  /// Should affirm the savoring choice.
  /// Example: "You let the moment stay.", "You made space for the good."
  final String correctFeedback;

  /// Creates a SentenceStem from JSON data.
  ///
  /// Expects a map with keys: id, templateText, blankCount, blanks, correctFeedback.
  factory SentenceStem.fromJson(Map<String, dynamic> json) {
    AppLogger.debug(
      'SentenceStem',
      'fromJson',
      () => 'Parsing sentence stem: ${json['id']}',
    );

    return SentenceStem(
      id: json['id'] as String,
      templateText: json['templateText'] as String,
      blankCount: json['blankCount'] as int,
      blanks: (json['blanks'] as List<dynamic>)
          .map((blank) => BlankConfig.fromJson(blank as Map<String, dynamic>))
          .toList(),
      correctFeedback: json['correctFeedback'] as String,
    );
  }

  /// Converts this SentenceStem to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateText': templateText,
      'blankCount': blankCount,
      'blanks': blanks.map((blank) => blank.toJson()).toList(),
      'correctFeedback': correctFeedback,
    };
  }

  /// Checks if this is a single-blank stem.
  bool get isSingleBlank => blankCount == 1;

  /// Checks if this is a double-blank stem.
  bool get isDoubleBlank => blankCount == 2;

  @override
  List<Object?> get props => [
    id,
    templateText,
    blankCount,
    blanks,
    correctFeedback,
  ];

  @override
  String toString() => 'SentenceStem(id: $id, blanks: $blankCount)';
}
