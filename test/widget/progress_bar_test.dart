import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/progress_bar.dart';

void main() {
  group('ProgressBar', () {
    testWidgets('renders with correct progress value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ProgressBar(current: 3, total: 10)),
        ),
      );

      // Verify widget renders
      expect(find.byType(ProgressBar), findsOneWidget);
    });

    testWidgets('displays scenario counter text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ProgressBar(current: 5, total: 10)),
        ),
      );

      // Verify counter text
      expect(find.text('Scenario 5 of 10'), findsOneWidget);
    });

    testWidgets('calculates correct progress percentage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ProgressBar(current: 7, total: 10)),
        ),
      );

      // Find the LinearProgressIndicator widget
      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      // Verify progress value (7/10 = 0.7)
      expect(progressIndicator.value, closeTo(0.7, 0.01));
    });

    testWidgets('handles edge cases correctly', (tester) async {
      // Test first scenario
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ProgressBar(current: 1, total: 10)),
        ),
      );

      expect(find.text('Scenario 1 of 10'), findsOneWidget);

      // Test last scenario
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ProgressBar(current: 10, total: 10)),
        ),
      );
      await tester.pump();

      expect(find.text('Scenario 10 of 10'), findsOneWidget);
    });
  });
}
