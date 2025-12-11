import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/screens/intro_screen.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('IntroScreen', () {
    testWidgets('displays main title from config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      expect(find.text('Test Game Title'), findsOneWidget);
    });

    testWidgets('displays educational description from config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      expect(find.textContaining('Test paragraph 1'), findsOneWidget);
    });

    testWidgets('displays Fear and Worry bottles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      // Should have 2 bottles
      expect(find.byType(BottleWidget), findsNWidgets(2));
    });

    testWidgets('displays Start button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      expect(find.text('Start'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays Scientific Background expandable section', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      expect(find.textContaining('Scientific Background'), findsOneWidget);
    });

    testWidgets('Start button navigates to gameplay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IntroScreen(gameConfig: testGameConfig),
          routes: {
            '/gameplay': (context) =>
                const Scaffold(body: Center(child: Text('Gameplay Screen'))),
          },
        ),
      );

      // Find and tap Start button
      await tester.tap(find.text('Start'));
      await tester.pump(); // Start navigation
      await tester.pump(const Duration(milliseconds: 500)); // Animation

      // Should navigate to gameplay route
      expect(find.text('Gameplay Screen'), findsOneWidget);
    });

    testWidgets('expandable section can be tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: IntroScreen(gameConfig: testGameConfig)),
      );

      final expandableFinder = find.textContaining('Scientific Background');
      expect(expandableFinder, findsOneWidget);

      // Should not throw when tapped
      await tester.tap(expandableFinder);
      await tester.pump();

      // Screen should still be functional
      expect(find.text('Test Game Title'), findsOneWidget);
    });
  });
}
