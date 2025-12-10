import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/animations/spring_animation.dart';

void main() {
  group('SpringAnimation', () {
    testWidgets('wraps child widget correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SpringAnimation(child: Text('Test Child'))),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('triggers spring animation on tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpringAnimation(
              onTap: () {
                tapped = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      // Tap the widget
      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('animates scale on tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SpringAnimation(child: Text('Spring Test'))),
        ),
      );

      // Tap to trigger animation
      await tester.tap(find.text('Spring Test'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 100)); // Mid-animation

      // Widget should still exist during animation
      expect(find.text('Spring Test'), findsOneWidget);
    });
  });
}
