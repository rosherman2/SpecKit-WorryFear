import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/utils/app_logger.dart';
import '../models/game_config.dart';

/// [Service] Loads and validates game configuration from JSON files.
/// Purpose: Centralized config loading with validation and error handling.
///
/// This service loads JSON config files from the assets folder,
/// parses them into GameConfig objects, and validates the structure
/// to ensure all required data is present.
///
/// Example:
/// ```dart
/// final config = await GameConfigLoader.load('good-moments.json');
/// ```
class GameConfigLoader {
  /// Currently active config file name.
  /// Change this constant to switch between game variants.
  static const String activeConfig = 'good-moments.json';

  /// Loads a game config from the assets folder.
  ///
  /// Reads the JSON file, parses it, validates the structure,
  /// and returns a GameConfig object.
  ///
  /// Throws [ConfigValidationError] if validation fails.
  /// Throws [FormatException] if JSON parsing fails.
  static Future<GameConfig> load(String configFileName) async {
    AppLogger.info(
      'GameConfigLoader',
      'load',
      () => 'Loading config file: $configFileName',
    );

    try {
      // Load JSON string from assets
      final jsonString = await rootBundle.loadString(
        'assets/configs/$configFileName',
      );

      AppLogger.debug(
        'GameConfigLoader',
        'load',
        () => 'Loaded ${jsonString.length} bytes from $configFileName',
      );

      // Parse JSON
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Create config from JSON
      final config = GameConfig.fromJson(json);

      // Validate config
      _validate(config, configFileName);

      AppLogger.info(
        'GameConfigLoader',
        'load',
        () => 'Successfully loaded config: ${config.gameId} v${config.version}',
      );

      return config;
    } on FormatException catch (e) {
      AppLogger.error(
        'GameConfigLoader',
        'load',
        () => 'JSON parsing failed for $configFileName: ${e.message}',
      );
      rethrow;
    } on ConfigValidationError {
      rethrow;
    } catch (e) {
      AppLogger.error(
        'GameConfigLoader',
        'load',
        () => 'Failed to load config $configFileName: $e',
      );
      rethrow;
    }
  }

  /// Validates a game config to ensure it has all required data.
  ///
  /// Checks:
  /// - At least 10 scenarios (minimum for a game session)
  /// - CategoryA and CategoryB are defined
  /// - Intro config is present
  ///
  /// Throws [ConfigValidationError] if validation fails.
  static void _validate(GameConfig config, String fileName) {
    AppLogger.debug(
      'GameConfigLoader',
      '_validate',
      () => 'Validating config: ${config.gameId}',
    );

    // Check minimum scenario count
    if (config.scenarios.length < 10) {
      final error = ConfigValidationError(
        'Config validation failed for $fileName: '
        'Need at least 10 scenarios, found ${config.scenarios.length}',
      );
      AppLogger.error('GameConfigLoader', '_validate', () => error.message);
      throw error;
    }

    // Validate categories exist (already guaranteed by GameConfig.fromJson)
    // Validate intro exists (already guaranteed by GameConfig.fromJson)

    AppLogger.debug(
      'GameConfigLoader',
      '_validate',
      () => 'Config validation passed: ${config.scenarios.length} scenarios',
    );
  }
}

/// [Exception] Thrown when config validation fails.
/// Purpose: Provides clear error messages for config issues.
class ConfigValidationError implements Exception {
  /// Creates a config validation error.
  const ConfigValidationError(this.message);

  /// Error message describing what validation failed.
  final String message;

  @override
  String toString() => 'ConfigValidationError: $message';
}
