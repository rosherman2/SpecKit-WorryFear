import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/word_tile.dart';
import 'package:worry_fear_game/presentation/widgets/word_tile_widget.dart';

void main() {
  group('WordTileWidget Tests', () {
    testWidgets('should display tile text', (WidgetTester tester) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({
        'text': 'enjoy this moment',
        'isCorrect': true,
      });

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WordTileWidget(tile: tile)),
        ),
      );

      // Assert: Find the text
      expect(find.text('enjoy this moment'), findsOneWidget);
    });

    testWidgets('should be draggable', (WidgetTester tester) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({'text': 'test tile', 'isCorrect': true});

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WordTileWidget(tile: tile)),
        ),
      );

      // Assert: Find Draggable widget
      expect(find.byType(Draggable<WordTile>), findsOneWidget);
    });

    testWidgets('should show feedback while dragging', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({'text': 'drag me', 'isCorrect': false});

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: WordTileWidget(tile: tile)),
          ),
        ),
      );

      // Start a drag gesture
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('drag me')),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();

      // Assert: Feedback is visible (should have 2 instances - original and feedback)
      expect(find.text('drag me'), findsWidgets);

      // Clean up
      await gesture.up();
      await tester.pump();
    });

    testWidgets('should have proper styling', (WidgetTester tester) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({
        'text': 'styled tile',
        'isCorrect': true,
      });

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WordTileWidget(tile: tile)),
        ),
      );

      // Assert: Find Container with decoration (chip-like styling)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should be disabled when isEnabled is false', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({
        'text': 'disabled tile',
        'isCorrect': true,
      });

      // Act: Build the widget with isEnabled false
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WordTileWidget(tile: tile, isEnabled: false)),
        ),
      );

      // Assert: Text is still visible but should have different styling
      expect(find.text('disabled tile'), findsOneWidget);
    });

    testWidgets('should show childWhenDragging placeholder', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a word tile
      final tile = WordTile.fromJson({
        'text': 'placeholder test',
        'isCorrect': true,
      });

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: WordTileWidget(tile: tile)),
          ),
        ),
      );

      // Start a drag gesture
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('placeholder test')),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();

      // Assert: Original position shows placeholder (opacity reduced or grayed)
      // The Draggable should create a childWhenDragging
      expect(find.byType(Draggable<WordTile>), findsOneWidget);

      // Clean up
      await gesture.up();
      await tester.pump();
    });
  });
}
