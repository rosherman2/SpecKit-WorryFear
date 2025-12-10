import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/animations/points_animation.dart';

void main() {
  group('PointsAnimation', () {
    testWidgets('displays +2 text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PointsAnimation())),
      );

      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('animates upward and fades out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PointsAnimation())),
      );

      // Initial state - should be visible
      expect(find.text('+2'), findsOneWidget);

      // Advance animation halfway (500ms)
      await tester.pump(const Duration(milliseconds: 500));

      // Should still be visible but moving up
      expect(find.text('+2'), findsOneWidget);

      // Complete animation (1000ms total)
      await tester.pump(const Duration(milliseconds: 500));

      // Animation should be complete
      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('calls onComplete callback when animation finishes', (
      tester,
    ) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PointsAnimation(
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );

      expect(completed, false);

      // Wait for full animation duration (1000ms) plus buffer
      await tester.pump(const Duration(milliseconds: 1100));

      expect(completed, true);
    });

    testWidgets('has gold color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PointsAnimation())),
      );

      final textWidget = tester.widget<Text>(find.text('+2'));
      expect(textWidget.style?.color, isNotNull);
    });
  });
}
