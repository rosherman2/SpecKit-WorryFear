import 'package:equatable/equatable.dart';

/// [Model] Configuration for the savoring game intro screen.
/// Purpose: Holds all text content displayed on the intro screen.
///
/// Example:
/// ```dart
/// final intro = SavoringIntroConfig(
///   title: 'Savoring Choice',
///   conceptText: ['Good moments happen all the time...'],
///   benefitText: 'The interpretation you choose shapes how you feel.',
///   scientificTitle: '📚 Scientific Background',
///   scientificContent: 'Research shows that savoring...',
/// );
/// ```
class SavoringIntroConfig extends Equatable {
  /// Creates an intro config.
  const SavoringIntroConfig({
    required this.title,
    required this.conceptText,
    required this.benefitText,
    required this.scientificTitle,
    required this.scientificContent,
  });

  /// Screen title displayed at the top.
  /// Example: "Savoring Choice"
  final String title;

  /// Educational text paragraphs explaining the concept.
  /// Each string is displayed as a separate paragraph.
  final List<String> conceptText;

  /// Benefit statement text.
  /// Example: "The interpretation you choose shapes how you feel and what you do."
  final String benefitText;

  /// Title for the expandable scientific background section.
  /// Example: "📚 Scientific Background"
  final String scientificTitle;

  /// Content shown when scientific background is expanded.
  /// Contains research-based explanation.
  final String scientificContent;

  /// Creates a SavoringIntroConfig from JSON data.
  factory SavoringIntroConfig.fromJson(Map<String, dynamic> json) {
    return SavoringIntroConfig(
      title: json['title'] as String,
      conceptText: (json['conceptText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      benefitText: json['benefitText'] as String,
      scientificTitle: json['scientificTitle'] as String,
      scientificContent: json['scientificContent'] as String,
    );
  }

  /// Converts this config to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'conceptText': conceptText,
      'benefitText': benefitText,
      'scientificTitle': scientificTitle,
      'scientificContent': scientificContent,
    };
  }

  @override
  List<Object?> get props => [
    title,
    conceptText,
    benefitText,
    scientificTitle,
    scientificContent,
  ];
}

/// [Model] Character image paths for different states.
/// Purpose: Holds asset paths for character images.
///
/// Example:
/// ```dart
/// final character = CharacterConfig(
///   idleImage: 'assets/images/savoring/character_idle.png',
///   affirmingImage: 'assets/images/savoring/character_affirming.png',
///   celebrationImage: 'assets/images/savoring/character_celebration.png',
/// );
/// ```
class CharacterConfig extends Equatable {
  /// Creates a character config.
  const CharacterConfig({
    required this.idleImage,
    required this.affirmingImage,
    required this.celebrationImage,
  });

  /// Asset path for idle state (during gameplay).
  final String idleImage;

  /// Asset path for correct answer affirmation.
  final String affirmingImage;

  /// Asset path for game completion celebration.
  final String celebrationImage;

  /// Creates a CharacterConfig from JSON data.
  factory CharacterConfig.fromJson(Map<String, dynamic> json) {
    return CharacterConfig(
      idleImage: json['idleImage'] as String,
      affirmingImage: json['affirmingImage'] as String,
      celebrationImage: json['celebrationImage'] as String,
    );
  }

  /// Converts this config to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'idleImage': idleImage,
      'affirmingImage': affirmingImage,
      'celebrationImage': celebrationImage,
    };
  }

  @override
  List<Object?> get props => [idleImage, affirmingImage, celebrationImage];
}
