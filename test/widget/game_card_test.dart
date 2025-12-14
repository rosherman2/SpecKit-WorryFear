import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/game_card.dart';

void main() {
  group('GameCard Widget Tests', () {
    testWidgets('should display game title and subtitle', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a GameCard with title and subtitle
      const title = 'Test Game';
      const subtitle = 'A test game description';

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: title,
              subtitle: subtitle,
              iconEmoji: '🎮',
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert: Find the title and subtitle
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('should display icon emoji', (WidgetTester tester) async {
      // Arrange: Create a GameCard with an emoji
      const emoji = '🎯';

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: 'Game',
              subtitle: 'Description',
              iconEmoji: emoji,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert: Find the emoji
      expect(find.text(emoji), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange: Track if callback was called
      bool wasTapped = false;
      void onTapCallback() {
        wasTapped = true;
      }

      // Act: Build the widget and tap it
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: 'Game',
              subtitle: 'Description',
              iconEmoji: '🎮',
              onTap: onTapCallback,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GameCard));
      await tester.pump();

      // Assert: Callback was called
      expect(wasTapped, isTrue);
    });

    testWidgets('should be a tappable card widget', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: 'Game',
              subtitle: 'Description',
              iconEmoji: '🎮',
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert: Find InkWell or GestureDetector (tappable widget)
      expect(
        find.descendant(
          of: find.byType(GameCard),
          matching: find.byType(InkWell),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have consistent styling with app theme', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: 'Game',
              subtitle: 'Description',
              iconEmoji: '🎮',
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert: Find Card widget (material design component)
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display all content in column layout', (
      WidgetTester tester,
    ) async {
      // Arrange: Create card with all fields
      const title = 'My Game';
      const subtitle = 'Game subtitle';
      const emoji = '🎲';

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameCard(
              title: title,
              subtitle: subtitle,
              iconEmoji: emoji,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert: All elements present
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
      expect(find.text(emoji), findsOneWidget);
    });
  });
}
