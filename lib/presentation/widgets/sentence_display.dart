import 'package:flutter/material.dart';
import '../../domain/models/sentence_stem.dart';
import '../../domain/models/word_tile.dart';
import 'blank_zone.dart';

/// [StatelessWidget] Displays a sentence stem with inline blank zones.
/// Purpose: Render sentence template with interactive blanks for word drops.
///
/// Parses templateText like "It is okay to {1}" and replaces {1}, {2}
/// with BlankZone widgets inline with the text using RichText.
///
/// Example:
/// ```dart
/// SentenceDisplay(
///   stem: currentStem,
///   filledTiles: {1: tile},
///   blankStates: {1: true},
///   onTileDropped: (index, tile) => cubit.dropTile(index, tile),
/// )
/// ```
class SentenceDisplay extends StatelessWidget {
  /// Creates a sentence display.
  const SentenceDisplay({
    required this.stem,
    required this.onTileDropped,
    this.filledTiles = const {},
    this.blankStates = const {},
    this.lockedBlanks = const {},
    super.key,
  });

  /// The sentence stem to display.
  final SentenceStem stem;

  /// Callback when a tile is dropped on a blank.
  final void Function(int blankIndex, WordTile tile) onTileDropped;

  /// Map of blank index to filled tile.
  final Map<int, WordTile> filledTiles;

  /// Map of blank index to correct state (true = correct, false = incorrect).
  final Map<int, bool> blankStates;

  /// Map of blank index to locked state.
  final Map<int, bool> lockedBlanks;

  @override
  Widget build(BuildContext context) {
    // Parse template text and build inline spans
    final spans = _parseTemplate(stem.templateText);

    return Text.rich(TextSpan(children: spans), textAlign: TextAlign.center);
  }

  /// Parses the template text and returns a list of InlineSpans.
  /// Text parts become TextSpans, {1} and {2} become WidgetSpans with BlankZones.
  List<InlineSpan> _parseTemplate(String template) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\{(\d+)\}');

    var lastEnd = 0;
    for (final match in pattern.allMatches(template)) {
      // Add text before this blank
      if (match.start > lastEnd) {
        final textPart = template.substring(lastEnd, match.start);
        spans.add(_buildTextSpan(textPart));
      }

      // Add blank zone as widget span
      final blankIndex = int.parse(match.group(1)!);
      spans.add(_buildBlankSpan(blankIndex));

      lastEnd = match.end;
    }

    // Add remaining text after last blank
    if (lastEnd < template.length) {
      final textPart = template.substring(lastEnd);
      spans.add(_buildTextSpan(textPart));
    }

    return spans;
  }

  TextSpan _buildTextSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 2.5, // Increased for more vertical spacing
        color: Colors.black87,
      ),
    );
  }

  WidgetSpan _buildBlankSpan(int index) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: BlankZone(
          blankIndex: index,
          filledTile: filledTiles[index],
          isLocked: lockedBlanks[index] ?? false,
          isCorrect: blankStates[index],
          onTileDropped: (tile) => onTileDropped(index, tile),
        ),
      ),
    );
  }
}
