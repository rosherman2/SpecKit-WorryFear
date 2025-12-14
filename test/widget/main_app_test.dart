import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/main.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';
import 'package:worry_fear_game/domain/models/savoring_config.dart';

void main() {
  group('MindGOApp Widget Tests', () {
    late GameConfig mockGameConfig;
    late SavoringConfig mockSavoringConfig;

    setUp(() {
      // Arrange: Create mock game config with all required fields
      mockGameConfig = GameConfig.fromJson({
        'gameId': 'test-game',
        'version': '1.0.0',
        'intro': {
          'title': 'Test Game',
          'educationalText': [
            'Test educational text line 1',
            'Test educational text line 2',
          ],
          'scientificTitle': 'Scientific Background',
          'scientificContent': 'Test background',
        },
        'categoryA': {
          'id': 'categoryA',
          'name': 'Category A Name',
          'subtitle': 'Category A Subtitle',
          'colorStart': '#FF6B35',
          'colorEnd': '#E63946',
          'icon': '😊',
          'educationalText': 'Category A education',
        },
        'categoryB': {
          'id': 'categoryB',
          'name': 'Category B Name',
          'subtitle': 'Category B Subtitle',
          'colorStart': '#4ECDC4',
          'colorEnd': '#1A535C',
          'icon': '😟',
          'educationalText': 'Category B education',
        },
        'scenarios': [],
      });

      // Create mock savoring config
      mockSavoringConfig = SavoringConfig.fromJson({
        'gameId': 'savoring-test',
        'version': '1.0.0',
        'intro': {
          'title': 'Test Savoring',
          'conceptText': ['Test concept'],
          'benefitText': 'Test benefit',
          'scientificTitle': 'Test Scientific',
          'scientificContent': 'Test content',
        },
        'character': {
          'idleImage': 'test/idle.png',
          'affirmingImage': 'test/affirm.png',
          'celebrationImage': 'test/celebrate.png',
        },
        'stems': List.generate(
          10,
          (i) => {
            'id': 'stem-$i',
            'templateText': 'Test {1}',
            'blankCount': 1,
            'blanks': [
              {
                'index': 1,
                'tiles': [
                  {'text': 't1', 'isCorrect': true},
                  {'text': 't2', 'isCorrect': false},
                  {'text': 't3', 'isCorrect': false},
                ],
                'incorrectFeedback': 'No',
              },
            ],
            'correctFeedback': 'Yes',
          },
        ),
      });
    });

    testWidgets('should have MindGO as app title', (WidgetTester tester) async {
      // Act: Build the app
      await tester.pumpWidget(
        MindGOApp(
          gameConfig: mockGameConfig,
          savoringConfig: mockSavoringConfig,
        ),
      );

      // Assert: Find MaterialApp and check title
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('MindGO'));
    });

    testWidgets('should have /welcome as initial route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(
        MindGOApp(
          gameConfig: mockGameConfig,
          savoringConfig: mockSavoringConfig,
        ),
      );

      // Assert: Check initial route
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.initialRoute, equals('/welcome'));
    });

    testWidgets('should define /welcome route', (WidgetTester tester) async {
      // Act: Build the app
      await tester.pumpWidget(
        MindGOApp(
          gameConfig: mockGameConfig,
          savoringConfig: mockSavoringConfig,
        ),
      );

      // Assert: Check that /welcome route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/welcome'));
    });

    testWidgets('should define /good-moments/intro route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(
        MindGOApp(
          gameConfig: mockGameConfig,
          savoringConfig: mockSavoringConfig,
        ),
      );

      // Assert: Check that /good-moments/intro route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/good-moments/intro'));
    });

    testWidgets('should define /savoring/intro route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(
        MindGOApp(
          gameConfig: mockGameConfig,
          savoringConfig: mockSavoringConfig,
        ),
      );

      // Assert: Check that /savoring/intro route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/savoring/intro'));
    });
  });
}
