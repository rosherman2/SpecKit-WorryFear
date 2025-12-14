import 'package:equatable/equatable.dart';
import 'sentence_stem.dart';
import 'savoring_intro_config.dart';
import '../../core/utils/app_logger.dart';

/// [Model] Root configuration for the Savoring Choice Game.
/// Purpose: Holds all game content loaded from savoring.json.
///
/// This is the top-level model containing:
/// - Game metadata (id, version)
/// - Intro screen content
/// - Character image paths
/// - All sentence stems for gameplay
///
/// Example:
/// ```dart
/// final config = SavoringConfig(
///   gameId: 'savoring-choice',
///   version: '1.0',
///   intro: SavoringIntroConfig(...),
///   character: CharacterConfig(...),
///   stems: [...10 sentence stems...],
/// );
/// ```
class SavoringConfig extends Equatable {
  /// Creates a savoring game config.
  const SavoringConfig({
    required this.gameId,
    required this.version,
    required this.intro,
    required this.character,
    required this.stems,
  });

  /// Unique identifier for this game.
  /// Example: "savoring-choice"
  final String gameId;

  /// Configuration version.
  /// Example: "1.0", "1.1"
  final String version;

  /// Intro screen configuration.
  /// Contains title, educational text, and scientific background.
  final SavoringIntroConfig intro;

  /// Character image paths.
  /// Contains asset paths for idle, affirming, and celebration states.
  final CharacterConfig character;

  /// All sentence stems for gameplay.
  /// Must contain at least 10 stems (game presents exactly 10).
  final List<SentenceStem> stems;

  /// Creates a SavoringConfig from JSON data.
  ///
  /// Expects a map with keys: gameId, version, intro, character, stems.
  factory SavoringConfig.fromJson(Map<String, dynamic> json) {
    AppLogger.info(
      'SavoringConfig',
      'fromJson',
      () => 'Loading savoring config: ${json['gameId']}',
    );

    return SavoringConfig(
      gameId: json['gameId'] as String,
      version: json['version'] as String,
      intro: SavoringIntroConfig.fromJson(
        json['intro'] as Map<String, dynamic>,
      ),
      character: CharacterConfig.fromJson(
        json['character'] as Map<String, dynamic>,
      ),
      stems: (json['stems'] as List<dynamic>)
          .map((stem) => SentenceStem.fromJson(stem as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this config to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'version': version,
      'intro': intro.toJson(),
      'character': character.toJson(),
      'stems': stems.map((stem) => stem.toJson()).toList(),
    };
  }

  /// Gets the first N stems for a session.
  /// Default is 10 stems per session as per spec.
  List<SentenceStem> getSessionStems({int count = 10}) {
    return stems.take(count).toList();
  }

  /// Checks if config has minimum required stems.
  bool get hasMinimumStems => stems.length >= 10;

  @override
  List<Object?> get props => [gameId, version, intro, character, stems];

  @override
  String toString() =>
      'SavoringConfig(id: $gameId, version: $version, stems: ${stems.length})';
}
