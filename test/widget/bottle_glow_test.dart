import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_glow_effect.dart';

void main() {
  group('BottleGlowEffect', () {
    testWidgets('displays child widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(child: BottleGlowEffect(child: Text('Test Child'))),
            ),
          ),
        );

        // Should render the child
        expect(find.text('Test Child'), findsOneWidget);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('accepts onStart callback', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: BottleGlowEffect(
                  onStart: () {
                    // Callback provided
                  },
                  child: const Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Widget should render successfully with callback
        expect(find.text('Test'), findsOneWidget);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('accepts onComplete callback', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: BottleGlowEffect(
                  onComplete: () {
                    // Callback provided
                  },
                  child: const Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Widget should render successfully with callback
        expect(find.text('Test'), findsOneWidget);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('wraps child correctly', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: BottleGlowEffect(child: Text('Child Widget'))),
          ),
        );

        // Child should be present
        expect(find.text('Child Widget'), findsOneWidget);

        // Wait a bit for timers to be scheduled
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });
  });
}
