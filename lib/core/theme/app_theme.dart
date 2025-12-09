import 'package:flutter/material.dart';
import 'app_colors.dart';

/// [Theme] Application theme configuration for the Worry vs Fear game.
/// Purpose: Centralized theme with typography, colors, and Material Design settings.
///
/// Provides a consistent visual design across the app following spec requirements:
/// - Clean, modern sans-serif typography (FR-088 to FR-092)
/// - Color scheme using AppColors
/// - Material Design 3 components
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   home: MyHomePage(),
/// )
/// ```
class AppTheme {
  /// Light theme for the application.
  ///
  /// Uses off-white background (FR-083), dark gray text (FR-084),
  /// and clean sans-serif typography (FR-088).
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.worryPrimary,
        secondary: AppColors.fearPrimary,
        surface: AppColors.background,
        error: AppColors.error,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Typography - clean, modern sans-serif
      textTheme: const TextTheme(
        // Headings
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        // Body text
        bodyLarge: TextStyle(fontSize: 18, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 14, color: AppColors.textSecondary),

        // Labels
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.textLight,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.lightGray,
      ),
    );
  }
}
