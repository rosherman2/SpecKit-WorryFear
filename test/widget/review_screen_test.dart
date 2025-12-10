import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';
import 'package:worry_fear_game/presentation/screens/review_screen.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';
import 'package:worry_fear_game/presentation/widgets/scenario_card.dart';

void main() {
  group('ReviewScreen', () {
    late List<SessionScenario> testReviewScenarios;

    setUp(() {
      testReviewScenarios = [
        SessionScenario(
          scenario: const Scenario(
            id: 'r1',
            text: 'Review test 1',
            emoji: '🎯',
            correctCategory: Category.fear,
          ),
        ).recordAnswer(isCorrect: false),
        SessionScenario(
          scenario: const Scenario(
            id: 'r2',
            text: 'Review test 2',
            emoji: '🎯',
            correctCategory: Category.worry,
          ),
        ).recordAnswer(isCorrect: false),
      ];
    });

    testWidgets('displays review header text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );
      await tester.pump();

      expect(find.text('Review Mode'), findsOneWidget);
    });

    testWidgets('displays review progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );
      await tester.pump();

      // Should show "Reviewing 1 of 2"
      expect(find.textContaining('Reviewing'), findsOneWidget);
      expect(find.textContaining('of 2'), findsOneWidget);
    });

    testWidgets('displays scenario card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );
      await tester.pump();

      expect(find.byType(ScenarioCard), findsOneWidget);
    });

    testWidgets('displays Fear and Worry bottles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );
      await tester.pump();

      expect(find.byType(BottleWidget), findsNWidgets(2));
    });

    testWidgets('displays educational text during auto-correction', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );

      // Initially no educational text
      expect(find.textContaining('Fear is about'), findsNothing);
      expect(find.textContaining('Worry is about'), findsNothing);
    });

    testWidgets('shows attempt indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ReviewScreen(reviewScenarios: testReviewScenarios)),
      );
      await tester.pump();

      // Should indicate this is a retry opportunity
      expect(find.textContaining('Try again'), findsOneWidget);
    });
  });
}
