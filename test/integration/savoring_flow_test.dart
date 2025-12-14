import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/services/game_config_loader.dart';
import 'package:worry_fear_game/domain/services/savoring_config_loader.dart';
import 'package:worry_fear_game/main.dart';

/// Integration test for complete savoring game flow.
/// Tests the entire user journey from welcome to gameplay.
void main() {
  group('Savoring Game Integration Tests', () {
    testWidgets('should navigate from welcome to savoring gameplay', (
      WidgetTester tester,
    ) async {
      // Arrange: Load configs
      final gameConfig = await GameConfigLoader.load(
        GameConfigLoader.activeConfig,
      );
      final savoringConfig = await SavoringConfigLoader.load(
        'assets/configs/savoring.json',
      );

      // Start the app
      await tester.pumpWidget(
        MindGOApp(gameConfig: gameConfig, savoringConfig: savoringConfig),
      );
      await tester.pumpAndSettle();

      // Assert: Welcome screen appears
      expect(find.text('Choose a Game'), findsOneWidget);
      expect(find.text('Savoring Choice'), findsOneWidget);

      // Act: Tap Savoring Choice game
      await tester.tap(find.text('Savoring Choice'));
      await tester.pumpAndSettle();

      // Assert: Intro screen appears
      expect(find.textContaining('Savoring'), findsWidgets);
      expect(find.text('Start'), findsOneWidget);

      // Act: Scroll to and tap Start button
      await tester.ensureVisible(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      // Assert: Gameplay screen appears with Round 1
      expect(find.text('Round 1/10'), findsOneWidget);
      expect(find.text('0 pts'), findsOneWidget);

      // Assert: Sentence and tiles are displayed
      expect(find.textContaining('It is okay to'), findsOneWidget);
      expect(find.text('enjoy this moment'), findsOneWidget);

      // Act: Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert: Back at intro screen
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('should display all UI elements correctly', (
      WidgetTester tester,
    ) async {
      // Arrange: Load configs and start app
      final gameConfig = await GameConfigLoader.load(
        GameConfigLoader.activeConfig,
      );
      final savoringConfig = await SavoringConfigLoader.load(
        'assets/configs/savoring.json',
      );

      await tester.pumpWidget(
        MindGOApp(gameConfig: gameConfig, savoringConfig: savoringConfig),
      );
      await tester.pumpAndSettle();

      // Navigate to gameplay
      await tester.tap(find.text('Savoring Choice'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      // Assert: All gameplay elements present
      expect(find.text('Round 1/10'), findsOneWidget);
      expect(find.text('0 pts'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      // Character widget should be present
      expect(find.byType(Image), findsWidgets); // Character image

      // Word tiles should be present
      expect(find.text('enjoy this moment'), findsOneWidget);
      expect(find.text('keep moving'), findsOneWidget);
      expect(find.text('focus on what is wrong'), findsOneWidget);
    });
  });
}
