import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';

void main() {
  group('Scenario', () {
    test('should create scenario with all required fields', () {
      // Arrange & Act
      final scenario = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
      );

      // Assert
      expect(scenario.id, 'fear-1');
      expect(scenario.text, 'A car just swerved toward me');
      expect(scenario.emoji, '🚗');
      expect(scenario.correctCategory, isA<CategoryRoleA>());
    });

    test('should support equality comparison with Equatable', () {
      // Arrange
      final scenario1 = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
      );

      final scenario2 = Scenario(
        id: 'fear-1',
        text: 'A car just swerved toward me',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
      );

      final scenario3 = Scenario(
        id: 'worry-1',
        text: 'Different text',
        emoji: '💔',
        correctCategory: const CategoryRoleB(),
      );

      // Act & Assert
      expect(scenario1, equals(scenario2));
      expect(scenario1, isNot(equals(scenario3)));
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final original = Scenario(
        id: 'fear-1',
        text: 'Original text',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
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
      final scenario1 = Scenario(
        id: 'fear-1',
        text: 'Text',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
      );

      final scenario2 = Scenario(
        id: 'fear-2', // Different ID
        text: 'Text',
        emoji: '🚗',
        correctCategory: const CategoryRoleA(),
      );

      // Act & Assert
      expect(scenario1, isNot(equals(scenario2)));
    });

    test('should work with CategoryRoleB', () {
      // Arrange & Act
      final scenario = Scenario(
        id: 'worry-1',
        text: 'Worrying about future',
        emoji: '😰',
        correctCategory: const CategoryRoleB(),
      );

      // Assert
      expect(scenario.correctCategory, isA<CategoryRoleB>());
      expect(scenario.correctCategory, equals(CategoryRole.categoryB));
    });
  });
}
