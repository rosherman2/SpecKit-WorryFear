import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/screens/welcome_screen.dart';
import 'package:worry_fear_game/presentation/widgets/game_card.dart';

void main() {
  group('WelcomeScreen Widget Tests', () {
    testWidgets('should display 2 game cards', (WidgetTester tester) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find 2 GameCard widgets
      expect(find.byType(GameCard), findsNWidgets(2));
    });

    testWidgets('should display Good Moment game card', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find Good Moment game card
      expect(find.text('Good Moment vs Other Moment'), findsOneWidget);
    });

    testWidgets('should display Savoring Choice game card', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find Savoring Choice game card
      expect(find.text('Savoring Choice'), findsOneWidget);
    });

    testWidgets(
      'should navigate to good-moments/intro when tapping first card',
      (WidgetTester tester) async {
        // Arrange: Build the welcome screen with navigation
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeScreen(),
            routes: {
              '/good-moments/intro': (context) =>
                  const Scaffold(body: Text('Good Moments Intro')),
            },
          ),
        );

        // Act: Tap the Good Moment card
        await tester.tap(find.text('Good Moment vs Other Moment'));
        await tester.pumpAndSettle();

        // Assert: Navigated to intro screen
        expect(find.text('Good Moments Intro'), findsOneWidget);
      },
    );

    testWidgets('should navigate to savoring/intro when tapping second card', (
      WidgetTester tester,
    ) async {
      // Arrange: Build the welcome screen with navigation
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
          routes: {
            '/savoring/intro': (context) =>
                const Scaffold(body: Text('Savoring Intro')),
          },
        ),
      );

      // Act: Tap the Savoring Choice card
      await tester.tap(find.text('Savoring Choice'));
      await tester.pumpAndSettle();

      // Assert: Navigated to intro screen
      expect(find.text('Savoring Intro'), findsOneWidget);
    });

    testWidgets('should display app title MindGO', (WidgetTester tester) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find MindGO title
      expect(find.text('MindGO'), findsOneWidget);
    });

    testWidgets('should have AppBar with title', (WidgetTester tester) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find AppBar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should layout cards in a scrollable view', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find scrollable widget (SingleChildScrollView)
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should use centered column layout for cards', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the welcome screen
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Assert: Find Column widget containing cards
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(GameCard), findsNWidgets(2));
    });
  });
}
