import 'package:equatable/equatable.dart';
import '../../core/utils/app_logger.dart';

/// [Model] Configuration for intro screen content.
/// Purpose: Holds all text content displayed on the intro screen.
///
/// This model is loaded from JSON config files and provides the title,
/// educational text, and scientific background content for the intro screen.
///
/// Example:
/// ```dart
/// final config = IntroConfig.fromJson({
///   'title': 'Worry vs Fear',
///   'educationalText': ['Line 1', 'Line 2'],
///   'scientificTitle': 'Scientific Background',
///   'scientificContent': 'Research shows...',
/// });
/// ```
class IntroConfig extends Equatable {
  /// Creates an intro config.
  const IntroConfig({
    required this.title,
    required this.educationalText,
    required this.scientificTitle,
    required this.scientificContent,
  });

  /// Main title displayed at the top of the intro screen.
  /// Example: "Worry vs Fear", "Recognize Good Moments"
  final String title;

  /// Educational text paragraphs explaining the game concept.
  /// Each string is displayed as a separate paragraph.
  final List<String> educationalText;

  /// Title for the expandable scientific background section.
  /// Example: "Scientific Background", "📚 Scientific Background"
  final String scientificTitle;

  /// Content shown when scientific background is expanded.
  /// Contains research-based explanation of the game's concepts.
  final String scientificContent;

  /// Creates an IntroConfig from JSON data.
  ///
  /// Expects a map with keys: title, educationalText, scientificTitle, scientificContent.
  /// The educationalText should be a list of strings.
  factory IntroConfig.fromJson(Map<String, dynamic> json) {
    AppLogger.debug(
      'IntroConfig',
      'fromJson',
      () => 'Parsing intro config from JSON',
    );

    return IntroConfig(
      title: json['title'] as String,
      educationalText: (json['educationalText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scientificTitle: json['scientificTitle'] as String,
      scientificContent: json['scientificContent'] as String,
    );
  }

  /// Converts this IntroConfig to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'educationalText': educationalText,
      'scientificTitle': scientificTitle,
      'scientificContent': scientificContent,
    };
  }

  @override
  List<Object?> get props => [
    title,
    educationalText,
    scientificTitle,
    scientificContent,
  ];
}
