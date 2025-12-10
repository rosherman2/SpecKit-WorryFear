import 'package:equatable/equatable.dart';
import '../../domain/models/session_scenario.dart';

/// [State] Base class for all review mode states.
/// Purpose: Represents the current state of the review session.
sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

/// [State] Initial state before review starts.
/// Purpose: Waiting for ReviewStarted event.
final class ReviewInitial extends ReviewState {
  /// Creates initial review state.
  const ReviewInitial();
}

/// [State] Actively reviewing scenarios.
/// Purpose: User is answering review scenarios.
///
/// Tracks current scenario, attempt count, and progress.
final class ReviewPlaying extends ReviewState {
  /// Creates a review playing state.
  const ReviewPlaying(
    this.reviewScenarios, {
    this.currentIndex = 0,
    this.attemptCount = 0,
  });

  /// List of scenarios being reviewed.
  final List<SessionScenario> reviewScenarios;

  /// Index of current scenario being reviewed (0-based).
  final int currentIndex;

  /// Number of attempts on current scenario (0, 1, or 2).
  /// After 2 failed attempts, auto-correction triggers.
  final int attemptCount;

  /// Gets the current scenario being reviewed.
  SessionScenario get currentScenario => reviewScenarios[currentIndex];

  @override
  List<Object?> get props => [reviewScenarios, currentIndex, attemptCount];
}

/// [State] Showing correct answer feedback.
/// Purpose: Brief success state before advancing.
final class ReviewCorrectFeedback extends ReviewState {
  /// Creates correct feedback state.
  const ReviewCorrectFeedback();
}

/// [State] Showing incorrect answer feedback.
/// Purpose: Brief error state, user can retry.
final class ReviewIncorrectFeedback extends ReviewState {
  /// Creates incorrect feedback state.
  const ReviewIncorrectFeedback();
}

/// [State] Auto-correction in progress.
/// Purpose: Showing correct answer + educational text after 2 failures.
///
/// Displays for 1.5 seconds before auto-advancing.
final class ReviewAutoCorrection extends ReviewState {
  /// Creates auto-correction state.
  const ReviewAutoCorrection({
    required this.correctCategory,
    required this.educationalText,
  });

  /// The correct category for this scenario.
  final String correctCategory;

  /// Educational explanation (e.g., "Fear is about immediate danger").
  final String educationalText;

  @override
  List<Object?> get props => [correctCategory, educationalText];
}

/// [State] All review scenarios completed.
/// Purpose: Review session finished, return to main flow.
final class ReviewComplete extends ReviewState {
  /// Creates review complete state.
  const ReviewComplete();
}
