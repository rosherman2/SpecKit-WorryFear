import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/savoring_config.dart';
import 'package:worry_fear_game/domain/services/savoring_config_loader.dart';

void main() {
  // Use TestWidgetsFlutterBinding to initialize services for asset loading
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SavoringConfigLoader Tests', () {
    const testConfigPath = 'assets/configs/savoring.json';

    test('should load valid savoring config from JSON file', () async {
      // Arrange: Mock asset bundle will be automatically used in tests
      // The test will look for the actual file

      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: Config loaded successfully
      expect(config, isA<SavoringConfig>());
      expect(config.gameId, equals('savoring-choice'));
      expect(config.stems.length, greaterThanOrEqualTo(10));
    });

    test('should validate minimum 10 stems', () async {
      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: At least 10 stems
      expect(config.stems.length, greaterThanOrEqualTo(10));
      expect(config.hasMinimumStems, isTrue);
    });

    test('should throw on invalid config path', () async {
      // Arrange: Invalid path
      const invalidPath = 'assets/configs/nonexistent.json';

      // Act & Assert: Should throw
      expect(
        () => SavoringConfigLoader.load(invalidPath),
        throwsA(isA<Exception>()),
      );
    });

    test('should validate all stems have correct structure', () async {
      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: All stems are valid
      for (final stem in config.stems) {
        expect(stem.id, isNotEmpty);
        expect(stem.templateText, contains('{1}'));
        expect(stem.blankCount, greaterThan(0));
        expect(stem.blanks.length, equals(stem.blankCount));

        // Each blank should have exactly 3 tiles
        for (final blank in stem.blanks) {
          expect(blank.tiles.length, equals(3));

          // Exactly one tile should be correct
          final correctTiles = blank.tiles.where((t) => t.isCorrect).length;
          expect(correctTiles, equals(1));
        }
      }
    });

    test('should load intro config correctly', () async {
      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: Intro has all required fields
      expect(config.intro.title, isNotEmpty);
      expect(config.intro.conceptText, isNotEmpty);
      expect(config.intro.benefitText, isNotEmpty);
      expect(config.intro.scientificTitle, isNotEmpty);
      expect(config.intro.scientificContent, isNotEmpty);
    });

    test('should load character config correctly', () async {
      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: Character has all image paths
      expect(config.character.idleImage, contains('assets/images'));
      expect(config.character.affirmingImage, contains('assets/images'));
      expect(config.character.celebrationImage, contains('assets/images'));
    });

    test('should handle both single and double blank stems', () async {
      // Act: Load config
      final config = await SavoringConfigLoader.load(testConfigPath);

      // Assert: Has mix of single and double blank stems
      final singleBlanks = config.stems.where((s) => s.blankCount == 1).length;
      final doubleBlanks = config.stems.where((s) => s.blankCount == 2).length;

      expect(singleBlanks, greaterThan(0));
      expect(doubleBlanks, greaterThan(0));
    });
  });
}
