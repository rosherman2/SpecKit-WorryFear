import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';

void main() {
  group('Session', () {
    // Helper to create test scenarios
    List<SessionScenario> createTestScenarios(int count) {
      return List.generate(
        count,
        (i) => SessionScenario(
          scenario: Scenario(
            id: 'test-$i',
            text: 'Test scenario $i',
            emoji: '🎯',
            correctCategory: i % 2 == 0
                ? const CategoryRoleA()
                : const CategoryRoleB(),
          ),
        ),
      );
    }

    test('should create session with 10 scenarios', () {
      // Arrange
      final scenarios = createTestScenarios(10);

      // Act
      final session = Session(scenarios: scenarios);

      // Assert
      expect(session.scenarios.length, 10);
      expect(session.currentIndex, 0);
      expect(session.score, 0);
    });

    test('should calculate score correctly for correct answers', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act - record 5 correct answers
      for (var i = 0; i < 5; i++) {
        session = session.recordCorrect(i);
      }

      // Assert
      expect(session.score, 10); // 5 correct * 2 points each
    });

    test('should track incorrect scenarios for review', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act - record some incorrect answers
      session = session.recordIncorrect(0);
      session = session.recordIncorrect(2);
      session = session.recordIncorrect(5);

      // Assert
      final reviewList = session.incorrectScenarios;
      expect(reviewList.length, 3);
      expect(reviewList[0].scenario.id, 'test-0');
      expect(reviewList[1].scenario.id, 'test-2');
      expect(reviewList[2].scenario.id, 'test-5');
    });

    test('should mark session as complete when all scenarios answered', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act - answer all scenarios
      for (var i = 0; i < 10; i++) {
        session = session.recordCorrect(i);
      }

      // Assert
      expect(session.isComplete, true);
    });

    test('should not be complete if any scenario unanswered', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act - answer only 9 scenarios
      for (var i = 0; i < 9; i++) {
        session = session.recordCorrect(i);
      }

      // Assert
      expect(session.isComplete, false);
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      final original = Session(scenarios: scenarios);

      // Act
      final modified = original.copyWith(currentIndex: 5, score: 10);

      // Assert
      expect(modified.currentIndex, 5);
      expect(modified.score, 10);
      expect(modified.scenarios, original.scenarios);
      expect(original.currentIndex, 0); // Original unchanged
      expect(original.score, 0); // Original unchanged
    });

    test('should not award points for incorrect answers', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act
      session = session.recordIncorrect(0);
      session = session.recordIncorrect(1);

      // Assert
      expect(session.score, 0);
    });

    test('should handle mixed correct and incorrect answers', () {
      // Arrange
      final scenarios = createTestScenarios(10);
      var session = Session(scenarios: scenarios);

      // Act
      session = session.recordCorrect(0); // +2
      session = session.recordIncorrect(1); // +0
      session = session.recordCorrect(2); // +2
      session = session.recordCorrect(3); // +2

      // Assert
      expect(session.score, 6);
      expect(session.incorrectScenarios.length, 1);
    });
  });
}
