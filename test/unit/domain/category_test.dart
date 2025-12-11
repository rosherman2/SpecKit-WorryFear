import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';

void main() {
  group('CategoryRole', () {
    test('should have categoryA and categoryB constants', () {
      // Arrange & Act
      final roleA = CategoryRole.categoryA;
      final roleB = CategoryRole.categoryB;

      // Assert
      expect(roleA, isA<CategoryRoleA>());
      expect(roleB, isA<CategoryRoleB>());
    });

    test('should be comparable for equality', () {
      // Arrange
      const role1 = CategoryRole.categoryA;
      const role2 = CategoryRole.categoryA;
      const role3 = CategoryRole.categoryB;

      // Act & Assert
      expect(role1, equals(role2));
      expect(role1, isNot(equals(role3)));
    });

    test('should parse from string correctly', () {
      // Arrange & Act
      final roleA = CategoryRole.fromString('categoryA');
      final roleB = CategoryRole.fromString('categoryB');

      // Assert
      expect(roleA, equals(CategoryRole.categoryA));
      expect(roleB, equals(CategoryRole.categoryB));
    });

    test('should throw ArgumentError for invalid string', () {
      // Arrange & Act & Assert
      expect(
        () => CategoryRole.fromString('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should support exhaustive pattern matching', () {
      // Arrange - test both cases
      String getCategoryLabel(CategoryRole role) {
        return switch (role) {
          CategoryRoleA() => 'A',
          CategoryRoleB() => 'B',
        };
      }

      // Act & Assert
      expect(getCategoryLabel(CategoryRole.categoryA), 'A');
      expect(getCategoryLabel(CategoryRole.categoryB), 'B');
    });
  });
}
