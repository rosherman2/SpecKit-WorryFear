import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/main.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';

void main() {
  group('MindGOApp Widget Tests', () {
    late GameConfig mockGameConfig;

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
    });

    testWidgets('should have MindGO as app title', (WidgetTester tester) async {
      // Act: Build the app
      await tester.pumpWidget(MindGOApp(gameConfig: mockGameConfig));

      // Assert: Find MaterialApp and check title
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('MindGO'));
    });

    testWidgets('should have /welcome as initial route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(MindGOApp(gameConfig: mockGameConfig));

      // Assert: Check initial route
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.initialRoute, equals('/welcome'));
    });

    testWidgets('should define /welcome route', (WidgetTester tester) async {
      // Act: Build the app
      await tester.pumpWidget(MindGOApp(gameConfig: mockGameConfig));

      // Assert: Check that /welcome route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/welcome'));
    });

    testWidgets('should define /good-moments/intro route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(MindGOApp(gameConfig: mockGameConfig));

      // Assert: Check that /good-moments/intro route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/good-moments/intro'));
    });

    testWidgets('should define /savoring/intro route', (
      WidgetTester tester,
    ) async {
      // Act: Build the app
      await tester.pumpWidget(MindGOApp(gameConfig: mockGameConfig));

      // Assert: Check that /savoring/intro route exists
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, contains('/savoring/intro'));
    });
  });
}
