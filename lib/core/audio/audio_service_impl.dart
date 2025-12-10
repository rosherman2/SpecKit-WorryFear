import 'package:audioplayers/audioplayers.dart';
import '../utils/app_logger.dart';
import 'audio_service.dart';

/// [Service] Implementation of AudioService using audioplayers package.
/// Purpose: Plays game sound effects for success, error, and celebration.
///
/// This implementation uses the audioplayers package to play sound files.
/// Sounds are loaded from assets and played with appropriate volume settings.
/// Gracefully handles silent mode per spec requirement (FR-079).
///
/// Example:
/// ```dart
/// final audioService = AudioServiceImpl();
/// await audioService.playSuccess();
/// ```
class AudioServiceImpl implements AudioService {
  /// Audio player instance for sound effects.
  final AudioPlayer _player = AudioPlayer();

  // ============================================================
  // Public API Methods
  // ============================================================

  @override
  Future<void> playSuccess() async {
    AppLogger.debug(
      'AudioServiceImpl',
      'playSuccess',
      () => 'Playing success sound',
    );

    try {
      await _player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      // FR-079: Gracefully handle audio failures (silent mode, missing files, etc.)
      AppLogger.warning(
        'AudioServiceImpl',
        'playSuccess',
        () => 'Failed to play success sound: $e',
      );
    }
  }

  @override
  Future<void> playError() async {
    AppLogger.debug(
      'AudioServiceImpl',
      'playError',
      () => 'Playing error sound',
    );

    try {
      await _player.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      // FR-079: Gracefully handle audio failures
      AppLogger.warning(
        'AudioServiceImpl',
        'playError',
        () => 'Failed to play error sound: $e',
      );
    }
  }

  @override
  Future<void> playCelebration() async {
    AppLogger.debug(
      'AudioServiceImpl',
      'playCelebration',
      () => 'Playing celebration sound',
    );

    try {
      await _player.play(AssetSource('sounds/celebration.mp3'));
    } catch (e) {
      // FR-079: Gracefully handle audio failures
      AppLogger.warning(
        'AudioServiceImpl',
        'playCelebration',
        () => 'Failed to play celebration sound: $e',
      );
    }
  }

  // ============================================================
  // Lifecycle Management
  // ============================================================

  @override
  void dispose() {
    AppLogger.debug(
      'AudioServiceImpl',
      'dispose',
      () => 'Disposing audio player',
    );
    _player.dispose();
  }
}
