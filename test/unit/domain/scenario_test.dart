import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';

void main() {
  group('Scenario', () {
    test('should create scenario with all required fields', () {
      // Arrange & Act
      const scenario = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      // Assert
      expect(scenario.id, 'fear-1');
      expect(scenario.text, 'A car just swerved toward me');
      expect(scenario.emoji, '🚗');
      expect(scenario.correctCategory, Category.fear);
    });

    test('should support equality comparison with Equatable', () {
      // Arrange
      const scenario1 = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      const scenario2 = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      const scenario3 = Scenario(
        id: 'worry-1',
        text: 'Different text',
        emoji: '💔',
        correctCategory: Category.worry,
      );

      // Act & Assert
      expect(scenario1, equals(scenario2));
      expect(scenario1, isNot(equals(scenario3)));
    });

    test('should support copyWith for immutability', () {
      // Arrange
      const original = Scenario(
        id: 'fear-1',
        text: 'Original text',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      // Act
      final modified = original.copyWith(text: 'Modified text');

      // Assert
      expect(modified.id, original.id);
      expect(modified.text, 'Modified text');
      expect(modified.emoji, original.emoji);
      expect(modified.correctCategory, original.correctCategory);
      expect(modified, isNot(equals(original)));
    });

    test('should include all fields in props for equality', () {
      // Arrange
      const scenario1 = Scenario(
        id: 'fear-1',
        text: 'Text',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      const scenario2 = Scenario(
        id: 'fear-2', // Different ID
        text: 'Text',
        emoji: '🚗',
        correctCategory: Category.fear,
      );

      // Act & Assert
      expect(scenario1, isNot(equals(scenario2)));
    });
  });
}
