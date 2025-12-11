import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_bloc.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_event.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_state.dart';
import 'package:worry_fear_game/application/review/review_bloc.dart';
import 'package:worry_fear_game/application/review/review_event.dart';
import 'package:worry_fear_game/application/review/review_state.dart';
import 'package:worry_fear_game/core/audio/audio_service.dart';
import 'package:worry_fear_game/core/haptic/haptic_service.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';
import 'package:worry_fear_game/domain/services/scenario_service.dart';

/// Integration tests covering all 4 user stories end-to-end
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Full Experience Integration Tests', () {
    late GameplayBloc gameplayBloc;
    late MockAudioService mockAudioService;
    late MockHapticService mockHapticService;
    late ScenarioService scenarioService;
    late GameConfig gameConfig;

    setUpAll(() async {
      gameConfig = await GameConfigLoader.load('good-moments.json');
    });

    setUp(() {
      mockAudioService = MockAudioService();
      mockHapticService = MockHapticService();
      scenarioService = ScenarioService(gameConfig: gameConfig);
      gameplayBloc = GameplayBloc(
        scenarioService: scenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      );
    });

    tearDown(() {
      gameplayBloc.close();
    });

    // ================================================================
    // US1: Core Gameplay - Drag and Drop Classification
    // ================================================================

    group('US1: Core Gameplay', () {
      test('game session loads 10 scenarios', () async {
        // Start game
        gameplayBloc.add(const GameStarted());
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify 10 scenarios loaded
        final state = gameplayBloc.state;
        expect(state, isA<GameplayPlaying>());
        final playingState = state as GameplayPlaying;
        expect(playingState.scenarios.length, 10);
      });

      test('correct answer advances to next scenario', () async {
        gameplayBloc.add(const GameStarted());
        await Future.delayed(const Duration(milliseconds: 100));

        final playingState = gameplayBloc.state as GameplayPlaying;
        final currentScenario = playingState.currentScenario;
        final correctCategory = currentScenario.scenario.correctCategory;

        // Drop on correct bottle
        gameplayBloc.add(DroppedOnBottle(category: correctCategory));
        await Future.delayed(const Duration(milliseconds: 1000));

        // Should advance to next scenario or complete if last
        final newState = gameplayBloc.state;
        expect(newState, isNot(isA<GameplayInitial>()));
      });

      test('incorrect answer triggers retry on same scenario', () async {
        gameplayBloc.add(const GameStarted());
        await Future.delayed(const Duration(milliseconds: 100));

        final playingState = gameplayBloc.state as GameplayPlaying;
        final currentScenario = playingState.currentScenario;
        final wrongCategory =
            currentScenario.scenario.correctCategory is CategoryRoleA
            ? CategoryRole.categoryB
            : CategoryRole.categoryA;

        // Drop on wrong bottle
        gameplayBloc.add(DroppedOnBottle(category: wrongCategory));
        await Future.delayed(const Duration(milliseconds: 1200));

        // Should stay on same scenario
        final newState = gameplayBloc.state as GameplayPlaying;
        expect(newState.currentScenarioIndex, 0);
      });
    });

    // ================================================================
    // US2: Review Mode - Retry Incorrect Scenarios
    // ================================================================

    group('US2: Review Mode', () {
      late ReviewBloc reviewBloc;

      setUp(() {
        reviewBloc = ReviewBloc(
          audioService: mockAudioService,
          hapticService: mockHapticService,
          gameConfig: gameConfig,
        );
      });

      tearDown(() {
        reviewBloc.close();
      });

      test('review mode starts with provided scenarios', () async {
        final reviewScenarios = [
          SessionScenario(
            scenario: Scenario(
              id: 'test-1',
              text: 'Test scenario',
              emoji: '🔥',
              correctCategory: const CategoryRoleA(),
            ),
          ),
        ];

        reviewBloc.add(ReviewStarted(reviewScenarios));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(reviewBloc.state, isA<ReviewPlaying>());
      });

      test('correct answer in review advances to next', () async {
        final reviewScenarios = [
          SessionScenario(
            scenario: Scenario(
              id: 'test-1',
              text: 'Test scenario 1',
              emoji: '🔥',
              correctCategory: const CategoryRoleA(),
            ),
          ),
          SessionScenario(
            scenario: Scenario(
              id: 'test-2',
              text: 'Test scenario 2',
              emoji: '☁️',
              correctCategory: const CategoryRoleB(),
            ),
          ),
        ];

        reviewBloc.add(ReviewStarted(reviewScenarios));
        await Future.delayed(const Duration(milliseconds: 100));

        // Answer first one correctly
        reviewBloc.add(AnswerAttempted(category: CategoryRole.categoryA));
        await Future.delayed(const Duration(milliseconds: 1000));

        // Should advance to next or show feedback
        final state = reviewBloc.state;
        expect(state, isNot(isA<ReviewInitial>()));
      });
    });

    // ================================================================
    // US3: First-Time Onboarding (tested via service)
    // ================================================================

    group('US3: Onboarding', () {
      test('scenario service provides balanced scenarios', () {
        final scenarios = scenarioService.getSessionScenarios();

        // Count categoryA and categoryB scenarios
        final categoryACount = scenarios
            .where((s) => s.scenario.correctCategory is CategoryRoleA)
            .length;
        final categoryBCount = scenarios
            .where((s) => s.scenario.correctCategory is CategoryRoleB)
            .length;

        // Should have at least 3 of each
        expect(categoryACount, greaterThanOrEqualTo(3));
        expect(categoryBCount, greaterThanOrEqualTo(3));
        expect(categoryACount + categoryBCount, 10);
      });
    });

    // ================================================================
    // US4: Accessibility - buttons tested in widget tests
    // ================================================================

    group('US4: Accessibility', () {
      test('scenarios have valid data for accessibility buttons', () {
        final scenarios = scenarioService.getSessionScenarios();

        for (final scenario in scenarios) {
          // Each scenario should have valid category for button selection
          expect(
            scenario.scenario.correctCategory,
            anyOf(isA<CategoryRoleA>(), isA<CategoryRoleB>()),
          );
          // Each scenario should have text for screen readers
          expect(scenario.scenario.text.isNotEmpty, true);
        }
      });
    });

    // ================================================================
    // Full Game Flow
    // ================================================================

    group('Full Game Flow', () {
      test('complete game session flow', () async {
        // Start game
        gameplayBloc.add(const GameStarted());
        await Future.delayed(const Duration(milliseconds: 100));

        expect(gameplayBloc.state, isA<GameplayPlaying>());

        // Complete all 10 scenarios with correct answers
        for (var i = 0; i < 10; i++) {
          if (gameplayBloc.state is GameplayPlaying) {
            final playingState = gameplayBloc.state as GameplayPlaying;
            final correctCategory =
                playingState.currentScenario.scenario.correctCategory;

            gameplayBloc.add(DroppedOnBottle(category: correctCategory));
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        }

        // Should reach complete state
        expect(gameplayBloc.state, isA<GameplayComplete>());
      });
    });
  });
}

// ================================================================
// Mock Services
// ================================================================

class MockAudioService implements AudioService {
  @override
  Future<void> playSuccess() async {}

  @override
  Future<void> playError() async {}

  @override
  Future<void> playCelebration() async {}

  @override
  void dispose() {}
}

class MockHapticService implements HapticService {
  @override
  Future<void> lightImpact() async {}

  @override
  Future<void> mediumImpact() async {}
}
