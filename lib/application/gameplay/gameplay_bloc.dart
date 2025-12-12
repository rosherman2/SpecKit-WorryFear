import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/audio/audio_service.dart';
import '../../core/haptic/haptic_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/models/session.dart';
import '../../domain/services/scenario_service.dart';
import 'gameplay_event.dart';
import 'gameplay_state.dart';

/// [Bloc] Manages gameplay state and user interactions.
/// Purpose: Handles drag-drop logic, scoring, and feedback animations.
///
/// The GameplayBloc orchestrates the core game loop:
/// 1. Start game → Load 10 random scenarios
/// 2. Drag card → Provide haptic feedback
/// 3. Drop on bottle → Check answer, play sound, update score
/// 4. Advance to next → Continue until all 10 answered
/// 5. Complete → Transition to completion screen
///
/// Dependencies injected via constructor per constitution (no DI framework).
///
/// Example:
/// ```dart
/// final bloc = GameplayBloc(
///   scenarioService: scenarioService,
///   audioService: audioService,
///   hapticService: hapticService,
/// );
/// bloc.add(const GameStarted());
/// ```
class GameplayBloc extends Bloc<GameplayEvent, GameplayState> {
  /// Creates a gameplay BLoC with required service dependencies.
  GameplayBloc({
    required this.scenarioService,
    required this.audioService,
    required this.hapticService,
  }) : super(const GameplayInitial()) {
    on<GameStarted>(_onGameStarted);
    on<DragStarted>(_onDragStarted);
    on<DroppedOnBottle>(_onDroppedOnBottle);
    on<DropOutside>(_onDropOutside);
    on<NextScenarioRequested>(_onNextScenarioRequested);
  }

  /// Service for loading random scenarios.
  final ScenarioService scenarioService;

  /// Service for playing sound effects.
  final AudioService audioService;

  /// Service for haptic feedback.
  final HapticService hapticService;

  /// Handles game start - loads scenarios and begins gameplay.
  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameplayState> emit,
  ) async {
    AppLogger.info(
      'GameplayBloc',
      '_onGameStarted',
      () => 'Starting new game session',
    );

    // Get 10 random scenarios from service
    final scenarios = scenarioService.getSessionScenarios();

    AppLogger.debug(
      'GameplayBloc',
      '_onGameStarted',
      () => 'Loaded ${scenarios.length} scenarios',
    );

    // Transition to playing state
    emit(GameplayPlaying(scenarios, currentScenarioIndex: 0));
  }

  /// Handles drag start - provides haptic feedback (FR-023).
  Future<void> _onDragStarted(
    DragStarted event,
    Emitter<GameplayState> emit,
  ) async {
    // Provide light haptic feedback when drag starts
    await hapticService.lightImpact();
    // No state change - just feedback
  }

  /// Handles drop on bottle - checks answer and provides feedback.
  Future<void> _onDroppedOnBottle(
    DroppedOnBottle event,
    Emitter<GameplayState> emit,
  ) async {
    if (state is! GameplayPlaying) return;

    final playingState = state as GameplayPlaying;
    final currentScenario = playingState.currentScenario;
    final isCorrect =
        currentScenario.scenario.correctCategory == event.category;

    if (isCorrect) {
      // Correct answer
      AppLogger.info(
        'GameplayBloc',
        '_onDroppedOnBottle',
        () =>
            'Correct answer for scenario ${playingState.currentScenarioIndex + 1}',
      );

      await audioService.playSuccess(); // FR-029: Play success sound

      // Update scenario as answered correctly
      final updatedScenarios = List.of(playingState.scenarios);
      updatedScenarios[playingState.currentScenarioIndex] = currentScenario
          .recordAnswer(isCorrect: true);

      // Emit feedback state with bottle position for flying animation
      emit(GameplayCorrectFeedback(bottlePosition: event.bottlePosition));

      // Wait for animation to complete (800ms animation + 100ms buffer)
      await Future.delayed(const Duration(milliseconds: 900));

      // Check if all scenarios completed
      final allAnswered = updatedScenarios.every((s) => s.isAnswered);

      if (allAnswered) {
        // Session complete - calculate final score
        await audioService.playCelebration(); // FR-030: Play celebration sound

        final finalScore =
            updatedScenarios
                .where((s) => s.isAnswered && s.isCorrect == true)
                .length *
            2;
        final session = Session(scenarios: updatedScenarios, score: finalScore);
        emit(GameplayComplete(session));
      } else {
        // Advance to next scenario
        emit(
          GameplayPlaying(
            updatedScenarios,
            currentScenarioIndex: playingState.currentScenarioIndex + 1,
          ),
        );
      }
    } else {
      // Incorrect answer
      AppLogger.info(
        'GameplayBloc',
        '_onDroppedOnBottle',
        () =>
            'Incorrect answer for scenario ${playingState.currentScenarioIndex + 1}',
      );

      await audioService.playError(); // FR-035: Play error sound
      await hapticService.mediumImpact(); // FR-036: Haptic pulse

      // Update scenario as answered incorrectly
      final updatedScenarios = List.of(playingState.scenarios);
      updatedScenarios[playingState.currentScenarioIndex] = currentScenario
          .recordAnswer(isCorrect: false);

      // Emit feedback state
      emit(const GameplayIncorrectFeedback());

      // Wait for shake and error display (300ms shake + 700ms display)
      await Future.delayed(const Duration(milliseconds: 1000));

      // Stay on same scenario for retry (FR-037)
      emit(
        GameplayPlaying(
          updatedScenarios,
          currentScenarioIndex: playingState.currentScenarioIndex,
        ),
      );
    }
  }

  /// Handles drop outside bottles - no feedback per FR-040 to FR-042.
  void _onDropOutside(DropOutside event, Emitter<GameplayState> emit) {
    // No state change, no sound, card returns to center via UI animation
  }

  /// Handles advancing to next scenario after feedback animation.
  void _onNextScenarioRequested(
    NextScenarioRequested event,
    Emitter<GameplayState> emit,
  ) {
    if (state is! GameplayPlaying) return;

    final playingState = state as GameplayPlaying;

    // Check if there are more scenarios
    if (playingState.currentScenarioIndex < playingState.scenarios.length - 1) {
      emit(
        GameplayPlaying(
          playingState.scenarios,
          currentScenarioIndex: playingState.currentScenarioIndex + 1,
        ),
      );
    } else {
      // All scenarios complete - use session getter to calculate score
      emit(GameplayComplete(playingState.session));
    }
  }
}
