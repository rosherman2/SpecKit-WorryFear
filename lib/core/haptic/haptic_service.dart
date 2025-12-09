/// [ServiceInterface] Abstract interface for haptic feedback.
/// Purpose: Defines contract for providing tactile feedback.
///
/// This interface allows for dependency injection and testing by providing
/// an abstraction over the actual haptic implementation. Implementations
/// should handle vibration feedback for user interactions.
///
/// Example:
/// ```dart
/// class MyWidget {
///   final HapticService hapticService;
///
///   void onDragStart() {
///     hapticService.lightImpact();
///   }
/// }
/// ```
abstract class HapticService {
  /// Provides light haptic feedback.
  ///
  /// Called when drag starts (FR-023).
  /// Should be a gentle vibration (~50ms).
  Future<void> lightImpact();

  /// Provides medium haptic feedback.
  ///
  /// Called on incorrect answer (FR-036).
  /// Should be a medium-strength pulse.
  Future<void> mediumImpact();
}
