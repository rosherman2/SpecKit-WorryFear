import 'package:flutter/material.dart';

/// [Constants] Color palette for the Worry vs Fear game.
/// Purpose: Centralized color definitions following the visual design requirements.
///
/// Colors are organized by category (Fear, Worry, Feedback, UI) for easy reference.
/// All colors follow the spec requirements for warm/cool tones and emotional associations.
class AppColors {
  // ============================================================
  // Fear Colors (Orange-Red Gradients)
  // ============================================================

  /// Primary Fear color - warm orange-red for immediate danger association.
  /// Used for Fear bottle gradient start.
  static const Color fearPrimary = Color(0xFFFF6B35);

  /// Secondary Fear color - deeper red-orange for gradient end.
  /// Creates depth in Fear bottle 3D effect.
  static const Color fearSecondary = Color(0xFFE63946);

  /// Fear icon color - bright orange for fire icon visibility.
  static const Color fearIcon = Color(0xFFFF8C42);

  // ============================================================
  // Worry Colors (Blue Gradients)
  // ============================================================

  /// Primary Worry color - cool blue for contemplative future-thinking.
  /// Used for Worry bottle gradient start.
  static const Color worryPrimary = Color(0xFF4A90E2);

  /// Secondary Worry color - deeper blue for gradient end.
  /// Creates depth in Worry bottle 3D effect.
  static const Color worrySecondary = Color(0xFF2C5F8D);

  /// Worry icon color - light blue for cloud icon visibility.
  static const Color worryIcon = Color(0xFF6BB6FF);

  // ============================================================
  // Feedback Colors
  // ============================================================

  /// Success color - green for correct answers.
  /// Clear but not alarming, positive reinforcement.
  static const Color success = Color(0xFF4CAF50);

  /// Error color - red for incorrect answers.
  /// Clear but not alarming, gentle correction.
  static const Color error = Color(0xFFE57373);

  /// Gold color for progress bar fill and glow effects.
  /// Warm, rewarding color for achievement.
  static const Color gold = Color(0xFFFFD700);

  // ============================================================
  // UI Background Colors
  // ============================================================

  /// Main background - off-white for calm, clean feel.
  /// Not harsh pure white, easier on eyes.
  static const Color background = Color(0xFFF5F5F5);

  /// Card background - pure white for scenario cards.
  /// Provides contrast against off-white background.
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Light gray for unfilled progress bar and subtle UI elements.
  static const Color lightGray = Color(0xFFE0E0E0);

  // ============================================================
  // Text Colors
  // ============================================================

  /// Primary text color - dark gray (not harsh black).
  /// Easier to read than pure black, follows spec requirement.
  static const Color textPrimary = Color(0xFF333333);

  /// Secondary text color - medium gray for subtitles.
  static const Color textSecondary = Color(0xFF757575);

  /// White text for buttons and labels on dark backgrounds.
  static const Color textLight = Color(0xFFFFFFFF);

  // ============================================================
  // Effect Colors
  // ============================================================

  /// Soft gold for glow effects and sparkles.
  /// Used in success animations and bottle hover states.
  static const Color glowGold = Color(0xFFFFF8DC);

  /// White for sparkle effects and highlights.
  static const Color sparkleWhite = Color(0xFFFFFFFF);

  /// Light blue for secondary glow effects.
  static const Color glowBlue = Color(0xFFB3E5FC);

  // ============================================================
  // Gradient Helpers
  // ============================================================

  /// Fear bottle gradient (top to bottom).
  /// Creates 3D depth effect with warm orange-red tones.
  static const LinearGradient fearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [fearPrimary, fearSecondary],
  );

  /// Worry bottle gradient (top to bottom).
  /// Creates 3D depth effect with cool blue tones.
  static const LinearGradient worryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [worryPrimary, worrySecondary],
  );

  /// Glass overlay gradient for 3D bottle effect.
  /// Semi-transparent white creates glass highlight.
  static const LinearGradient glassOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF), // 20% opacity white
      Color(0x00FFFFFF), // Transparent
    ],
  );
}
