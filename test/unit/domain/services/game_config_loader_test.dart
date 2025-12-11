import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameConfigLoader', () {
    test('should load valid config from assets', () async {
      // Arrange
      const validJson = '''
      {
        "gameId": "test-game",
        "version": "1.0",
        "intro": {
          "title": "Test Game",
          "educationalText": ["Line 1", "Line 2"],
          "scientificTitle": "Science",
          "scientificContent": "Content"
        },
        "categoryA": {
          "id": "cat-a",
          "name": "Category A",
          "subtitle": "(A)",
          "colorStart": "#FF0000",
          "colorEnd": "#FF0000",
          "icon": "A",
          "educationalText": "A text"
        },
        "categoryB": {
          "id": "cat-b",
          "name": "Category B",
          "subtitle": "(B)",
          "colorStart": "#00FF00",
          "colorEnd": "#00FF00",
          "icon": "B",
          "educationalText": "B text"
        },
        "scenarios": [
          {"id": "s1", "text": "Scenario 1", "emoji": "1", "correctCategory": "categoryA"},
          {"id": "s2", "text": "Scenario 2", "emoji": "2", "correctCategory": "categoryB"},
          {"id": "s3", "text": "Scenario 3", "emoji": "3", "correctCategory": "categoryA"},
          {"id": "s4", "text": "Scenario 4", "emoji": "4", "correctCategory": "categoryB"},
          {"id": "s5", "text": "Scenario 5", "emoji": "5", "correctCategory": "categoryA"},
          {"id": "s6", "text": "Scenario 6", "emoji": "6", "correctCategory": "categoryB"},
          {"id": "s7", "text": "Scenario 7", "emoji": "7", "correctCategory": "categoryA"},
          {"id": "s8", "text": "Scenario 8", "emoji": "8", "correctCategory": "categoryB"},
          {"id": "s9", "text": "Scenario 9", "emoji": "9", "correctCategory": "categoryA"},
          {"id": "s10", "text": "Scenario 10", "emoji": "0", "correctCategory": "categoryB"}
        ]
      }
      ''';

      // Mock asset loading
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
            final String key = utf8.decode(message!.buffer.asUint8List());
            if (key == 'assets/configs/test-game.json') {
              return ByteData.sublistView(utf8.encode(validJson));
            }
            return null;
          });

      // Act
      final config = await GameConfigLoader.load('test-game.json');

      // Assert
      expect(config.gameId, 'test-game');
      expect(config.scenarios.length, 10);
    });

    test('should validate minimum scenario count', () async {
      // Arrange
      const invalidJson = '''
      {
        "gameId": "invalid-game",
        "version": "1.0",
        "intro": {
          "title": "Test",
          "educationalText": ["Test"],
          "scientificTitle": "Science",
          "scientificContent": "Content"
        },
        "categoryA": {
          "id": "a",
          "name": "A",
          "subtitle": "(A)",
          "colorStart": "#FF0000",
          "colorEnd": "#FF0000",
          "icon": "A",
          "educationalText": "A"
        },
        "categoryB": {
          "id": "b",
          "name": "B",
          "subtitle": "(B)",
          "colorStart": "#00FF00",
          "colorEnd": "#00FF00",
          "icon": "B",
          "educationalText": "B"
        },
        "scenarios": [
          {"id": "s1", "text": "Only one", "emoji": "1", "correctCategory": "categoryA"}
        ]
      }
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
            final String key = utf8.decode(message!.buffer.asUint8List());
            if (key == 'assets/configs/invalid-game.json') {
              return ByteData.sublistView(utf8.encode(invalidJson));
            }
            return null;
          });

      // Act & Assert
      expect(
        () => GameConfigLoader.load('invalid-game.json'),
        throwsA(isA<ConfigValidationError>()),
      );
    });

    test(
      'should provide helpful error message for validation failure',
      () async {
        // Arrange
        const invalidJson = '''
      {
        "gameId": "test",
        "version": "1.0",
        "intro": {
          "title": "Test",
          "educationalText": ["Test"],
          "scientificTitle": "Science",
          "scientificContent": "Content"
        },
        "categoryA": {
          "id": "a",
          "name": "A",
          "subtitle": "(A)",
          "colorStart": "#FF0000",
          "colorEnd": "#FF0000",
          "icon": "A",
          "educationalText": "A"
        },
        "categoryB": {
          "id": "b",
          "name": "B",
          "subtitle": "(B)",
          "colorStart": "#00FF00",
          "colorEnd": "#00FF00",
          "icon": "B",
          "educationalText": "B"
        },
        "scenarios": []
      }
      ''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (message) async {
              final String key = utf8.decode(message!.buffer.asUint8List());
              if (key == 'assets/configs/test.json') {
                return ByteData.sublistView(utf8.encode(invalidJson));
              }
              return null;
            });

        // Act & Assert
        try {
          await GameConfigLoader.load('test.json');
          fail('Should have thrown ConfigValidationError');
        } catch (e) {
          expect(e, isA<ConfigValidationError>());
          expect(e.toString(), contains('at least 10 scenarios'));
        }
      },
    );
  });
}
