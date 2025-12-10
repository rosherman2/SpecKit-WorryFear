import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';
import 'package:worry_fear_game/presentation/screens/completion_screen.dart';

void main() {
  group('CompletionScreen', () {
    late Session testSession;

    setUp(() {
      // Create a test session with mixed results
      final scenarios = [
        SessionScenario(
          scenario: const Scenario(
            id: '1',
            text: 'Test 1',
            emoji: '🎯',
            correctCategory: Category.fear,
          ),
        ).recordAnswer(isCorrect: true),
        SessionScenario(
          scenario: const Scenario(
            id: '2',
            text: 'Test 2',
            emoji: '🎯',
            correctCategory: Category.worry,
          ),
        ).recordAnswer(isCorrect: false),
        SessionScenario(
          scenario: const Scenario(
            id: '3',
            text: 'Test 3',
            emoji: '🎯',
            correctCategory: Category.fear,
          ),
        ).recordAnswer(isCorrect: true),
      ];
      // 2 correct answers = 4 points
      testSession = Session(scenarios: scenarios, score: 4);
    });

    testWidgets('displays session complete title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      expect(find.text('Session Complete!'), findsOneWidget);
    });

    testWidgets('displays correct score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      // 2 correct out of 3 = 4 points
      expect(find.text('4'), findsOneWidget); // Main score number
      expect(find.text('points'), findsOneWidget);
    });

    testWidgets('displays score percentage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      // 2/3 = 67% (approximately)
      expect(find.textContaining('67%'), findsOneWidget);
    });

    testWidgets('displays review count when there are mistakes', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      expect(find.textContaining('1 scenario'), findsOneWidget);
      expect(find.textContaining('review'), findsOneWidget);
    });

    testWidgets('shows Finish button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      expect(find.text('Finish'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    });

    testWidgets('shows Review Mistakes button when there are errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: testSession)),
      );

      // Should have Review Mistakes button since testSession has 1 incorrect
      expect(find.text('Review Mistakes'), findsOneWidget);
    });

    testWidgets('does not show Review Mistakes button for perfect score', (
      tester,
    ) async {
      // Create perfect session
      final perfectScenarios = [
        SessionScenario(
          scenario: const Scenario(
            id: '1',
            text: 'Test 1',
            emoji: '🎯',
            correctCategory: Category.fear,
          ),
        ).recordAnswer(isCorrect: true),
        SessionScenario(
          scenario: const Scenario(
            id: '2',
            text: 'Test 2',
            emoji: '🎯',
            correctCategory: Category.worry,
          ),
        ).recordAnswer(isCorrect: true),
      ];
      final perfectSession = Session(scenarios: perfectScenarios, score: 4);

      await tester.pumpWidget(
        MaterialApp(home: CompletionScreen(session: perfectSession)),
      );

      // Should NOT have Review Mistakes button
      expect(find.text('Review Mistakes'), findsNothing);
    });
  });
}
