import 'package:equatable/equatable.dart';
import '../../core/utils/app_logger.dart';
import 'category.dart';
import 'category_config.dart';
import 'intro_config.dart';
import 'scenario.dart';

/// [Model] Root configuration for a game variant.
/// Purpose: Holds all configuration data loaded from JSON config files.
///
/// This is the top-level model that contains everything needed to run
/// a specific game variant (Worry vs Fear, Good Moments, etc.).
///
/// Example:
/// ```dart
/// final config = GameConfig.fromJson(jsonData);
/// final categoryA = config.getCategory(CategoryRole.categoryA);
/// ```
class GameConfig extends Equatable {
  /// Creates a game config.
  const GameConfig({
    required this.gameId,
    required this.version,
    required this.intro,
    required this.categoryA,
    required this.categoryB,
    required this.scenarios,
  });

  /// Unique identifier for this game variant.
  /// Example: "worry-vs-fear", "good-moments-vs-other"
  final String gameId;

  /// Version of the config file.
  /// Used for tracking config changes over time.
  final String version;

  /// Configuration for the intro screen content.
  final IntroConfig intro;

  /// Configuration for category A (first category).
  /// Maps to CategoryRole.categoryA in game logic.
  final CategoryConfig categoryA;

  /// Configuration for category B (second category).
  /// Maps to CategoryRole.categoryB in game logic.
  final CategoryConfig categoryB;

  /// List of all available scenarios for this game variant.
  /// The game randomly selects 10 from this list per session.
  final List<ScenarioConfig> scenarios;

  /// Creates a GameConfig from JSON data.
  ///
  /// Parses the complete config file structure including intro, categories, and scenarios.
  factory GameConfig.fromJson(Map<String, dynamic> json) {
    AppLogger.info(
      'GameConfig',
      'fromJson',
      () => 'Loading game config: ${json['gameId']}',
    );

    return GameConfig(
      gameId: json['gameId'] as String,
      version: json['version'] as String,
      intro: IntroConfig.fromJson(json['intro'] as Map<String, dynamic>),
      categoryA: CategoryConfig.fromJson(
        json['categoryA'] as Map<String, dynamic>,
      ),
      categoryB: CategoryConfig.fromJson(
        json['categoryB'] as Map<String, dynamic>,
      ),
      scenarios: (json['scenarios'] as List<dynamic>)
          .map((e) => ScenarioConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Gets the category config for a given role.
  ///
  /// Maps CategoryRole to the corresponding CategoryConfig.
  /// - CategoryRole.categoryA → categoryA
  /// - CategoryRole.categoryB → categoryB
  CategoryConfig getCategory(CategoryRole role) {
    return switch (role) {
      CategoryRoleA() => categoryA,
      CategoryRoleB() => categoryB,
    };
  }

  @override
  List<Object?> get props => [
    gameId,
    version,
    intro,
    categoryA,
    categoryB,
    scenarios,
  ];
}

/// [Model] Configuration for a single scenario loaded from JSON.
/// Purpose: Intermediate model between JSON and the Scenario domain model.
///
/// This model is used during config loading and is converted to
/// Scenario objects for use in the game logic.
class ScenarioConfig extends Equatable {
  /// Creates a scenario config.
  const ScenarioConfig({
    required this.id,
    required this.text,
    required this.emoji,
    required this.correctCategory,
  });

  /// Unique identifier for this scenario.
  final String id;

  /// The scenario text presented to the user.
  final String text;

  /// Emoji icon representing the scenario.
  final String emoji;

  /// The correct category role for this scenario.
  final CategoryRole correctCategory;

  /// Creates a ScenarioConfig from JSON data.
  ///
  /// Parses the correctCategory string ("categoryA" or "categoryB")
  /// into a CategoryRole using CategoryRole.fromString().
  factory ScenarioConfig.fromJson(Map<String, dynamic> json) {
    return ScenarioConfig(
      id: json['id'] as String,
      text: json['text'] as String,
      emoji: json['emoji'] as String,
      correctCategory: CategoryRole.fromString(
        json['correctCategory'] as String,
      ),
    );
  }

  /// Converts this config to a Scenario domain model.
  ///
  /// Used when loading scenarios for a game session.
  Scenario toScenario() {
    return Scenario(
      id: id,
      text: text,
      emoji: emoji,
      correctCategory: correctCategory,
    );
  }

  @override
  List<Object?> get props => [id, text, emoji, correctCategory];
}
