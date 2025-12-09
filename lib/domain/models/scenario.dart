import 'package:equatable/equatable.dart';
import 'category.dart';

/// [Model] Represents a single scenario in the cognitive training game.
/// Purpose: Immutable data class for scenario content and correct classification.
///
/// Each scenario presents a situation that the user must classify as either
/// fear (immediate danger) or worry (future concern). Scenarios include
/// emoji for visual appeal and text description.
///
/// Example:
/// ```dart
/// const scenario = Scenario(
///   id: 'fear-1',
///   text: 'A car just swerved toward me',
///   emoji: '🚗',
///   correctCategory: Category.fear,
/// );
/// ```
class Scenario extends Equatable {
  /// Creates a scenario with the given properties.
  ///
  /// All parameters are required and must not be null.
  const Scenario({
    required this.id,
    required this.text,
    required this.emoji,
    required this.correctCategory,
  });

  /// Unique identifier for this scenario.
  /// Used for tracking and avoiding duplicates in sessions.
  final String id;

  /// The scenario text presented to the user.
  /// Should be a clear, concise description of the situation.
  final String text;

  /// Emoji icon representing the scenario visually.
  /// Displayed alongside the text for visual appeal.
  final String emoji;

  /// The correct category classification for this scenario.
  /// Either Category.fear (immediate danger) or Category.worry (future concern).
  final Category correctCategory;

  /// Creates a copy of this scenario with the given fields replaced.
  ///
  /// Used for creating modified versions while maintaining immutability.
  /// Any field not provided will retain its current value.
  Scenario copyWith({
    String? id,
    String? text,
    String? emoji,
    Category? correctCategory,
  }) {
    return Scenario(
      id: id ?? this.id,
      text: text ?? this.text,
      emoji: emoji ?? this.emoji,
      correctCategory: correctCategory ?? this.correctCategory,
    );
  }

  @override
  List<Object?> get props => [id, text, emoji, correctCategory];
}
