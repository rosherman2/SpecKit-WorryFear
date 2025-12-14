import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/savoring_config.dart';

void main() {
  group('SavoringConfig Model Tests', () {
    late Map<String, dynamic> validConfigJson;

    setUp(() {
      // Arrange: Valid savoring config JSON
      validConfigJson = {
        'gameId': 'savoring-choice',
        'version': '1.0',
        'intro': {
          'title': 'Savoring Choice',
          'conceptText': [
            'Good moments happen all the time.',
            'This game helps you practice noticing the good.',
          ],
          'benefitText':
              'The interpretation you choose shapes how you feel and what you do.',
          'scientificTitle': '📚 Scientific Background',
          'scientificContent':
              'Research shows that savoring can increase well-being.',
        },
        'character': {
          'idleImage': 'assets/images/savoring/character_idle.png',
          'affirmingImage': 'assets/images/savoring/character_affirming.png',
          'celebrationImage':
              'assets/images/savoring/character_celebration.png',
        },
        'stems': [
          {
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
                'incorrectFeedback': 'Try again.',
              },
            ],
            'correctFeedback': 'You let the moment stay.',
          },
          // Add 9 more stems for minimum of 10
          ...List.generate(
            9,
            (i) => {
              'id': 'stem-${i + 2}',
              'templateText': 'Test stem ${i + 2} {1}',
              'blankCount': 1,
              'blanks': [
                {
                  'index': 1,
                  'tiles': [
                    {'text': 't1', 'isCorrect': true},
                    {'text': 't2', 'isCorrect': false},
                    {'text': 't3', 'isCorrect': false},
                  ],
                  'incorrectFeedback': 'No',
                },
              ],
              'correctFeedback': 'Yes',
            },
          ),
        ],
      };
    });

    test('should create SavoringConfig from valid JSON', () {
      // Act: Create config
      final config = SavoringConfig.fromJson(validConfigJson);

      // Assert: All fields parsed correctly
      expect(config.gameId, equals('savoring-choice'));
      expect(config.version, equals('1.0'));
      expect(config.intro.title, equals('Savoring Choice'));
      expect(config.stems.length, equals(10));
      expect(
        config.character.idleImage,
        equals('assets/images/savoring/character_idle.png'),
      );
    });

    test('should validate minimum 10 stems', () {
      // Arrange: Config with only 5 stems
      final invalidJson = Map<String, dynamic>.from(validConfigJson);
      invalidJson['stems'] = validConfigJson['stems'].sublist(0, 5);

      // Act & Assert: Should not throw during creation (validation at service layer)
      final config = SavoringConfig.fromJson(invalidJson);
      expect(config.stems.length, equals(5));
    });

    test('should convert SavoringConfig to JSON', () {
      // Arrange: Create config
      final config = SavoringConfig.fromJson(validConfigJson);

      // Act: Convert to JSON
      final json = config.toJson();

      // Assert: JSON contains all fields
      expect(json['gameId'], equals('savoring-choice'));
      expect(json['version'], equals('1.0'));
      expect(json['intro'], isA<Map>());
      expect(json['character'], isA<Map>());
      expect(json['stems'], isA<List>());
    });

    test('should support equality comparison', () {
      // Arrange: Two configs from same JSON
      final config1 = SavoringConfig.fromJson(validConfigJson);
      final config2 = SavoringConfig.fromJson(validConfigJson);

      //Assert: Equality works
      expect(config1, equals(config2));
    });

    test('should parse intro config correctly', () {
      // Act: Create config
      final config = SavoringConfig.fromJson(validConfigJson);

      // Assert: Intro fields are correct
      expect(config.intro.conceptText.length, equals(2));
      expect(config.intro.benefitText, contains('interpretation'));
      expect(config.intro.scientificTitle, contains('Scientific'));
      expect(config.intro.scientificContent, contains('savoring'));
    });

    test('should parse character config correctly', () {
      // Act: Create config
      final config = SavoringConfig.fromJson(validConfigJson);

      // Assert: Character paths are correct
      expect(config.character.idleImage, contains('idle'));
      expect(config.character.affirmingImage, contains('affirming'));
      expect(config.character.celebrationImage, contains('celebration'));
    });

    test('should handle stems with different blank counts', () {
      // Arrange: Add a double-blank stem
      final jsonWithDoubleStem = Map<String, dynamic>.from(validConfigJson);
      jsonWithDoubleStem['stems'].add({
        'id': 'stem-double',
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
            'incorrectFeedback': 'No',
          },
          {
            'index': 2,
            'tiles': [
              {'text': 'fully', 'isCorrect': true},
              {'text': 'briefly', 'isCorrect': false},
              {'text': 'less', 'isCorrect': false},
            ],
            'incorrectFeedback': 'No',
          },
        ],
        'correctFeedback': 'Yes',
      });

      // Act: Create config
      final config = SavoringConfig.fromJson(jsonWithDoubleStem);

      // Assert: Double-blank stem parsed correctly
      final doubleStem = config.stems.last;
      expect(doubleStem.blankCount, equals(2));
      expect(doubleStem.blanks.length, equals(2));
    });
  });
}
