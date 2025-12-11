import 'package:equatable/equatable.dart';
import '../../domain/models/category.dart';

/// [Event] Base class for all gameplay events.
/// Purpose: Defines user interactions during gameplay.
///
/// Events are sealed to ensure exhaustive handling in the BLoC.
/// All events extend Equatable for proper equality comparison.
sealed class GameplayEvent extends Equatable {
  /// Creates a gameplay event.
  const GameplayEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when user starts a new game session.
///
/// This loads 10 random scenarios and transitions to playing state.
class GameStarted extends GameplayEvent {
  /// Creates a game started event.
  const GameStarted();
}

/// Event triggered when user starts dragging a scenario card.
///
/// Triggers haptic feedback per FR-023.
class DragStarted extends GameplayEvent {
  /// Creates a drag started event.
  const DragStarted();
}

/// Event triggered when user drops card on a bottle.
///
/// Parameters:
/// - [category]: Which bottle the card was dropped on (categoryA or categoryB)
class DroppedOnBottle extends GameplayEvent {
  /// Creates a dropped on bottle event.
  const DroppedOnBottle({required this.category});

  /// The category role of the bottle where card was dropped.
  final CategoryRole category;

  @override
  List<Object?> get props => [category];
}

/// Event triggered when user drops card outside both bottles.
///
/// Card should return to center with no feedback per FR-040 to FR-042.
class DropOutside extends GameplayEvent {
  /// Creates a drop outside event.
  const DropOutside();
}

/// Event triggered to advance to next scenario after feedback animation.
///
/// Used internally after correct answer feedback completes.
class NextScenarioRequested extends GameplayEvent {
  /// Creates a next scenario requested event.
  const NextScenarioRequested();
}
