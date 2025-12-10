import 'package:vibration/vibration.dart';
import '../utils/app_logger.dart';
import 'haptic_service.dart';

/// [Service] Implementation of HapticService using vibration package.
/// Purpose: Provides tactile feedback for user interactions.
///
/// This implementation uses the vibration package to provide haptic feedback.
/// Gracefully handles devices without haptic support per spec assumption.
///
/// Example:
/// ```dart
/// final hapticService = HapticServiceImpl();
/// await hapticService.lightImpact();
/// ```
class HapticServiceImpl implements HapticService {
  // ============================================================
  // Public API Methods
  // ============================================================

  @override
  Future<void> lightImpact() async {
    AppLogger.debug(
      'HapticServiceImpl',
      'lightImpact',
      () => 'Triggering light haptic',
    );

    try {
      // Check if device has vibration capability
      final hasVibrator = await Vibration.hasVibrator();

      if (hasVibrator == true) {
        // FR-023: Light vibration on drag start (~50ms)
        await Vibration.vibrate(duration: 50);
      }
    } catch (e) {
      // Graceful degradation on devices without haptic support
      AppLogger.warning(
        'HapticServiceImpl',
        'lightImpact',
        () => 'Failed to provide light impact: $e',
      );
    }
  }

  @override
  Future<void> mediumImpact() async {
    AppLogger.debug(
      'HapticServiceImpl',
      'mediumImpact',
      () => 'Triggering medium haptic',
    );

    try {
      // Check if device has vibration capability
      final hasVibrator = await Vibration.hasVibrator();

      if (hasVibrator == true) {
        // FR-036: Medium vibration on incorrect answer
        await Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Graceful degradation on devices without haptic support
      AppLogger.warning(
        'HapticServiceImpl',
        'mediumImpact',
        () => 'Failed to provide medium impact: $e',
      );
    }
  }
}
