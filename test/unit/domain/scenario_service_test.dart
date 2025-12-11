import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';
import 'package:worry_fear_game/domain/services/scenario_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScenarioService', () {
    late ScenarioService service;

    setUp(() async {
      // Load config before creating service
      final gameConfig = await GameConfigLoader.load('good-moments.json');
      service = ScenarioService(gameConfig: gameConfig);
    });

    test('should return exactly 10 scenarios', () {
      // Act
      final scenarios = service.getSessionScenarios();

      // Assert
      expect(scenarios.length, 10);
    });

    test('should include at least 3 categoryA scenarios', () {
      // Act
      final scenarios = service.getSessionScenarios();
      final categoryACount = scenarios
          .where((s) => s.scenario.correctCategory == CategoryRole.categoryA)
          .length;

      // Assert
      expect(categoryACount, greaterThanOrEqualTo(3));
    });

    test('should include at least 3 categoryB scenarios', () {
      // Act
      final scenarios = service.getSessionScenarios();
      final categoryBCount = scenarios
          .where((s) => s.scenario.correctCategory == CategoryRole.categoryB)
          .length;

      // Assert
      expect(categoryBCount, greaterThanOrEqualTo(3));
    });

    test('should not include duplicate scenarios in same session', () {
      // Act
      final scenarios = service.getSessionScenarios();
      final ids = scenarios.map((s) => s.scenario.id).toList();
      final uniqueIds = ids.toSet();

      // Assert
      expect(ids.length, uniqueIds.length);
    });

    test('should randomize scenario order between sessions', () {
      // Act - get multiple sessions
      final session1 = service.getSessionScenarios();
      final session2 = service.getSessionScenarios();
      final session3 = service.getSessionScenarios();

      final ids1 = session1.map((s) => s.scenario.id).toList();
      final ids2 = session2.map((s) => s.scenario.id).toList();
      final ids3 = session3.map((s) => s.scenario.id).toList();

      // Assert - at least one session should have different order
      // (statistically very unlikely all 3 are identical if truly random)
      final allIdentical =
          ids1.toString() == ids2.toString() &&
          ids2.toString() == ids3.toString();

      expect(allIdentical, false);
    });

    test('should select from pool of 16 scenarios', () {
      // Act - get many sessions and collect all unique IDs
      final allIds = <String>{};
      for (var i = 0; i < 20; i++) {
        final scenarios = service.getSessionScenarios();
        allIds.addAll(scenarios.map((s) => s.scenario.id));
      }

      // Assert - should see more than 10 unique scenarios
      // (proves we're selecting from a larger pool)
      expect(allIds.length, greaterThan(10));
    });

    test('should create SessionScenario wrappers with unanswered state', () {
      // Act
      final scenarios = service.getSessionScenarios();

      // Assert
      for (final sessionScenario in scenarios) {
        expect(sessionScenario.isAnswered, false);
        expect(sessionScenario.isCorrect, null);
        expect(sessionScenario.attemptCount, 0);
      }
    });
  });
}
