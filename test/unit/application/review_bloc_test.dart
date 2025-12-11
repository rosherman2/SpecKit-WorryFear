import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

// Mock services
class MockAudioService extends Mock implements AudioService {}

class MockHapticService extends Mock implements HapticService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAudioService mockAudioService;
  late MockHapticService mockHapticService;
  late GameConfig gameConfig;

  // Test scenarios for review
  final testReviewScenarios = [
    SessionScenario(
      scenario: Scenario(
        id: 'review-1',
        text: 'Review scenario 1',
        emoji: '🎯',
        correctCategory: const CategoryRoleA(),
      ),
    ).recordAnswer(isCorrect: false), // Incorrect, needs review
    SessionScenario(
      scenario: Scenario(
        id: 'review-2',
        text: 'Review scenario 2',
        emoji: '🎯',
        correctCategory: const CategoryRoleB(),
      ),
    ).recordAnswer(isCorrect: false), // Incorrect, needs review
  ];

  setUpAll(() async {
    // Load config once for all tests
    gameConfig = await GameConfigLoader.load('good-moments.json');
  });

  setUp(() {
    mockAudioService = MockAudioService();
    mockHapticService = MockHapticService();

    // Default mock behavior
    when(() => mockAudioService.playSuccess()).thenAnswer((_) async {});
    when(() => mockAudioService.playError()).thenAnswer((_) async {});
    when(() => mockHapticService.mediumImpact()).thenAnswer((_) async {});
  });

  group('ReviewBloc', () {
    test('initial state is ReviewInitial', () {
      final bloc = ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      );

      expect(bloc.state, isA<ReviewInitial>());
      bloc.close();
    });

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewPlaying] when ReviewStarted is added',
      build: () => ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      ),
      act: (bloc) => bloc.add(ReviewStarted(testReviewScenarios)),
      expect: () => [
        isA<ReviewPlaying>().having(
          (s) => s.reviewScenarios.length,
          'has 2 review scenarios',
          2,
        ),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits success and advances on correct answer',
      build: () => ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      ),
      seed: () => ReviewPlaying(testReviewScenarios, currentIndex: 0),
      act: (bloc) => bloc.add(
        AnswerAttempted(category: CategoryRole.categoryA), // Correct
      ),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        isA<ReviewCorrectFeedback>(),
        isA<ReviewPlaying>().having(
          (s) => s.currentIndex,
          'advanced to next',
          1,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.playSuccess()).called(1);
      },
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits error on first wrong answer, stays on same scenario',
      build: () => ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      ),
      seed: () => ReviewPlaying(testReviewScenarios, currentIndex: 0),
      act: (bloc) => bloc.add(
        AnswerAttempted(category: CategoryRole.categoryB), // Wrong
      ),
      wait: const Duration(milliseconds: 1100),
      expect: () => [
        isA<ReviewIncorrectFeedback>(),
        isA<ReviewPlaying>().having(
          (s) => s.currentIndex,
          'stays on same scenario',
          0,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.playError()).called(1);
        verify(() => mockHapticService.mediumImpact()).called(1);
      },
    );

    blocTest<ReviewBloc, ReviewState>(
      'triggers auto-correction on second wrong answer',
      build: () => ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      ),
      seed: () => ReviewPlaying(
        testReviewScenarios,
        currentIndex: 0,
        attemptCount: 1, // Already failed once
      ),
      act: (bloc) => bloc.add(
        AnswerAttempted(category: CategoryRole.categoryB), // Wrong again
      ),
      wait: const Duration(
        milliseconds: 2600,
      ), // 1000ms error + 1500ms auto-correction
      expect: () => [
        isA<ReviewIncorrectFeedback>(),
        isA<ReviewAutoCorrection>(),
        isA<ReviewPlaying>().having(
          (s) => s.currentIndex,
          'advanced after auto-correction',
          1,
        ),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits ReviewComplete when all scenarios reviewed',
      build: () => ReviewBloc(
        audioService: mockAudioService,
        hapticService: mockHapticService,
        gameConfig: gameConfig,
      ),
      seed: () => ReviewPlaying(testReviewScenarios, currentIndex: 1),
      act: (bloc) => bloc.add(
        AnswerAttempted(category: CategoryRole.categoryB), // Correct for last
      ),
      wait: const Duration(milliseconds: 1000),
      expect: () => [isA<ReviewCorrectFeedback>(), isA<ReviewComplete>()],
    );
  });
}
