import 'package:equatable/equatable.dart';
import '../../domain/models/category.dart';
import '../../domain/models/session_scenario.dart';

/// [Event] Base class for all review mode events.
/// Purpose: Defines user actions and system events during review mode.
///
/// Review mode allows users to retry scenarios they got wrong in the main session.
/// After two incorrect attempts, the system auto-corrects and shows educational text.
sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

/// [Event] Starts review mode with scenarios that need review.
/// Purpose: Initializes review session with incorrect scenarios from main gameplay.
///
/// Example:
/// ```dart
/// bloc.add(ReviewStarted(session.incorrectScenarios));
/// ```
final class ReviewStarted extends ReviewEvent {
  /// Creates a review started event.
  const ReviewStarted(this.reviewScenarios);

  /// List of scenarios that were answered incorrectly and need review.
  final List<SessionScenario> reviewScenarios;

  @override
  List<Object?> get props => [reviewScenarios];
}

/// [Event] User attempted to answer a review scenario.
/// Purpose: Records user's answer attempt for the current review scenario.
///
/// Example:
/// ```dart
/// bloc.add(AnswerAttempted(category: CategoryRole.categoryA));
/// ```
final class AnswerAttempted extends ReviewEvent {
  /// Creates an answer attempted event.
  const AnswerAttempted({required this.category});

  /// The category role the user selected.
  final CategoryRole category;

  @override
  List<Object?> get props => [category];
}

/// [Event] Auto-correction timer completed.
/// Purpose: Triggered after 1.5s auto-correction display, advances to next scenario.
///
/// This event is dispatched internally by the BLoC after showing
/// the correct answer and educational text.
final class AutoCorrectionComplete extends ReviewEvent {
  /// Creates an auto-correction complete event.
  const AutoCorrectionComplete();
}

/// [Event] User requested to move to next review item.
/// Purpose: Manually advance to next scenario (optional, for UI controls).
final class NextReviewItem extends ReviewEvent {
  /// Creates a next review item event.
  const NextReviewItem();
}
