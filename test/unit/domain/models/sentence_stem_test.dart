import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/sentence_stem.dart';

void main() {
  group('SentenceStem Model Tests', () {
    test('should create single-blank SentenceStem from JSON', () {
      // Arrange: Valid single-blank stem JSON
      final json = {
        'id': 'stem-1',
        'templateText': 'It is okay to {1}',
        'blankCount': 1,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'enjoy this moment', 'isCorrect': true},
              {'text': 'keep moving', 'isCorrect': false},
              {'text': 'focus on what is wrong', 'isCorrect': false},
            ],
            'incorrectFeedback': 'That focuses away from the good. Try again.',
          },
        ],
        'correctFeedback': 'You let the moment stay.',
      };

      // Act: Create SentenceStem
      final stem = SentenceStem.fromJson(json);

      // Assert: Fields are correct
      expect(stem.id, equals('stem-1'));
      expect(stem.templateText, equals('It is okay to {1}'));
      expect(stem.blankCount, equals(1));
      expect(stem.blanks.length, equals(1));
      expect(stem.correctFeedback, equals('You let the moment stay.'));
    });

    test('should create double-blank SentenceStem from JSON', () {
      // Arrange: Valid double-blank stem JSON
      final json = {
        'id': 'stem-5',
        'templateText': 'I can {1} this moment {2}.',
        'blankCount': 2,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'appreciate', 'isCorrect': true},
              {'text': 'dismiss', 'isCorrect': false},
              {'text': 'rush', 'isCorrect': false},
            ],
            'incorrectFeedback':
                'That doesn not bring you closer. Try another.',
          },
          {
            'index': 2,
            'tiles': [
              {'text': 'fully', 'isCorrect': true},
              {'text': 'briefly', 'isCorrect': false},
              {'text': 'less', 'isCorrect': false},
            ],
            'incorrectFeedback': 'That cuts the moment short. Try another.',
          },
        ],
        'correctFeedback': 'You made space for the good.',
      };

      // Act: Create SentenceStem
      final stem = SentenceStem.fromJson(json);

      // Assert: Fields are correct
      expect(stem.id, equals('stem-5'));
      expect(stem.blankCount, equals(2));
      expect(stem.blanks.length, equals(2));
      expect(stem.blanks[0].index, equals(1));
      expect(stem.blanks[1].index, equals(2));
    });

    test('should convert SentenceStem to JSON', () {
      // Arrange: Create a SentenceStem programmatically
      final json = {
        'id': 'test-stem',
        'templateText': 'Test {1}',
        'blankCount': 1,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'correct', 'isCorrect': true},
              {'text': 'wrong1', 'isCorrect': false},
              {'text': 'wrong2', 'isCorrect': false},
            ],
            'incorrectFeedback': 'Try again.',
          },
        ],
        'correctFeedback': 'Correct!',
      };
      final stem = SentenceStem.fromJson(json);

      // Act: Convert to JSON
      final result = stem.toJson();

      // Assert: JSON is correct
      expect(result['id'], equals('test-stem'));
      expect(result['blankCount'], equals(1));
      expect(result['blanks'], isA<List>());
    });

    test('should support equality comparison', () {
      // Arrange: Create two identical stems
      final json = {
        'id': 'stem-1',
        'templateText': 'Test {1}',
        'blankCount': 1,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'a', 'isCorrect': true},
              {'text': 'b', 'isCorrect': false},
              {'text': 'c', 'isCorrect': false},
            ],
            'incorrectFeedback': 'No',
          },
        ],
        'correctFeedback': 'Yes',
      };

      final stem1 = SentenceStem.fromJson(json);
      final stem2 = SentenceStem.fromJson(json);

      // Assert: Equality works
      expect(stem1, equals(stem2));
    });

    test('should throw on missing required fields', () {
      // Arrange: Invalid JSON - missing id
      final json = {
        'templateText': 'Test {1}',
        'blankCount': 1,
        'blanks': [],
        'correctFeedback': 'Yes',
      };

      // Act & Assert: Should throw
      expect(() => SentenceStem.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should get correct tile for a blank', () {
      // Arrange: Create stem with blanks
      final json = {
        'id': 'stem-1',
        'templateText': 'Test {1}',
        'blankCount': 1,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'correct', 'isCorrect': true},
              {'text': 'wrong', 'isCorrect': false},
              {'text': 'wrong2', 'isCorrect': false},
            ],
            'incorrectFeedback': 'No',
          },
        ],
        'correctFeedback': 'Yes',
      };
      final stem = SentenceStem.fromJson(json);

      // Act: Get correct tile for blank 1
      final correctTile = stem.blanks[0].tiles.firstWhere((t) => t.isCorrect);

      // Assert: Found correct tile
      expect(correctTile.text, equals('correct'));
      expect(correctTile.isCorrect, isTrue);
    });
  });
}
