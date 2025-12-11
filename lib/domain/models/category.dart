import '../../core/utils/app_logger.dart';

/// [Sealed Class] Represents the role of a category in the A vs B game.
/// Purpose: Type-safe category identification for game logic (correct answer checking).
///
/// This sealed class replaces the hardcoded fear/worry enum to support
/// config-driven game variants. Uses categoryA and categoryB as generic roles
/// that can represent any pair of categories (Fear/Worry, Good Moment/Other, etc.).
///
/// The sealed class ensures exhaustive pattern matching in switch statements,
/// providing compile-time safety when handling category logic.
///
/// Example:
/// ```dart
/// final role = CategoryRole.categoryA;
/// final result = switch (role) {
///   CategoryRoleA() => 'Category A selected',
///   CategoryRoleB() => 'Category B selected',
/// };
/// ```
sealed class CategoryRole {
  /// Creates a category role.
  const CategoryRole();

  /// Category A role (first category in config).
  /// Maps to config.categoryA (e.g., Fear, Good Moment).
  static const categoryA = CategoryRoleA();

  /// Category B role (second category in config).
  /// Maps to config.categoryB (e.g., Worry, Other Moment).
  static const categoryB = CategoryRoleB();

  /// Parses a category role from a string identifier.
  ///
  /// Used when loading scenarios from JSON config where the correct
  /// category is specified as "categoryA" or "categoryB".
  ///
  /// Throws [ArgumentError] if the value is not "categoryA" or "categoryB".
  static CategoryRole fromString(String value) {
    AppLogger.debug(
      'CategoryRole',
      'fromString',
      () => 'Parsing category role from string: $value',
    );

    return switch (value) {
      'categoryA' => categoryA,
      'categoryB' => categoryB,
      _ => throw ArgumentError('Invalid category role: $value'),
    };
  }
}

/// [Sealed Subclass] Represents Category A role.
/// Purpose: Type-safe identifier for the first category in any game variant.
class CategoryRoleA extends CategoryRole {
  /// Creates Category A role.
  const CategoryRoleA();
}

/// [Sealed Subclass] Represents Category B role.
/// Purpose: Type-safe identifier for the second category in any game variant.
class CategoryRoleB extends CategoryRole {
  /// Creates Category B role.
  const CategoryRoleB();
}
