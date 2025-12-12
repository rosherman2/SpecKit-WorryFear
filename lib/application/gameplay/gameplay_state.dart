import 'dart:ui';

import 'package:equatable/equatable.dart';
import '../../domain/models/session.dart';
import '../../domain/models/session_scenario.dart';

/// [State] Base class for all gameplay states.
/// Purpose: Represents the current state of gameplay.
///
/// States are sealed to ensure exhaustive handling in UI.
/// All states extend Equatable for proper comparison.
sealed class GameplayState extends Equatable {
  /// Creates a gameplay state.
  const GameplayState();

  @override
  List<Object?> get props => [];
}

/// Initial state before game starts.
///
/// Displayed on intro screen before user taps Start button.
class GameplayInitial extends GameplayState {
  /// Creates an initial gameplay state.
  const GameplayInitial();
}

/// State during active gameplay with current scenario displayed.
///
/// User can drag and drop scenario cards in this state.
class GameplayPlaying extends GameplayState {
  /// Creates a playing state with scenario list and current index.
  const GameplayPlaying(this.scenarios, {required this.currentScenarioIndex});

  /// All scenarios in the current session (wrapped in SessionScenario).
  final List<SessionScenario> scenarios;

  /// Index of the currently displayed scenario (0-9).
  final int currentScenarioIndex;

  /// Gets the current active scenario.
  SessionScenario get currentScenario => scenarios[currentScenarioIndex];

  /// Converts to Session model for persistence/calculations.
  Session get session => Session(
    scenarios: scenarios,
    currentIndex: currentScenarioIndex,
    score:
        scenarios.where((s) => s.isAnswered && s.isCorrect == true).length * 2,
  );

  @override
  List<Object?> get props => [scenarios, currentScenarioIndex];
}

/// State showing correct answer feedback animation.
///
/// Brief state for success animation before advancing to next scenario.
/// Contains bottle position for flying points animation.
class GameplayCorrectFeedback extends GameplayState {
  /// Creates a correct feedback state with bottle position for animation.
  const GameplayCorrectFeedback({required this.bottlePosition});

  /// Screen position of the correct bottle for flying points animation.
  final Offset bottlePosition;

  @override
  List<Object?> get props => [bottlePosition];
}

/// State showing incorrect answer feedback animation.
///
/// Brief state for error animation before returning to same scenario.
/// Duration: per AnimationDurations.cardShake + errorBorderFade.
class GameplayIncorrectFeedback extends GameplayState {
  /// Creates an incorrect feedback state.
  const GameplayIncorrectFeedback();
}

/// State when all 10 scenarios completed.
///
/// Transitions to completion screen with celebration animation.
class GameplayComplete extends GameplayState {
  /// Creates a complete state with final session results.
  const GameplayComplete(this.session);

  /// The completed session with final score and review list.
  final Session session;

  @override
  List<Object?> get props => [session];
}
