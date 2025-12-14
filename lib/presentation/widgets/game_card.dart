import 'package:flutter/material.dart';

/// [StatelessWidget] A tappable card representing a game option.
/// Purpose: Display game information and handle tap navigation.
///
/// Used on the welcome screen to show available games. Each card displays:
/// - Game title
/// - Brief subtitle/description
/// - Emoji icon
///
/// Example:
/// ```dart
/// GameCard(
///   title: 'Savoring Choice',
///   subtitle: 'Notice and appreciate good moments',
///   iconEmoji: '✨',
///   onTap: () => Navigator.pushNamed(context, '/savoring/intro'),
/// )
/// ```
class GameCard extends StatelessWidget {
  /// Creates a game card.
  const GameCard({
    required this.title,
    required this.subtitle,
    required this.iconEmoji,
    required this.onTap,
    super.key,
  });

  /// The game's display name.
  /// Example: "Savoring Choice", "Good Moment vs Other Moment"
  final String title;

  /// Brief description of the game.
  /// Example: "Notice and appreciate good moments"
  final String subtitle;

  /// Emoji icon representing the game.
  /// Example: "✨", "🎯"
  final String iconEmoji;

  /// Callback when the card is tapped.
  /// Typically navigates to the game's intro screen.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji icon
              Text(iconEmoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),

              // Game title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Game subtitle
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
