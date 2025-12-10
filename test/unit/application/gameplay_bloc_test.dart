import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_bloc.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_event.dart';
import 'package:worry_fear_game/application/gameplay/gameplay_state.dart';
import 'package:worry_fear_game/core/audio/audio_service.dart';
import 'package:worry_fear_game/core/haptic/haptic_service.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';
import 'package:worry_fear_game/domain/services/scenario_service.dart';

// Mock services
class MockScenarioService extends Mock implements ScenarioService {}

class MockAudioService extends Mock implements AudioService {}

class MockHapticService extends Mock implements HapticService {}

void main() {
  late MockScenarioService mockScenarioService;
  late MockAudioService mockAudioService;
  late MockHapticService mockHapticService;

  // Test scenarios
  final testScenarios = List.generate(
    10,
    (i) => SessionScenario(
      scenario: Scenario(
        id: 'test-$i',
        text: 'Test scenario $i',
        emoji: '🎯',
        correctCategory: i % 2 == 0 ? Category.fear : Category.worry,
      ),
    ),
  );

  setUp(() {
    mockScenarioService = MockScenarioService();
    mockAudioService = MockAudioService();
    mockHapticService = MockHapticService();

    // Default mock behavior
    when(
      () => mockScenarioService.getSessionScenarios(),
    ).thenReturn(testScenarios);
    when(() => mockAudioService.playSuccess()).thenAnswer((_) async {});
    when(() => mockAudioService.playError()).thenAnswer((_) async {});
    when(() => mockHapticService.lightImpact()).thenAnswer((_) async {});
    when(() => mockHapticService.mediumImpact()).thenAnswer((_) async {});
  });

  group('GameplayBloc', () {
    test('initial state is GameplayInitial', () {
      final bloc = GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      );

      expect(bloc.state, isA<GameplayInitial>());
      bloc.close();
    });

    blocTest<GameplayBloc, GameplayState>(
      'emits [GameplayPlaying] when GameStarted is added',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      act: (bloc) => bloc.add(const GameStarted()),
      expect: () => [
        isA<GameplayPlaying>().having(
          (s) => s.session.scenarios.length,
          'has 10 scenarios',
          10,
        ),
      ],
      verify: (_) {
        verify(() => mockScenarioService.getSessionScenarios()).called(1);
      },
    );

    blocTest<GameplayBloc, GameplayState>(
      'emits haptic feedback when DragStarted',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      seed: () => GameplayPlaying(testScenarios, currentScenarioIndex: 0),
      act: (bloc) => bloc.add(const DragStarted()),
      expect: () => [], // No state change for drag start
      verify: (_) {
        verify(() => mockHapticService.lightImpact()).called(1);
      },
    );

    blocTest<GameplayBloc, GameplayState>(
      'emits success feedback when dropped on correct bottle',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      seed: () => GameplayPlaying(testScenarios, currentScenarioIndex: 0),
      act: (bloc) => bloc.add(
        const DroppedOnBottle(category: Category.fear), // Scenario 0 is fear
      ),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        isA<GameplayCorrectFeedback>(),
        isA<GameplayPlaying>().having(
          (s) => s.currentScenarioIndex,
          'advanced to next scenario',
          1,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.playSuccess()).called(1);
      },
    );

    blocTest<GameplayBloc, GameplayState>(
      'emits error feedback when dropped on wrong bottle',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      seed: () => GameplayPlaying(testScenarios, currentScenarioIndex: 0),
      act: (bloc) => bloc.add(
        const DroppedOnBottle(
          category: Category.worry,
        ), // Wrong - scenario 0 is fear
      ),
      wait: const Duration(milliseconds: 1100),
      expect: () => [
        isA<GameplayIncorrectFeedback>(),
        isA<GameplayPlaying>(), // Stays on same scenario for retry
      ],
      verify: (_) {
        verify(() => mockAudioService.playError()).called(1);
        verify(() => mockHapticService.mediumImpact()).called(1);
      },
    );

    blocTest<GameplayBloc, GameplayState>(
      'emits GameplayComplete when all scenarios answered',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      seed: () {
        // Create session with 9 scenarios already answered
        final scenarios = List.generate(
          10,
          (i) => SessionScenario(
            scenario: Scenario(
              id: 'test-$i',
              text: 'Test $i',
              emoji: '🎯',
              correctCategory: Category.fear,
            ),
          ).recordAnswer(isCorrect: true),
        );
        // Last one unanswered
        scenarios[9] = SessionScenario(
          scenario: const Scenario(
            id: 'test-9',
            text: 'Test 9',
            emoji: '🎯',
            correctCategory: Category.fear,
          ),
        );
        return GameplayPlaying(scenarios, currentScenarioIndex: 9);
      },
      act: (bloc) => bloc.add(const DroppedOnBottle(category: Category.fear)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        isA<GameplayCorrectFeedback>(),
        isA<GameplayComplete>().having(
          (s) => s.session.isComplete,
          'session is complete',
          true,
        ),
      ],
    );

    blocTest<GameplayBloc, GameplayState>(
      'no state change when dropped outside bottles',
      build: () => GameplayBloc(
        scenarioService: mockScenarioService,
        audioService: mockAudioService,
        hapticService: mockHapticService,
      ),
      seed: () => GameplayPlaying(testScenarios, currentScenarioIndex: 0),
      act: (bloc) => bloc.add(const DropOutside()),
      expect: () => [], // No state change, no sound
      verify: (_) {
        verifyNever(() => mockAudioService.playSuccess());
        verifyNever(() => mockAudioService.playError());
      },
    );
  });
}
