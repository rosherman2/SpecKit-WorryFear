/// [Constants] Animation timing constants for the Worry vs Fear game.
/// Purpose: Centralized duration definitions following spec requirements (FR-067 to FR-073).
///
/// Durations are categorized by speed for consistent animation feel across the app.
/// All values chosen to feel delightful without delaying the user.
class AnimationDurations {
  // ============================================================
  // Fast Actions (0.1-0.2 seconds)
  // ============================================================

  /// Button press animation duration.
  /// Quick feedback for tap interactions.
  static const Duration buttonPress = Duration(milliseconds: 150);

  /// Card lift animation when drag starts.
  /// Instant visual feedback for touch.
  static const Duration cardLift = Duration(milliseconds: 100);

  /// Haptic feedback delay.
  /// Immediate tactile response.
  static const Duration hapticDelay = Duration(milliseconds: 50);

  // ============================================================
  // Medium Actions (0.3-0.6 seconds)
  // ============================================================

  /// Card snap to bottle animation.
  /// Spring motion feels natural and satisfying.
  static const Duration cardSnap = Duration(milliseconds: 400);

  /// Card bounce back on incorrect answer.
  /// Elastic motion provides clear feedback.
  static const Duration cardBounce = Duration(milliseconds: 500);

  /// Card shake animation (3 shakes).
  /// Quick side-to-side motion.
  static const Duration cardShake = Duration(milliseconds: 300);

  /// Red border fade on error.
  /// Brief visual indicator.
  static const Duration errorBorderFade = Duration(milliseconds: 500);

  /// Success animation duration (high-five, thumbs up, checkmark).
  /// Playful but not too long.
  static const Duration successAnimationShort = Duration(milliseconds: 600);

  /// Star burst animation duration.
  /// Slightly longer for visual impact.
  static const Duration successAnimationMedium = Duration(milliseconds: 800);

  /// "+2" points text fly-up and fade.
  /// Smooth upward motion with fade.
  static const Duration pointsAnimation = Duration(seconds: 1);

  /// Confetti animation duration.
  /// Longest success animation for celebration.
  static const Duration successAnimationLong = Duration(seconds: 1);

  /// Bottle glow animation when card hovers.
  /// Smooth fade in/out.
  static const Duration bottleGlow = Duration(milliseconds: 300);

  /// Bottle scale animation when card hovers.
  /// Subtle grow effect.
  static const Duration bottleScale = Duration(milliseconds: 300);

  /// Progress bar fill animation.
  /// Smooth advancement after correct answer.
  static const Duration progressBarFill = Duration(milliseconds: 400);

  // ============================================================
  // Slow Actions (1-2 seconds)
  // ============================================================

  /// Screen transition duration.
  /// Smooth fade between screens.
  static const Duration screenTransition = Duration(milliseconds: 1200);

  /// Bottle fade-in on intro screen load.
  /// Graceful entrance animation.
  static const Duration bottleFadeIn = Duration(milliseconds: 1500);

  /// Expandable section animation.
  /// Smooth expand/collapse for Scientific Background.
  static const Duration expandableSection = Duration(milliseconds: 1000);

  /// Auto-correction animation in review mode.
  /// Card moves to correct bottle after 1.5 seconds.
  static const Duration autoCorrection = Duration(milliseconds: 1500);

  /// Educational text display duration in review mode.
  /// Wait 3 seconds for user to read explanation.
  static const Duration educationalTextDisplay = Duration(seconds: 3);

  // ============================================================
  // Continuous Animations (2-3 seconds loop)
  // ============================================================

  /// Bottle floating animation cycle.
  /// Gentle up and down motion, repeats continuously.
  static const Duration bottleFloat = Duration(milliseconds: 2500);

  /// Sparkle effect cycle.
  /// Occasional sparkles on bottles.
  static const Duration sparkleCycle = Duration(seconds: 3);

  /// Bottle glow pulse in onboarding (first-time hint).
  /// Gold pulsing effect for 2-3 seconds.
  static const Duration onboardingGlowPulse = Duration(milliseconds: 2500);

  // ============================================================
  // Timing Delays
  // ============================================================

  /// Delay before showing next scenario card.
  /// Brief pause after success animation completes.
  static const Duration nextScenarioDelay = Duration(milliseconds: 500);

  /// Delay before onboarding hint appears.
  /// Wait 2-3 seconds if user hasn't interacted.
  static const Duration onboardingHintDelay = Duration(milliseconds: 2500);

  /// Drag hint icon display duration.
  /// Shows for 1 second then fades.
  static const Duration dragHintDisplay = Duration(seconds: 1);

  /// Onboarding glow display duration.
  /// Glows for 2-3 seconds then fades.
  static const Duration onboardingGlowDisplay = Duration(milliseconds: 2500);
}
