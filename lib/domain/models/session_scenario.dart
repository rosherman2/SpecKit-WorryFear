import 'package:equatable/equatable.dart';
import 'scenario.dart';

/// [ValueObject] Wraps a Scenario with session-specific state tracking.
/// Purpose: Tracks answer attempts and correctness for a scenario within a session.
///
/// This value object maintains the state of how a user has interacted with
/// a particular scenario during their current game session. It tracks whether
/// the scenario has been answered, if the answer was correct, and how many
/// attempts were made.
///
/// Example:
/// ```dart
/// final sessionScenario = SessionScenario(scenario: myScenario);
/// final answered = sessionScenario.recordAnswer(isCorrect: true);
/// ```
class SessionScenario extends Equatable {
  /// Creates a session scenario wrapper for the given scenario.
  ///
  /// Initially, the scenario is unanswered with zero attempts.
  const SessionScenario({
    required this.scenario,
    this.isAnswered = false,
    this.isCorrect,
    this.attemptCount = 0,
    this.wasEverIncorrect = false,
  });

  /// The underlying scenario being tracked.
  final Scenario scenario;

  /// Whether this scenario has been answered in the current session.
  /// Starts as false, becomes true after first answer attempt.
  final bool isAnswered;

  /// Whether the user's answer was correct.
  /// Null if not yet answered, true if correct, false if incorrect.
  final bool? isCorrect;

  /// Number of times the user has attempted this scenario.
  /// Increments with each answer attempt (used in review mode).
  final int attemptCount;

  /// Whether this scenario was ever answered incorrectly.
  /// Once true, stays true even if later answered correctly.
  /// Used to determine if scenario needs review.
  final bool wasEverIncorrect;

  /// Records an answer attempt for this scenario.
  ///
  /// Creates a new SessionScenario with updated state reflecting the answer.
  /// Increments attempt count and marks as answered.
  ///
  /// Parameters:
  /// - [isCorrect]: Whether the user's answer was correct
  ///
  /// Returns: New SessionScenario with updated state
  SessionScenario recordAnswer({required bool isCorrect}) {
    return SessionScenario(
      scenario: scenario,
      isAnswered: true,
      isCorrect: isCorrect,
      attemptCount: attemptCount + 1,
      wasEverIncorrect:
          wasEverIncorrect || !isCorrect, // Once wrong, always wrong
    );
  }

  /// Creates a copy of this session scenario with the given fields replaced.
  ///
  /// Used for creating modified versions while maintaining immutability.
  SessionScenario copyWith({
    Scenario? scenario,
    bool? isAnswered,
    bool? isCorrect,
    int? attemptCount,
    bool? wasEverIncorrect,
  }) {
    return SessionScenario(
      scenario: scenario ?? this.scenario,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      attemptCount: attemptCount ?? this.attemptCount,
      wasEverIncorrect: wasEverIncorrect ?? this.wasEverIncorrect,
    );
  }

  @override
  List<Object?> get props => [
    scenario,
    isAnswered,
    isCorrect,
    attemptCount,
    wasEverIncorrect,
  ];
}
