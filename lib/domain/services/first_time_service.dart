import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/app_logger.dart';

/// Service for tracking first-time user experiences.
/// Purpose: Persist first-time flags to show one-time hints/glows.
///
/// Uses SharedPreferences to store boolean flags that persist across app sessions.
///
/// Example:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// final service = FirstTimeService(prefs);
/// if (await service.isFirstTimeSavoringGame()) {
///   // Show glow on correct tile
///   await service.markSavoringGameCompleted();
/// }
/// ```
class FirstTimeService {
  /// Creates a first-time service.
  FirstTimeService(this._prefs);

  final SharedPreferences _prefs;

  /// SharedPreferences key for savoring game first-time flag.
  static const String _savoringGameKey = 'first_time_savoring_game_complete';

  /// Checks if this is the user's first time playing the savoring game.
  ///
  /// Returns `true` if the user has never completed Round 1 of savoring game.
  /// Returns `false` if they have played before.
  Future<bool> isFirstTimeSavoringGame() async {
    final isComplete = _prefs.getBool(_savoringGameKey) ?? false;
    AppLogger.debug(
      'FirstTimeService',
      'isFirstTimeSavoringGame',
      () => 'isComplete=$isComplete, returning ${!isComplete}',
    );
    return !isComplete;
  }

  /// Marks the savoring game as completed (no longer first time).
  ///
  /// Should be called after the user completes Round 1 of the savoring game.
  Future<void> markSavoringGameCompleted() async {
    AppLogger.info(
      'FirstTimeService',
      'markSavoringGameCompleted',
      () => 'Setting savoring game complete',
    );
    await _prefs.setBool(_savoringGameKey, true);

    // Verify the write was successful
    final verify = _prefs.getBool(_savoringGameKey);
    AppLogger.debug(
      'FirstTimeService',
      'markSavoringGameCompleted',
      () => 'Verified value = $verify',
    );
  }

  /// Resets savoring game first-time state (for testing purposes).
  ///
  /// Clears the completion flag so [isFirstTimeSavoringGame] will return true again.
  /// Typically only used in tests or debug builds.
  Future<void> reset() async {
    AppLogger.debug(
      'FirstTimeService',
      'reset',
      () => 'Clearing savoring game first-time state',
    );
    await _prefs.remove(_savoringGameKey);
  }
}
