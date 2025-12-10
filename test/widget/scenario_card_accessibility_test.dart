import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/presentation/widgets/scenario_card.dart';

void main() {
  group('ScenarioCard Accessibility', () {
    final testScenario = Scenario(
      id: 'test-1',
      text: 'Test scenario',
      correctCategory: Category.fear,
      emoji: '🔥',
    );

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
            ),
          ),
        ),
      );

      // Card should render
      expect(find.text('Test scenario'), findsOneWidget);
    });

    testWidgets('has double-tap gesture detector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
            ),
          ),
        ),
      );

      // Should have GestureDetector for double-tap
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });

    testWidgets('maintains draggable functionality', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
            ),
          ),
        ),
      );

      // Should still be draggable
      expect(find.byType(Draggable<Scenario>), findsOneWidget);
    });
  });
}
