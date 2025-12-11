import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Initialization', () {
    test('should load config successfully', () async {
      try {
        // Arrange & Act - load config
        final gameConfig = await GameConfigLoader.load('good-moments.json');

        // Assert - config should be loaded correctly
        expect(gameConfig.gameId, isNotEmpty);
        expect(gameConfig.intro.title, isNotEmpty);
        expect(gameConfig.categoryA.id, 'good-moment');
        expect(gameConfig.categoryB.id, 'other-moment');
        expect(gameConfig.scenarios.length, greaterThanOrEqualTo(10));
      } catch (e, stack) {
        print('ERROR in test: $e');
        print(stack);
        rethrow;
      }
    });

    test('should validate config schema', () async {
      final gameConfig = await GameConfigLoader.load('good-moments.json');
      // Assert - all required fields present
      expect(gameConfig.intro.educationalText, isNotEmpty);
      expect(gameConfig.categoryA.name, isNotEmpty);
      expect(gameConfig.categoryB.name, isNotEmpty);
    });
  });
}
