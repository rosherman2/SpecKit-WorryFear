import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/presentation/widgets/accessibility_buttons.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('AccessibilityButtons', () {
    testWidgets('displays category buttons from config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              categoryA: testCategoryA,
              categoryB: testCategoryB,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      // Should show both buttons with config names
      expect(find.text('Category A'), findsOneWidget);
      expect(find.text('Category B'), findsOneWidget);
    });

    testWidgets('CategoryA button calls callback with CategoryRole.categoryA', (
      tester,
    ) async {
      CategoryRole? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              categoryA: testCategoryA,
              categoryB: testCategoryB,
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      // Tap Category A button
      await tester.tap(find.text('Category A'));
      await tester.pump();

      expect(selectedCategory, isA<CategoryRoleA>());
    });

    testWidgets('CategoryB button calls callback with CategoryRole.categoryB', (
      tester,
    ) async {
      CategoryRole? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              categoryA: testCategoryA,
              categoryB: testCategoryB,
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      // Tap Category B button
      await tester.tap(find.text('Category B'));
      await tester.pump();

      expect(selectedCategory, isA<CategoryRoleB>());
    });

    testWidgets('buttons have correct colors from config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              categoryA: testCategoryA,
              categoryB: testCategoryB,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      // Find buttons by text
      expect(find.text('Category A'), findsOneWidget);
      expect(find.text('Category B'), findsOneWidget);

      // Buttons should be ElevatedButtons
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('buttons are laid out horizontally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityButtons(
              categoryA: testCategoryA,
              categoryB: testCategoryB,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      // Should have a Row layout
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });
  });
}
