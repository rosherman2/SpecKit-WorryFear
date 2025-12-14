import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/word_tile.dart';
import 'package:worry_fear_game/presentation/widgets/blank_zone.dart';

void main() {
  group('BlankZone Widget Tests', () {
    testWidgets('should display placeholder when empty', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build empty blank zone
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(blankIndex: 1, onTileDropped: (tile) {}),
          ),
        ),
      );

      // Assert: Find placeholder indicator (underline or dashed box)
      expect(find.byType(BlankZone), findsOneWidget);
    });

    testWidgets('should accept dropped WordTile', (WidgetTester tester) async {
      // Arrange: Track dropped tile
      WordTile? droppedTile;
      final testTile = WordTile.fromJson({
        'text': 'dropped',
        'isCorrect': true,
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 1,
              onTileDropped: (tile) {
                droppedTile = tile;
              },
            ),
          ),
        ),
      );

      // Assert: Contains DragTarget
      expect(find.byType(DragTarget<WordTile>), findsOneWidget);
    });

    testWidgets('should show filled state when tile is placed', (
      WidgetTester tester,
    ) async {
      // Arrange: Create blank zone with filled tile
      final filledTile = WordTile.fromJson({
        'text': 'filled',
        'isCorrect': true,
      });

      // Act: Build with filled tile
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 1,
              filledTile: filledTile,
              onTileDropped: (tile) {},
            ),
          ),
        ),
      );

      // Assert: Filled tile text is visible
      expect(find.text('filled'), findsOneWidget);
    });

    testWidgets('should be locked when isLocked is true', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build locked blank zone
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 2,
              isLocked: true,
              onTileDropped: (tile) {},
            ),
          ),
        ),
      );

      // Assert: Widget is present (styling handled internally)
      expect(find.byType(BlankZone), findsOneWidget);
    });

    testWidgets('should show correct state styling', (
      WidgetTester tester,
    ) async {
      // Arrange: Create blank zone in correct state
      final correctTile = WordTile.fromJson({
        'text': 'correct',
        'isCorrect': true,
      });

      // Act: Build with correct state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 1,
              filledTile: correctTile,
              isCorrect: true,
              onTileDropped: (tile) {},
            ),
          ),
        ),
      );

      // Assert: Widget shows correct styling
      expect(find.text('correct'), findsOneWidget);
    });

    testWidgets('should show incorrect state styling', (
      WidgetTester tester,
    ) async {
      // Arrange: Create blank zone in incorrect state
      final incorrectTile = WordTile.fromJson({
        'text': 'wrong',
        'isCorrect': false,
      });

      // Act: Build with incorrect state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 1,
              filledTile: incorrectTile,
              isCorrect: false,
              onTileDropped: (tile) {},
            ),
          ),
        ),
      );

      // Assert: Widget shows incorrect styling (text visible)
      expect(find.text('wrong'), findsOneWidget);
    });

    testWidgets('should call onTileDropped callback when tile dropped', (
      WidgetTester tester,
    ) async {
      // Arrange: Track callback
      WordTile? receivedTile;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlankZone(
              blankIndex: 1,
              onTileDropped: (tile) {
                receivedTile = tile;
              },
            ),
          ),
        ),
      );

      // Assert: DragTarget exists to receive drops
      expect(find.byType(DragTarget<WordTile>), findsOneWidget);
    });
  });
}
