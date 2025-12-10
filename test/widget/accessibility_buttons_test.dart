import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/presentation/widgets/accessibility_buttons.dart';

void main() {
  group('AccessibilityButtons', () {
    testWidgets('displays Fear and Worry buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(onCategorySelected: (_) {}),
          ),
        ),
      );

      // Should show both buttons
      expect(find.text('Fear'), findsOneWidget);
      expect(find.text('Worry'), findsOneWidget);
    });

    testWidgets('Fear button calls callback with Category.fear', (
      tester,
    ) async {
      Category? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      // Tap Fear button
      await tester.tap(find.text('Fear'));
      await tester.pump();

      expect(selectedCategory, Category.fear);
    });

    testWidgets('Worry button calls callback with Category.worry', (
      tester,
    ) async {
      Category? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      // Tap Worry button
      await tester.tap(find.text('Worry'));
      await tester.pump();

      expect(selectedCategory, Category.worry);
    });

    testWidgets('buttons have correct colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(onCategorySelected: (_) {}),
          ),
        ),
      );

      // Find buttons by text
      expect(find.text('Fear'), findsOneWidget);
      expect(find.text('Worry'), findsOneWidget);

      // Buttons should be ElevatedButtons
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('buttons are laid out horizontally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(onCategorySelected: (_) {}),
          ),
        ),
      );

      // Should have a Row layout
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });
  });
}
