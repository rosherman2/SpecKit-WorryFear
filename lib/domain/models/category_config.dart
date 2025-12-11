import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';

/// [Model] Visual configuration for a category bottle.
/// Purpose: Holds all visual properties for rendering a category in the UI.
///
/// This model is separate from CategoryRole (game logic) and contains
/// only the visual/display properties loaded from JSON config.
///
/// Example:
/// ```dart
/// final config = CategoryConfig.fromJson({
///   'id': 'fear',
///   'name': 'Fear',
///   'subtitle': '(Immediate)',
///   'colorStart': '#FF6B35',
///   'colorEnd': '#E63946',
///   'icon': '🔥',
///   'educationalText': 'Fear is about immediate danger.',
/// });
/// ```
class CategoryConfig extends Equatable {
  /// Creates a category config.
  const CategoryConfig({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.colorStart,
    required this.colorEnd,
    required this.icon,
    required this.educationalText,
  });

  /// Unique identifier for this category.
  /// Example: "fear", "worry", "good-moment", "other-moment"
  final String id;

  /// Display name for the category.
  /// Example: "Fear", "Worry", "Good Moment"
  final String name;

  /// Subtitle text shown below the name.
  /// Example: "(Immediate)", "(Future)", "(Notice this)"
  final String subtitle;

  /// Gradient start color for the bottle.
  /// Parsed from hex string in JSON (e.g., "#FF6B35").
  final Color colorStart;

  /// Gradient end color for the bottle.
  /// Parsed from hex string in JSON (e.g., "#E63946").
  final Color colorEnd;

  /// Emoji or icon displayed on the bottle.
  /// Example: "🔥", "☁️", "✨", "➡️"
  final String icon;

  /// Educational text shown during auto-correction in review mode.
  /// Explains what this category represents.
  final String educationalText;

  /// Creates a CategoryConfig from JSON data.
  ///
  /// Parses hex color strings (e.g., "#FF6B35") into Flutter Color objects.
  factory CategoryConfig.fromJson(Map<String, dynamic> json) {
    AppLogger.debug(
      'CategoryConfig',
      'fromJson',
      () => 'Parsing category config: ${json['id']}',
    );

    return CategoryConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      colorStart: _parseHexColor(json['colorStart'] as String),
      colorEnd: _parseHexColor(json['colorEnd'] as String),
      icon: json['icon'] as String,
      educationalText: json['educationalText'] as String,
    );
  }

  /// Parses a hex color string (e.g., "#FF6B35") into a Color object.
  ///
  /// Supports both 6-digit (#RRGGBB) and 8-digit (#AARRGGBB) formats.
  /// If no alpha is specified, defaults to fully opaque (0xFF).
  static Color _parseHexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7) {
      // #RRGGBB -> add alpha
      buffer.write('FF');
      buffer.write(hexString.substring(1));
    } else if (hexString.length == 9) {
      // #AARRGGBB -> use as is
      buffer.write(hexString.substring(1));
    } else {
      throw ArgumentError('Invalid hex color format: $hexString');
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Creates a linear gradient from the start and end colors.
  ///
  /// Used for rendering the bottle with a top-to-bottom gradient effect.
  LinearGradient createGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colorStart, colorEnd],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    subtitle,
    colorStart,
    colorEnd,
    icon,
    educationalText,
  ];
}
