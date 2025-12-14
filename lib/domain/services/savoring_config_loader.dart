import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/savoring_config.dart';
import '../../core/utils/app_logger.dart';

/// [Service] Loads and validates savoring game configuration from JSON.
/// Purpose: Centralized config loading with validation for the savoring game.
///
/// This service:
/// - Loads savoring.json from assets
/// - Parses JSON into SavoringConfig model
/// - Validates config structure and content
/// - Provides error handling for malformed configs
///
/// Example:
/// ```dart
/// final config = await SavoringConfigLoader.load('assets/configs/savoring.json');
/// print('Loaded ${config.stems.length} sentence stems');
/// ```
class SavoringConfigLoader {
  /// Loads savoring game configuration from the specified asset path.
  ///
  /// Throws [Exception] if:
  /// - File not found
  /// - JSON parsing fails
  /// - Config validation fails
  ///
  /// Returns validated [SavoringConfig].
  static Future<SavoringConfig> load(String configPath) async {
    AppLogger.info(
      'SavoringConfigLoader',
      'load',
      () => 'Loading savoring config from: $configPath',
    );

    try {
      // Load JSON file from assets
      final jsonString = await rootBundle.loadString(configPath);
      AppLogger.debug(
        'SavoringConfigLoader',
        'load',
        () => 'Config file loaded, parsing JSON...',
      );

      // Parse JSON
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Create config from JSON
      final config = SavoringConfig.fromJson(jsonData);

      // Validate config
      _validate(config);

      AppLogger.info(
        'SavoringConfigLoader',
        'load',
        () =>
            'Config loaded successfully: ${config.gameId} v${config.version} with ${config.stems.length} stems',
      );

      return config;
    } on FormatException catch (e) {
      AppLogger.error(
        'SavoringConfigLoader',
        'load',
        () => 'Failed to parse JSON: ${e.message}',
      );
      throw Exception('Invalid JSON in config file: ${e.message}');
    } catch (e) {
      AppLogger.error(
        'SavoringConfigLoader',
        'load',
        () => 'Unexpected error loading config: $e',
      );
      throw Exception('Failed to load config: $e');
    }
  }

  /// Validates the loaded configuration.
  ///
  /// Throws [Exception] if validation fails.
  static void _validate(SavoringConfig config) {
    AppLogger.debug(
      'SavoringConfigLoader',
      '_validate',
      () => 'Validating config: ${config.gameId}',
    );

    // Validate minimum stems
    if (config.stems.length < 10) {
      throw Exception(
        'Config must have at least 10 stems, found: ${config.stems.length}',
      );
    }

    // Validate each stem
    for (final stem in config.stems) {
      // Check blank count matches blanks list
      if (stem.blanks.length != stem.blankCount) {
        throw Exception(
          'Stem ${stem.id}: blank count mismatch - '
          'blankCount=${stem.blankCount} but blanks.length=${stem.blanks.length}',
        );
      }

      // Check template text has correct markers
      if (stem.blankCount >= 1 && !stem.templateText.contains('{1}')) {
        throw Exception('Stem ${stem.id}: templateText missing {1} marker');
      }
      if (stem.blankCount == 2 && !stem.templateText.contains('{2}')) {
        throw Exception(
          'Stem ${stem.id}: templateText missing {2} marker for double-blank',
        );
      }

      // Validate each blank
      for (final blank in stem.blanks) {
        // Check tile count
        if (blank.tiles.length != 3) {
          throw Exception(
            'Stem ${stem.id}, Blank ${blank.index}: '
            'must have exactly 3 tiles, found ${blank.tiles.length}',
          );
        }

        // Check exactly one correct tile
        final correctCount = blank.tiles.where((t) => t.isCorrect).length;
        if (correctCount != 1) {
          throw Exception(
            'Stem ${stem.id}, Blank ${blank.index}: '
            'must have exactly 1 correct tile, found $correctCount',
          );
        }
      }
    }

    AppLogger.debug(
      'SavoringConfigLoader',
      '_validate',
      () => 'Config validation passed',
    );
  }
}
