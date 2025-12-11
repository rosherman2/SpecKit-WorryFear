import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/category_config.dart';
import 'package:worry_fear_game/domain/models/intro_config.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';

void main() {
  group('GameConfig', () {
    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'gameId': 'worry-vs-fear',
        'version': '1.0',
        'intro': {
          'title': 'Worry vs Fear',
          'educationalText': ['Line 1', 'Line 2'],
          'scientificTitle': 'Scientific Background',
          'scientificContent': 'Research shows...',
        },
        'categoryA': {
          'id': 'fear',
          'name': 'Fear',
          'subtitle': '(Immediate)',
          'colorStart': '#FF6B35',
          'colorEnd': '#E63946',
          'icon': '🔥',
          'educationalText': 'Fear is immediate.',
        },
        'categoryB': {
          'id': 'worry',
          'name': 'Worry',
          'subtitle': '(Future)',
          'colorStart': '#4A90E2',
          'colorEnd': '#2C5F8D',
          'icon': '☁️',
          'educationalText': 'Worry is future-focused.',
        },
        'scenarios': [
          {
            'id': 'fear-1',
            'text': 'A car swerved toward me',
            'emoji': '🚗',
            'correctCategory': 'categoryA',
          },
          {
            'id': 'worry-1',
            'text': 'What if I fail?',
            'emoji': '💔',
            'correctCategory': 'categoryB',
          },
        ],
      };

      // Act
      final config = GameConfig.fromJson(json);

      // Assert
      expect(config.gameId, 'worry-vs-fear');
      expect(config.version, '1.0');
      expect(config.intro.title, 'Worry vs Fear');
      expect(config.categoryA.id, 'fear');
      expect(config.categoryB.id, 'worry');
      expect(config.scenarios.length, 2);
      expect(config.scenarios[0].id, 'fear-1');
      expect(config.scenarios[0].correctCategory, CategoryRole.categoryA);
      expect(config.scenarios[1].correctCategory, CategoryRole.categoryB);
    });

    test('should get category by role', () {
      // Arrange
      final config = GameConfig(
        gameId: 'test',
        version: '1.0',
        intro: IntroConfig(
          title: 'Test',
          educationalText: ['Test'],
          scientificTitle: 'Science',
          scientificContent: 'Content',
        ),
        categoryA: CategoryConfig(
          id: 'cat-a',
          name: 'Category A',
          subtitle: '(A)',
          colorStart: Color(0xFFFF0000),
          colorEnd: Color(0xFFFF0000),
          icon: 'A',
          educationalText: 'A text',
        ),
        categoryB: CategoryConfig(
          id: 'cat-b',
          name: 'Category B',
          subtitle: '(B)',
          colorStart: Color(0xFF00FF00),
          colorEnd: Color(0xFF00FF00),
          icon: 'B',
          educationalText: 'B text',
        ),
        scenarios: const [],
      );

      // Act
      final catA = config.getCategory(CategoryRole.categoryA);
      final catB = config.getCategory(CategoryRole.categoryB);

      // Assert
      expect(catA.id, 'cat-a');
      expect(catB.id, 'cat-b');
    });

    test('should support equality', () {
      // Arrange
      final config1 = GameConfig(
        gameId: 'test',
        version: '1.0',
        intro: IntroConfig(
          title: 'Test',
          educationalText: ['Test'],
          scientificTitle: 'Science',
          scientificContent: 'Content',
        ),
        categoryA: CategoryConfig(
          id: 'a',
          name: 'A',
          subtitle: '(A)',
          colorStart: Color(0xFFFF0000),
          colorEnd: Color(0xFFFF0000),
          icon: 'A',
          educationalText: 'A',
        ),
        categoryB: CategoryConfig(
          id: 'b',
          name: 'B',
          subtitle: '(B)',
          colorStart: Color(0xFF00FF00),
          colorEnd: Color(0xFF00FF00),
          icon: 'B',
          educationalText: 'B',
        ),
        scenarios: const [],
      );
      final config2 = GameConfig(
        gameId: 'test',
        version: '1.0',
        intro: IntroConfig(
          title: 'Test',
          educationalText: ['Test'],
          scientificTitle: 'Science',
          scientificContent: 'Content',
        ),
        categoryA: CategoryConfig(
          id: 'a',
          name: 'A',
          subtitle: '(A)',
          colorStart: Color(0xFFFF0000),
          colorEnd: Color(0xFFFF0000),
          icon: 'A',
          educationalText: 'A',
        ),
        categoryB: CategoryConfig(
          id: 'b',
          name: 'B',
          subtitle: '(B)',
          colorStart: Color(0xFF00FF00),
          colorEnd: Color(0xFF00FF00),
          icon: 'B',
          educationalText: 'B',
        ),
        scenarios: const [],
      );
      final config3 = GameConfig(
        gameId: 'different',
        version: '1.0',
        intro: IntroConfig(
          title: 'Test',
          educationalText: ['Test'],
          scientificTitle: 'Science',
          scientificContent: 'Content',
        ),
        categoryA: CategoryConfig(
          id: 'a',
          name: 'A',
          subtitle: '(A)',
          colorStart: Color(0xFFFF0000),
          colorEnd: Color(0xFFFF0000),
          icon: 'A',
          educationalText: 'A',
        ),
        categoryB: CategoryConfig(
          id: 'b',
          name: 'B',
          subtitle: '(B)',
          colorStart: Color(0xFF00FF00),
          colorEnd: Color(0xFF00FF00),
          icon: 'B',
          educationalText: 'B',
        ),
        scenarios: const [],
      );

      // Act & Assert
      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });

  group('ScenarioConfig', () {
    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'test-1',
        'text': 'Test scenario',
        'emoji': '🔥',
        'correctCategory': 'categoryA',
      };

      // Act
      final config = ScenarioConfig.fromJson(json);

      // Assert
      expect(config.id, 'test-1');
      expect(config.text, 'Test scenario');
      expect(config.emoji, '🔥');
      expect(config.correctCategory, CategoryRole.categoryA);
    });

    test('should convert to Scenario model', () {
      // Arrange
      const config = ScenarioConfig(
        id: 'test-1',
        text: 'Test text',
        emoji: '🔥',
        correctCategory: CategoryRole.categoryB,
      );

      // Act
      final scenario = config.toScenario();

      // Assert
      expect(scenario.id, 'test-1');
      expect(scenario.text, 'Test text');
      expect(scenario.emoji, '🔥');
      expect(scenario.correctCategory, CategoryRole.categoryB);
    });
  });
}
