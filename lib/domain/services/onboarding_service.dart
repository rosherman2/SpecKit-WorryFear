import 'package:shared_preferences/shared_preferences.dart';

/// [Service] Manages first-time user onboarding state.
/// Purpose: Detects first-time users and tracks onboarding completion.
///
/// Uses SharedPreferences to persist onboarding state across app sessions.
/// First-time users see hints (drag icon, bottle glow) on their first scenario.
///
/// Example:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// final service = OnboardingService(prefs);
///
/// if (await service.isFirstTime()) {
///   // Show onboarding hints
///   await service.markOnboardingComplete();
/// }
/// ```
class OnboardingService {
  /// Creates an onboarding service with the given preferences instance.
  OnboardingService(this._prefs);

  /// SharedPreferences instance for persistence.
  final SharedPreferences _prefs;

  /// Key for storing onboarding completion status.
  static const String _onboardingCompleteKey = 'onboarding_complete';

  /// Checks if this is the user's first time using the app.
  ///
  /// Returns true if onboarding has never been completed, false otherwise.
  /// This check is performed asynchronously as it reads from storage.
  Future<bool> isFirstTime() async {
    final isComplete = _prefs.getBool(_onboardingCompleteKey) ?? false;
    print(
      '🔍 OnboardingService.isFirstTime: isComplete=$isComplete, returning ${!isComplete}',
    );
    return !isComplete;
  }

  /// Marks onboarding as complete.
  ///
  /// Persists the completion status so future calls to [isFirstTime]
  /// will return false. Safe to call multiple times.
  Future<void> markOnboardingComplete() async {
    print(
      '💾 OnboardingService.markOnboardingComplete: Setting $_onboardingCompleteKey = true',
    );
    await _prefs.setBool(_onboardingCompleteKey, true);
    final verify = _prefs.getBool(_onboardingCompleteKey);
    print(
      '✅ OnboardingService.markOnboardingComplete: Verified value = $verify',
    );
  }

  /// Resets onboarding state (for testing purposes).
  ///
  /// Clears the completion flag so [isFirstTime] will return true again.
  /// Typically only used in tests or debug builds.
  Future<void> reset() async {
    await _prefs.remove(_onboardingCompleteKey);
  }
}
