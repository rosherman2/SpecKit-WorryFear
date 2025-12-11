import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category_config.dart';

void main() {
  group('CategoryConfig', () {
    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'fear',
        'name': 'Fear',
        'subtitle': '(Immediate)',
        'colorStart': '#FF6B35',
        'colorEnd': '#E63946',
        'icon': '🔥',
        'educationalText': 'Fear is about immediate danger.',
      };

      // Act
      final config = CategoryConfig.fromJson(json);

      // Assert
      expect(config.id, 'fear');
      expect(config.name, 'Fear');
      expect(config.subtitle, '(Immediate)');
      expect(config.colorStart, const Color(0xFFFF6B35));
      expect(config.colorEnd, const Color(0xFFE63946));
      expect(config.icon, '🔥');
      expect(config.educationalText, 'Fear is about immediate danger.');
    });

    test('should parse hex colors correctly', () {
      // Arrange
      final json = {
        'id': 'test',
        'name': 'Test',
        'subtitle': '(Test)',
        'colorStart': '#AABBCC',
        'colorEnd': '#112233',
        'icon': '✨',
        'educationalText': 'Test text',
      };

      // Act
      final config = CategoryConfig.fromJson(json);

      // Assert
      expect(config.colorStart, const Color(0xFFAABBCC));
      expect(config.colorEnd, const Color(0xFF112233));
    });

    test('should support equality', () {
      // Arrange
      const config1 = CategoryConfig(
        id: 'test',
        name: 'Test',
        subtitle: '(Test)',
        colorStart: Color(0xFFFF0000),
        colorEnd: Color(0xFF00FF00),
        icon: '🔥',
        educationalText: 'Text',
      );
      const config2 = CategoryConfig(
        id: 'test',
        name: 'Test',
        subtitle: '(Test)',
        colorStart: Color(0xFFFF0000),
        colorEnd: Color(0xFF00FF00),
        icon: '🔥',
        educationalText: 'Text',
      );
      const config3 = CategoryConfig(
        id: 'different',
        name: 'Test',
        subtitle: '(Test)',
        colorStart: Color(0xFFFF0000),
        colorEnd: Color(0xFF00FF00),
        icon: '🔥',
        educationalText: 'Text',
      );

      // Act & Assert
      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('should create gradient from colors', () {
      // Arrange
      const config = CategoryConfig(
        id: 'test',
        name: 'Test',
        subtitle: '(Test)',
        colorStart: Color(0xFFFF0000),
        colorEnd: Color(0xFF00FF00),
        icon: '🔥',
        educationalText: 'Text',
      );

      // Act
      final gradient = config.createGradient();

      // Assert
      expect(gradient.colors, [config.colorStart, config.colorEnd]);
      expect(gradient.begin, Alignment.topCenter);
      expect(gradient.end, Alignment.bottomCenter);
    });
  });
}
