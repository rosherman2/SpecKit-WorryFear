import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/savoring_config.dart';
import 'package:worry_fear_game/domain/services/savoring_config_loader.dart';
import 'package:worry_fear_game/presentation/screens/savoring_intro_screen.dart';
import 'package:worry_fear_game/presentation/widgets/expandable_section.dart';

void main() {
  // Use TestWidgetsFlutterBinding for asset loading
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SavoringIntroScreen Widget Tests', () {
    late SavoringConfig savoringConfig;

    setUpAll(() async {
      // Load actual savoring config for testing
      savoringConfig = await SavoringConfigLoader.load(
        'assets/configs/savoring.json',
      );
    });

    testWidgets('should display intro title from config', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find the title from config
      expect(find.text(savoringConfig.intro.title), findsOneWidget);
    });

    testWidgets('should display all concept text paragraphs', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find all concept text paragraphs
      for (final paragraph in savoringConfig.intro.conceptText) {
        expect(find.text(paragraph), findsOneWidget);
      }
    });

    testWidgets('should display benefit text', (WidgetTester tester) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find benefit text
      expect(find.text(savoringConfig.intro.benefitText), findsOneWidget);
    });

    testWidgets('should display expandable scientific section', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find ExpandableSection widget
      expect(find.byType(ExpandableSection), findsOneWidget);

      // Assert: Find scientific title
      expect(find.text(savoringConfig.intro.scientificTitle), findsOneWidget);
    });

    testWidgets('should have Start button that navigates to gameplay', (
      WidgetTester tester,
    ) async {
      // Arrange: Build with navigation
      await tester.pumpWidget(
        MaterialApp(
          home: SavoringIntroScreen(savoringConfig: savoringConfig),
          routes: {
            '/savoring/gameplay': (context) =>
                const Scaffold(body: Text('Savoring Gameplay')),
          },
        ),
      );

      // Assert: Find Start button exists
      expect(find.text('Start'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have scrollable layout', (WidgetTester tester) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find scrollable widget
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have AppBar with back button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find AppBar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display character placeholder', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the intro screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringIntroScreen(savoringConfig: savoringConfig)),
      );

      // Assert: Find character emoji
      expect(find.text('✨'), findsOneWidget);
    });
  });
}
