import 'package:flutter/material.dart';
import '../../domain/models/sentence_stem.dart';
import '../../domain/models/word_tile.dart';
import 'blank_zone.dart';

/// [StatelessWidget] Displays a sentence stem with inline blank zones.
/// Purpose: Render sentence template with interactive blanks for word drops.
///
/// Parses templateText like "It is okay to {1}" and replaces {1}, {2}
/// with BlankZone widgets inline with the text.
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
    // Parse template text and build inline widgets
    final parts = _parseTemplate(stem.templateText);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 12,
      children: parts,
    );
  }

  /// Parses the template text and returns a list of widgets.
  /// Text parts become Text widgets, {1} and {2} become BlankZones.
  List<Widget> _parseTemplate(String template) {
    final widgets = <Widget>[];
    final pattern = RegExp(r'\{(\d+)\}');

    var lastEnd = 0;
    for (final match in pattern.allMatches(template)) {
      // Add text before this blank
      if (match.start > lastEnd) {
        final textPart = template.substring(lastEnd, match.start);
        widgets.add(_buildTextPart(textPart));
      }

      // Add blank zone
      final blankIndex = int.parse(match.group(1)!);
      widgets.add(_buildBlankZone(blankIndex));

      lastEnd = match.end;
    }

    // Add remaining text after last blank
    if (lastEnd < template.length) {
      final textPart = template.substring(lastEnd);
      widgets.add(_buildTextPart(textPart));
    }

    return widgets;
  }

  Widget _buildTextPart(String text) {
    return Text(
      text.trim(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    );
  }

  Widget _buildBlankZone(int index) {
    return BlankZone(
      blankIndex: index,
      filledTile: filledTiles[index],
      isLocked: lockedBlanks[index] ?? false,
      isCorrect: blankStates[index],
      onTileDropped: (tile) => onTileDropped(index, tile),
    );
  }
}
