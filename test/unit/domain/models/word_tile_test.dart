import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/word_tile.dart';

void main() {
  group('WordTile Model Tests', () {
    test('should create WordTile from valid JSON', () {
      // Arrange: Valid JSON data
      final json = {'text': 'enjoy this moment', 'isCorrect': true};

      // Act: Create WordTile from JSON
      final tile = WordTile.fromJson(json);

      // Assert: Fields are correctly parsed
      expect(tile.text, equals('enjoy this moment'));
      expect(tile.isCorrect, equals(true));
    });

    test('should create WordTile with isCorrect false', () {
      // Arrange: JSON with isCorrect false
      final json = {'text': 'keep moving', 'isCorrect': false};

      // Act: Create WordTile
      final tile = WordTile.fromJson(json);

      // Assert: isCorrect is false
      expect(tile.text, equals('keep moving'));
      expect(tile.isCorrect, equals(false));
    });

    test('should convert WordTile to JSON', () {
      // Arrange: Create WordTile
      final tile = WordTile(text: 'focus on whats wrong', isCorrect: false);

      // Act: Convert to JSON
      final json = tile.toJson();

      // Assert: JSON contains correct fields
      expect(json['text'], equals('focus on whats wrong'));
      expect(json['isCorrect'], equals(false));
    });

    test('should support equality comparison', () {
      // Arrange: Two identical tiles
      final tile1 = WordTile(text: 'test', isCorrect: true);
      final tile2 = WordTile(text: 'test', isCorrect: true);
      final tile3 = WordTile(text: 'test', isCorrect: false);

      // Assert: Equality works
      expect(tile1, equals(tile2));
      expect(tile1, isNot(equals(tile3)));
    });

    test('should throw on invalid JSON - missing text', () {
      // Arrange: Invalid JSON
      final json = {'isCorrect': true};

      // Act & Assert: Should throw
      expect(() => WordTile.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should throw on invalid JSON - missing isCorrect', () {
      // Arrange: Invalid JSON
      final json = {'text': 'test'};

      // Act & Assert: Should throw
      expect(() => WordTile.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should validate non-empty text', () {
      // Arrange: Create tile with empty text
      final json = {'text': '', 'isCorrect': true};

      //Act: Create tile
      final tile = WordTile.fromJson(json);

      // Assert: Text can be empty (validation happens at config level)
      expect(tile.text, equals(''));
    });
  });
}
