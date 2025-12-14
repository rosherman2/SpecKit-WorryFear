import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/application/savoring/savoring_cubit.dart';
import 'package:worry_fear_game/application/savoring/savoring_state.dart';
import 'package:worry_fear_game/domain/models/savoring_config.dart';
import 'package:worry_fear_game/domain/models/word_tile.dart';

void main() {
  group('SavoringCubit Tests', () {
    late SavoringConfig savoringConfig;

    setUp(() {
      // Create mock savoring config with 10 stems
      savoringConfig = SavoringConfig.fromJson({
        'gameId': 'test-savoring',
        'version': '1.0',
        'intro': {
          'title': 'Test',
          'conceptText': ['Test'],
          'benefitText': 'Test',
          'scientificTitle': 'Test',
          'scientificContent': 'Test',
        },
        'character': {
          'idleImage': 'test.png',
          'affirmingImage': 'test.png',
          'celebrationImage': 'test.png',
        },
        'stems': List.generate(
          10,
          (i) => {
            'id': 'stem-$i',
            'templateText': 'Test {1}',
            'blankCount': 1,
            'blanks': [
              {
                'index': 1,
                'tiles': [
                  {'text': 'correct$i', 'isCorrect': true},
                  {'text': 'wrong1$i', 'isCorrect': false},
                  {'text': 'wrong2$i', 'isCorrect': false},
                ],
                'incorrectFeedback': 'No',
              },
            ],
            'correctFeedback': 'Yes',
          },
        ),
      });
    });

    test('initial state should be SavoringInitial', () {
      // Arrange & Act
      final cubit = SavoringCubit(config: savoringConfig);

      // Assert
      expect(cubit.state, isA<SavoringInitial>());

      cubit.close();
    });

    blocTest<SavoringCubit, SavoringState>(
      'startGame should emit SavoringPlaying with first stem',
      build: () => SavoringCubit(config: savoringConfig),
      act: (cubit) => cubit.startGame(),
      expect: () => [
        isA<SavoringPlaying>()
            .having((s) => s.currentRound, 'currentRound', 1)
            .having((s) => s.totalRounds, 'totalRounds', 10),
      ],
    );

    blocTest<SavoringCubit, SavoringState>(
      'dropTile with correct tile should emit correct feedback state',
      build: () => SavoringCubit(config: savoringConfig),
      act: (cubit) {
        cubit.startGame();
        final correctTile = WordTile.fromJson({
          'text': 'correct0',
          'isCorrect': true,
        });
        cubit.dropTile(blankIndex: 1, tile: correctTile);
      },
      expect: () => [
        isA<SavoringPlaying>(), // startGame
        isA<SavoringPlaying>().having(
          (s) => s.feedbackMessage,
          'feedbackMessage',
          isNotNull,
        ),
      ],
    );

    blocTest<SavoringCubit, SavoringState>(
      'dropTile with incorrect tile should emit incorrect feedback',
      build: () => SavoringCubit(config: savoringConfig),
      act: (cubit) {
        cubit.startGame();
        final incorrectTile = WordTile.fromJson({
          'text': 'wrong10',
          'isCorrect': false,
        });
        cubit.dropTile(blankIndex: 1, tile: incorrectTile);
      },
      expect: () => [
        isA<SavoringPlaying>(), // startGame
        isA<SavoringPlaying>().having(
          (s) => s.isCurrentBlankCorrect,
          'isCurrentBlankCorrect',
          false,
        ),
      ],
    );

    blocTest<SavoringCubit, SavoringState>(
      'advanceRound should move to next round',
      build: () => SavoringCubit(config: savoringConfig),
      act: (cubit) {
        cubit.startGame();
        final correctTile = WordTile.fromJson({
          'text': 'correct0',
          'isCorrect': true,
        });
        cubit.dropTile(blankIndex: 1, tile: correctTile);
        cubit.advanceRound();
      },
      expect: () => [
        isA<SavoringPlaying>().having((s) => s.currentRound, 'currentRound', 1),
        isA<SavoringPlaying>(), // after correct drop
        isA<SavoringPlaying>().having((s) => s.currentRound, 'currentRound', 2),
      ],
    );

    blocTest<SavoringCubit, SavoringState>(
      'completing all rounds should emit SavoringCompleted',
      build: () => SavoringCubit(config: savoringConfig),
      act: (cubit) async {
        cubit.startGame();
        // Complete all 10 rounds
        for (var i = 0; i < 10; i++) {
          final correctTile = WordTile.fromJson({
            'text': 'correct$i',
            'isCorrect': true,
          });
          cubit.dropTile(blankIndex: 1, tile: correctTile);
          if (i < 9) {
            cubit.advanceRound();
          }
        }
        cubit.advanceRound(); // Final advance
      },
      verify: (cubit) {
        expect(cubit.state, isA<SavoringCompleted>());
      },
    );

    test('score should increase on correct answers', () {
      // Arrange
      final cubit = SavoringCubit(config: savoringConfig);
      cubit.startGame();

      // Act
      final correctTile = WordTile.fromJson({
        'text': 'correct0',
        'isCorrect': true,
      });
      cubit.dropTile(blankIndex: 1, tile: correctTile);

      // Assert
      final state = cubit.state as SavoringPlaying;
      expect(state.score, greaterThan(0));

      cubit.close();
    });

    test('score should not increase on incorrect answers', () {
      // Arrange
      final cubit = SavoringCubit(config: savoringConfig);
      cubit.startGame();
      final initialScore = (cubit.state as SavoringPlaying).score;

      // Act
      final incorrectTile = WordTile.fromJson({
        'text': 'wrong10',
        'isCorrect': false,
      });
      cubit.dropTile(blankIndex: 1, tile: incorrectTile);

      // Assert
      final state = cubit.state as SavoringPlaying;
      expect(state.score, equals(initialScore));

      cubit.close();
    });
  });

  // Double-blank specific tests
  group('SavoringCubit Double-Blank Tests', () {
    late SavoringConfig doubleBlankConfig;

    setUp(() {
      // Create config with double-blank stems
      doubleBlankConfig = SavoringConfig.fromJson({
        'gameId': 'test-double',
        'version': '1.0',
        'intro': {
          'title': 'Test',
          'conceptText': ['Test'],
          'benefitText': 'Test',
          'scientificTitle': 'Test',
          'scientificContent': 'Test',
        },
        'character': {
          'idleImage': 'test.png',
          'affirmingImage': 'test.png',
          'celebrationImage': 'test.png',
        },
        'stems': List.generate(
          10,
          (i) => {
            'id': 'double-stem-$i',
            'templateText': 'I can {1} this moment {2}',
            'blankCount': 2,
            'blanks': [
              {
                'index': 1,
                'tiles': [
                  {'text': 'appreciate$i', 'isCorrect': true},
                  {'text': 'dismiss$i', 'isCorrect': false},
                  {'text': 'rush$i', 'isCorrect': false},
                ],
                'incorrectFeedback': 'Try again',
              },
              {
                'index': 2,
                'tiles': [
                  {'text': 'fully$i', 'isCorrect': true},
                  {'text': 'briefly$i', 'isCorrect': false},
                  {'text': 'less$i', 'isCorrect': false},
                ],
                'incorrectFeedback': 'Not quite',
              },
            ],
            'correctFeedback': 'Great!',
          },
        ),
      });
    });

    test('double-blank stem should have blank 2 locked initially', () {
      // Arrange & Act
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();

      // Assert
      final state = cubit.state as SavoringPlaying;
      expect(state.lockedBlanks[2], isTrue);
      expect(state.lockedBlanks[1], isNull); // Blank 1 not locked

      cubit.close();
    });

    test('blank 2 should unlock when blank 1 is correctly filled', () {
      // Arrange
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();

      // Act: Drop correct tile on blank 1
      final correctTile = WordTile.fromJson({
        'text': 'appreciate0',
        'isCorrect': true,
      });
      cubit.dropTile(blankIndex: 1, tile: correctTile);

      // Assert
      final state = cubit.state as SavoringPlaying;
      expect(state.blankStates[1], isTrue); // Blank 1 is correct
      expect(state.lockedBlanks[2], isFalse); // Blank 2 is now unlocked

      cubit.close();
    });

    test('blank 2 should stay locked when blank 1 is incorrectly filled', () {
      // Arrange
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();

      // Act: Drop incorrect tile on blank 1
      final incorrectTile = WordTile.fromJson({
        'text': 'dismiss0',
        'isCorrect': false,
      });
      cubit.dropTile(blankIndex: 1, tile: incorrectTile);

      // Assert
      final state = cubit.state as SavoringPlaying;
      expect(state.blankStates[1], isFalse); // Blank 1 is incorrect
      expect(state.lockedBlanks[2], isTrue); // Blank 2 still locked

      cubit.close();
    });

    test('round is not complete until both blanks are correct', () {
      // Arrange
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();

      // Act: Fill blank 1 correctly
      final tile1 = WordTile.fromJson({
        'text': 'appreciate0',
        'isCorrect': true,
      });
      cubit.dropTile(blankIndex: 1, tile: tile1);

      // Assert: Round not complete yet
      var state = cubit.state as SavoringPlaying;
      expect(state.isRoundComplete, isFalse);

      // Act: Fill blank 2 correctly
      final tile2 = WordTile.fromJson({'text': 'fully0', 'isCorrect': true});
      cubit.dropTile(blankIndex: 2, tile: tile2);

      // Assert: Round is now complete
      state = cubit.state as SavoringPlaying;
      expect(state.isRoundComplete, isTrue);

      cubit.close();
    });

    test('score increases for each correct blank', () {
      // Arrange
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();
      final initialScore = (cubit.state as SavoringPlaying).score;

      // Act: Fill blank 1 correctly
      final tile1 = WordTile.fromJson({
        'text': 'appreciate0',
        'isCorrect': true,
      });
      cubit.dropTile(blankIndex: 1, tile: tile1);
      final scoreAfterBlank1 = (cubit.state as SavoringPlaying).score;

      // Assert: Score increased
      expect(scoreAfterBlank1, greaterThan(initialScore));

      // Act: Fill blank 2 correctly
      final tile2 = WordTile.fromJson({'text': 'fully0', 'isCorrect': true});
      cubit.dropTile(blankIndex: 2, tile: tile2);
      final scoreAfterBlank2 = (cubit.state as SavoringPlaying).score;

      // Assert: Score increased again
      expect(scoreAfterBlank2, greaterThan(scoreAfterBlank1));

      cubit.close();
    });

    test('activeBlankIndex moves to 2 after blank 1 is correct', () {
      // Arrange
      final cubit = SavoringCubit(config: doubleBlankConfig);
      cubit.startGame();

      // Assert: Initially active blank is 1
      expect((cubit.state as SavoringPlaying).activeBlankIndex, equals(1));

      // Act: Fill blank 1 correctly
      final tile1 = WordTile.fromJson({
        'text': 'appreciate0',
        'isCorrect': true,
      });
      cubit.dropTile(blankIndex: 1, tile: tile1);

      // Assert: Active blank is now 2
      expect((cubit.state as SavoringPlaying).activeBlankIndex, equals(2));

      cubit.close();
    });
  });
}
