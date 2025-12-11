import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Worry vs Fear Config', () {
    test('should load worry-vs-fear.json successfully', () async {
      // Act
      final config = await GameConfigLoader.load('worry-vs-fear.json');

      // Assert
      expect(config.gameId, 'worry-vs-fear');
      expect(config.version, '1.0');
      expect(config.intro.title, 'Worry vs Fear');
      expect(config.categoryA.id, 'fear');
      expect(config.categoryA.name, 'Fear');
      expect(config.categoryA.subtitle, '(Immediate)');
      expect(config.categoryA.icon, '🔥');
      expect(config.categoryB.id, 'worry');
      expect(config.categoryB.name, 'Worry');
      expect(config.categoryB.subtitle, '(Future)');
      expect(config.categoryB.icon, '☁️');
      expect(config.scenarios.length, 16);
    });

    test('should have correct scenario distribution', () async {
      // Act
      final config = await GameConfigLoader.load('worry-vs-fear.json');

      // Assert - should have 8 fear and 8 worry scenarios
      final fearScenarios = config.scenarios
          .where((s) => s.correctCategory == CategoryRole.categoryA)
          .toList();
      final worryScenarios = config.scenarios
          .where((s) => s.correctCategory == CategoryRole.categoryB)
          .toList();

      expect(fearScenarios.length, 8);
      expect(worryScenarios.length, 8);
    });

    test('should have original scenario content', () async {
      // Act
      final config = await GameConfigLoader.load('worry-vs-fear.json');

      // Assert - check a few key scenarios
      final carScenario = config.scenarios.firstWhere((s) => s.id == 'fear-1');
      expect(carScenario.text, 'A car just swerved toward me');
      expect(carScenario.emoji, '🚗');
      expect(carScenario.correctCategory, CategoryRole.categoryA);

      final partnerScenario = config.scenarios.firstWhere(
        (s) => s.id == 'worry-1',
      );
      expect(
        partnerScenario.text,
        'Thinking "what if I never find a partner?"',
      );
      expect(partnerScenario.emoji, '💔');
      expect(partnerScenario.correctCategory, CategoryRole.categoryB);
    });
  });

  group('Good Moments Config', () {
    test('should load good-moments.json successfully', () async {
      // Act
      final config = await GameConfigLoader.load('good-moments.json');

      // Assert
      expect(config.gameId, 'good-moments-vs-other');
      expect(config.version, '1.0');
      expect(config.intro.title, 'Recognize Good Moments');
      expect(config.categoryA.id, 'good-moment');
      expect(config.categoryA.name, 'Good Moment');
      expect(config.categoryA.subtitle, '(Notice this)');
      expect(config.categoryA.icon, '✨');
      expect(config.categoryB.id, 'other-moment');
      expect(config.categoryB.name, 'Other Moment');
      expect(config.categoryB.subtitle, '(Let it pass)');
      expect(config.categoryB.icon, '➡️');
      expect(config.scenarios.length, 16);
    });

    test('should have correct scenario distribution', () async {
      // Act
      final config = await GameConfigLoader.load('good-moments.json');

      // Assert - should have 8 good moments and 8 other moments
      final goodMoments = config.scenarios
          .where((s) => s.correctCategory == CategoryRole.categoryA)
          .toList();
      final otherMoments = config.scenarios
          .where((s) => s.correctCategory == CategoryRole.categoryB)
          .toList();

      expect(goodMoments.length, 8);
      expect(otherMoments.length, 8);
    });

    test('should have good moments scenario content', () async {
      // Act
      final config = await GameConfigLoader.load('good-moments.json');

      // Assert - check a few key scenarios
      final smileScenario = config.scenarios.firstWhere(
        (s) => s.id == 'good-1',
      );
      expect(smileScenario.text, 'A stranger smiled at me');
      expect(smileScenario.emoji, '😊');
      expect(smileScenario.correctCategory, CategoryRole.categoryA);

      final trafficScenario = config.scenarios.firstWhere(
        (s) => s.id == 'other-1',
      );
      expect(trafficScenario.text, 'Traffic light turned red');
      expect(trafficScenario.emoji, '🚦');
      expect(trafficScenario.correctCategory, CategoryRole.categoryB);
    });
  });
}
