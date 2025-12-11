import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';
import 'package:worry_fear_game/presentation/screens/review_screen.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';
import 'package:worry_fear_game/presentation/widgets/scenario_card.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ReviewScreen', () {
    late List<SessionScenario> testReviewScenarios;

    setUp(() {
      testReviewScenarios = [
        SessionScenario(
          scenario: Scenario(
            id: 'r1',
            text: 'Review test 1',
            emoji: '🎯',
            correctCategory: const CategoryRoleA(),
          ),
        ).recordAnswer(isCorrect: false),
        SessionScenario(
          scenario: Scenario(
            id: 'r2',
            text: 'Review test 2',
            emoji: '🎯',
            correctCategory: const CategoryRoleB(),
          ),
        ).recordAnswer(isCorrect: false),
      ];
    });

    testWidgets('displays review header text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Review Mode'), findsOneWidget);
    });

    testWidgets('displays review progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );
      await tester.pump();

      // Should show "Reviewing 1 of 2"
      expect(find.textContaining('Reviewing'), findsOneWidget);
      expect(find.textContaining('of 2'), findsOneWidget);
    });

    testWidgets('displays scenario card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ScenarioCard), findsOneWidget);
    });

    testWidgets('displays category bottles from config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BottleWidget), findsNWidgets(2));
    });

    testWidgets('initially no educational text visible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );

      // Initially no educational text
      expect(find.textContaining('test educational text'), findsNothing);
    });

    testWidgets('shows attempt indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewScreen(
            reviewScenarios: testReviewScenarios,
            gameConfig: testGameConfig,
          ),
        ),
      );
      await tester.pump();

      // Should indicate this is a retry opportunity
      expect(find.textContaining('Try again'), findsOneWidget);
    });
  });
}
