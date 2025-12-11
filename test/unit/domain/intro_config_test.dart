import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/intro_config.dart';

void main() {
  group('IntroConfig', () {
    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'title': 'Worry vs Fear',
        'educationalText': [
          'Worry imagines future what-ifs.',
          'Fear reacts to immediate danger.',
        ],
        'scientificTitle': 'Scientific Background',
        'scientificContent': 'Research shows...',
      };

      // Act
      final config = IntroConfig.fromJson(json);

      // Assert
      expect(config.title, 'Worry vs Fear');
      expect(config.educationalText.length, 2);
      expect(config.educationalText[0], 'Worry imagines future what-ifs.');
      expect(config.scientificTitle, 'Scientific Background');
      expect(config.scientificContent, 'Research shows...');
    });

    test('should support equality', () {
      // Arrange
      const config1 = IntroConfig(
        title: 'Test',
        educationalText: ['Text 1'],
        scientificTitle: 'Science',
        scientificContent: 'Content',
      );
      const config2 = IntroConfig(
        title: 'Test',
        educationalText: ['Text 1'],
        scientificTitle: 'Science',
        scientificContent: 'Content',
      );
      const config3 = IntroConfig(
        title: 'Different',
        educationalText: ['Text 1'],
        scientificTitle: 'Science',
        scientificContent: 'Content',
      );

      // Act & Assert
      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      const config = IntroConfig(
        title: 'Test Title',
        educationalText: ['Line 1', 'Line 2'],
        scientificTitle: 'Science',
        scientificContent: 'Content',
      );

      // Act
      final json = config.toJson();

      // Assert
      expect(json['title'], 'Test Title');
      expect(json['educationalText'], ['Line 1', 'Line 2']);
      expect(json['scientificTitle'], 'Science');
      expect(json['scientificContent'], 'Content');
    });
  });
}
