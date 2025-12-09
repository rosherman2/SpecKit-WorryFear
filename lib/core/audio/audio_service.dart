/// [ServiceInterface] Abstract interface for audio playback.
/// Purpose: Defines contract for playing game sound effects.
///
/// This interface allows for dependency injection and testing by providing
/// an abstraction over the actual audio implementation. Implementations
/// should handle sound playback for success, error, and celebration events.
///
/// Example:
/// ```dart
/// class MyWidget {
///   final AudioService audioService;
///
///   void onCorrectAnswer() {
///     audioService.playSuccess();
///   }
/// }
/// ```
abstract class AudioService {
  /// Plays the success sound effect.
  ///
  /// Called when user answers correctly.
  /// Sound should be a positive chime/ding (FR-074).
  /// Duration: ~0.5 seconds.
  Future<void> playSuccess();

  /// Plays the error sound effect.
  ///
  /// Called when user answers incorrectly.
  /// Sound should be gentle buzz, not harsh (FR-075).
  /// Duration: ~0.3 seconds.
  Future<void> playError();

  /// Plays the celebration sound effect.
  ///
  /// Called on session completion.
  /// Sound should be upbeat and rewarding (FR-076).
  /// Duration: 1-2 seconds.
  Future<void> playCelebration();

  /// Disposes of audio resources.
  ///
  /// Should be called when the service is no longer needed
  /// to free up system resources.
  void dispose();
}
