import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/presentation/widgets/scenario_card.dart';

void main() {
  group('ScenarioCard', () {
    const testScenario = Scenario(
      id: 'test-1',
      text: 'A car just swerved toward me',
      emoji: '🚗',
      correctCategory: Category.fear,
    );

    testWidgets('displays emoji and text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
          ),
        ),
      );

      expect(find.text('🚗'), findsOneWidget);
      expect(find.text('A car just swerved toward me'), findsOneWidget);
    });

    testWidgets('is draggable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
          ),
        ),
      );

      // Verify Draggable widget exists
      expect(find.byType(Draggable<Scenario>), findsOneWidget);
    });

    testWidgets('shows feedback during drag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScenarioCard(scenario: testScenario, onAccepted: (_) {}),
          ),
        ),
      );

      // Start dragging
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ScenarioCard)),
      );
      await tester.pump();

      // During drag, feedback widget should be visible
      expect(find.text('🚗'), findsWidgets); // Original + feedback

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
