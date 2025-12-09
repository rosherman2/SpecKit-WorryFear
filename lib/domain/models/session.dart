import 'package:equatable/equatable.dart';
import 'session_scenario.dart';

/// [AggregateRoot] Represents a complete game session with 10 scenarios.
/// Purpose: Manages session state including scenarios, progress, score, and review list.
///
/// The Session is the main aggregate root for game state. It tracks all scenarios
/// in the current session, which scenario is active, the user's score, and which
/// scenarios need review due to incorrect answers.
///
/// State transitions:
/// - Initial: 10 unanswered scenarios, score 0, currentIndex 0
/// - In Progress: Some scenarios answered, score accumulating
/// - Complete: All scenarios answered, final score calculated
///
/// Example:
/// ```dart
/// final session = Session(scenarios: sessionScenarios);
/// final updated = session.recordCorrect(0); // +2 points
/// final withError = updated.recordIncorrect(1); // Added to review
/// ```
class Session extends Equatable {
  /// Creates a session with the given scenarios.
  ///
  /// Parameters:
  /// - [scenarios]: List of 10 SessionScenario objects for this session
  /// - [currentIndex]: Index of the current active scenario (default: 0)
  /// - [score]: Current score (default: 0, +2 per correct answer)
  const Session({
    required this.scenarios,
    this.currentIndex = 0,
    this.score = 0,
  });

  /// List of all scenarios in this session (should be exactly 10).
  final List<SessionScenario> scenarios;

  /// Index of the currently active scenario (0-9).
  /// Used to track progress through the session.
  final int currentIndex;

  /// Current score for this session.
  /// Each correct answer awards +2 points (FR-062).
  /// Perfect session = 20 points (FR-063).
  final int score;

  /// Records a correct answer for the scenario at the given index.
  ///
  /// Creates a new Session with:
  /// - Scenario marked as answered correctly
  /// - Score increased by 2 points
  /// - Current index advanced
  ///
  /// Parameters:
  /// - [index]: Index of the scenario that was answered correctly
  ///
  /// Returns: New Session with updated state
  Session recordCorrect(int index) {
    final updatedScenarios = List<SessionScenario>.from(scenarios);
    updatedScenarios[index] = scenarios[index].recordAnswer(isCorrect: true);

    return Session(
      scenarios: updatedScenarios,
      currentIndex: currentIndex + 1,
      score: score + 2, // FR-062: +2 points per correct answer
    );
  }

  /// Records an incorrect answer for the scenario at the given index.
  ///
  /// Creates a new Session with:
  /// - Scenario marked as answered incorrectly (added to review list)
  /// - Score unchanged (no points for incorrect answers, FR-064)
  /// - Current index advanced
  ///
  /// Parameters:
  /// - [index]: Index of the scenario that was answered incorrectly
  ///
  /// Returns: New Session with updated state
  Session recordIncorrect(int index) {
    final updatedScenarios = List<SessionScenario>.from(scenarios);
    updatedScenarios[index] = scenarios[index].recordAnswer(isCorrect: false);

    return Session(
      scenarios: updatedScenarios,
      currentIndex: currentIndex + 1,
      score: score, // FR-064: No points for incorrect answers
    );
  }

  /// Gets all scenarios that were answered incorrectly.
  ///
  /// Used to populate review mode after session completion.
  /// Returns scenarios in the order they were encountered.
  List<SessionScenario> get incorrectScenarios {
    return scenarios
        .where((s) => s.isAnswered && s.isCorrect == false)
        .toList();
  }

  /// Checks if all scenarios have been answered.
  ///
  /// Session is complete when all 10 scenarios have been answered
  /// (regardless of correctness).
  bool get isComplete {
    return scenarios.every((s) => s.isAnswered);
  }

  /// Creates a copy of this session with the given fields replaced.
  ///
  /// Used for creating modified versions while maintaining immutability.
  Session copyWith({
    List<SessionScenario>? scenarios,
    int? currentIndex,
    int? score,
  }) {
    return Session(
      scenarios: scenarios ?? this.scenarios,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [scenarios, currentIndex, score];
}
