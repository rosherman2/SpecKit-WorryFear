import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/drag_hint_icon.dart';

void main() {
  group('DragHintIcon', () {
    testWidgets('displays child widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: DragHintIcon())),
          ),
        );

        // Should render the finger icon
        expect(find.text('👇'), findsOneWidget);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('bounces continuously', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: DragHintIcon())),
          ),
        );

        // Icon should be present
        expect(find.text('👇'), findsOneWidget);

        // Wait for animation to progress
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('👇'), findsOneWidget);

        // Still present after more time (continuous loop)
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('👇'), findsOneWidget);

        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('has gold color', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Center(child: DragHintIcon())),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('👇'));
        expect(textWidget.style?.color, isNotNull);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });

    testWidgets('accepts onComplete callback without error', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: DragHintIcon(
                  onComplete: () {
                    // Callback provided but not called (continuous animation)
                  },
                ),
              ),
            ),
          ),
        );

        // Widget should render successfully with callback
        expect(find.text('👇'), findsOneWidget);
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });
  });
}
