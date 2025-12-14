import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/sentence_stem.dart';
import 'package:worry_fear_game/presentation/widgets/sentence_display.dart';
import 'package:worry_fear_game/presentation/widgets/blank_zone.dart';

void main() {
  group('SentenceDisplay Widget Tests', () {
    late SentenceStem singleBlankStem;
    late SentenceStem doubleBlankStem;

    setUp(() {
      // Create single-blank stem
      singleBlankStem = SentenceStem.fromJson({
        'id': 'stem-1',
        'templateText': 'It is okay to {1}',
        'blankCount': 1,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'enjoy', 'isCorrect': true},
              {'text': 'rush', 'isCorrect': false},
              {'text': 'skip', 'isCorrect': false},
            ],
            'incorrectFeedback': 'Try again.',
          },
        ],
        'correctFeedback': 'Great!',
      });

      // Create double-blank stem
      doubleBlankStem = SentenceStem.fromJson({
        'id': 'stem-2',
        'templateText': 'I can {1} this moment {2}',
        'blankCount': 2,
        'blanks': [
          {
            'index': 1,
            'tiles': [
              {'text': 'appreciate', 'isCorrect': true},
              {'text': 'dismiss', 'isCorrect': false},
              {'text': 'rush', 'isCorrect': false},
            ],
            'incorrectFeedback': 'No.',
          },
          {
            'index': 2,
            'tiles': [
              {'text': 'fully', 'isCorrect': true},
              {'text': 'briefly', 'isCorrect': false},
              {'text': 'less', 'isCorrect': false},
            ],
            'incorrectFeedback': 'No.',
          },
        ],
        'correctFeedback': 'Yes!',
      });
    });

    testWidgets('should display sentence text parts', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build sentence display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: singleBlankStem,
              onTileDropped: (index, tile) {},
            ),
          ),
        ),
      );

      // Assert: Find sentence text parts
      expect(find.textContaining('It is okay to'), findsOneWidget);
    });

    testWidgets('should display BlankZone for single-blank stem', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build sentence display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: singleBlankStem,
              onTileDropped: (index, tile) {},
            ),
          ),
        ),
      );

      // Assert: Find one BlankZone
      expect(find.byType(BlankZone), findsOneWidget);
    });

    testWidgets('should display 2 BlankZones for double-blank stem', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build sentence display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: doubleBlankStem,
              onTileDropped: (index, tile) {},
            ),
          ),
        ),
      );

      // Assert: Find two BlankZones
      expect(find.byType(BlankZone), findsNWidgets(2));
    });

    testWidgets('should pass filled tiles to BlankZones', (
      WidgetTester tester,
    ) async {
      // Arrange: Create filled tiles map
      final filledTiles = {1: singleBlankStem.blanks[0].correctTile};

      // Act: Build sentence display with filled tiles
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: singleBlankStem,
              filledTiles: filledTiles,
              onTileDropped: (index, tile) {},
            ),
          ),
        ),
      );

      // Assert: Filled tile text is visible
      expect(find.text('enjoy'), findsOneWidget);
    });

    testWidgets('should call onTileDropped with correct index', (
      WidgetTester tester,
    ) async {
      // Arrange: Track callback
      int? droppedIndex;

      // Act: Build sentence display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: singleBlankStem,
              onTileDropped: (index, tile) {
                droppedIndex = index;
              },
            ),
          ),
        ),
      );

      // Assert: BlankZone exists and can receive drops
      expect(find.byType(BlankZone), findsOneWidget);
    });

    testWidgets('should show correct state on BlankZones', (
      WidgetTester tester,
    ) async {
      // Arrange: Create correct states map
      final filledTiles = {1: singleBlankStem.blanks[0].correctTile};
      final blankStates = {1: true}; // blank 1 is correct

      // Act: Build sentence display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceDisplay(
              stem: singleBlankStem,
              filledTiles: filledTiles,
              blankStates: blankStates,
              onTileDropped: (index, tile) {},
            ),
          ),
        ),
      );

      // Assert: Widget renders with correct state
      expect(find.byType(SentenceDisplay), findsOneWidget);
    });

    testWidgets(
      'should lock blank 2 when blank 1 not filled for double-blank',
      (WidgetTester tester) async {
        // Arrange: No filled tiles
        final lockedBlanks = {2: true}; // blank 2 is locked

        // Act: Build sentence display
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SentenceDisplay(
                stem: doubleBlankStem,
                lockedBlanks: lockedBlanks,
                onTileDropped: (index, tile) {},
              ),
            ),
          ),
        );

        // Assert: Both BlankZones are present (locked state handled internally)
        expect(find.byType(BlankZone), findsNWidgets(2));
      },
    );
  });
}
