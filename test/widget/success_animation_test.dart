import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/success_animation.dart';

void main() {
  group('SuccessAnimation', () {
    testWidgets('displays an animated widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SuccessAnimation())),
      );

      // Should render without error
      expect(find.byType(SuccessAnimation), findsOneWidget);
    });

    testWidgets('animation completes and triggers onComplete callback', (
      tester,
    ) async {
      var callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessAnimation(
              onComplete: () {
                callbackTriggered = true;
              },
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      expect(callbackTriggered, true);
    });

    testWidgets('renders one of the success animation types', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SuccessAnimation())),
      );

      // Should have animated content (Text widget with emoji or similar)
      await tester.pump(const Duration(milliseconds: 100));

      // Verify some content is displayed
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });
  });
}
