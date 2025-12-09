import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';

void main() {
  group('Category', () {
    test('should have fear and worry values', () {
      // Arrange & Act
      final values = Category.values;

      // Assert
      expect(values, contains(Category.fear));
      expect(values, contains(Category.worry));
      expect(values.length, 2);
    });

    test('should have correct string representation', () {
      // Arrange & Act & Assert
      expect(Category.fear.toString(), 'Category.fear');
      expect(Category.worry.toString(), 'Category.worry');
    });

    test('should be comparable for equality', () {
      // Arrange
      const category1 = Category.fear;
      const category2 = Category.fear;
      const category3 = Category.worry;

      // Act & Assert
      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });
  });
}
