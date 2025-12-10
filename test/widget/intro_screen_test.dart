import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/screens/intro_screen.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';

void main() {
  group('IntroScreen', () {
    testWidgets('displays main title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      expect(find.text('Worry vs Fear'), findsOneWidget);
    });

    testWidgets('displays educational description', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      expect(
        find.textContaining('Worry imagines future what-ifs'),
        findsOneWidget,
      );
    });

    testWidgets('displays Fear and Worry bottles', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      // Should have 2 bottles
      expect(find.byType(BottleWidget), findsNWidgets(2));
    });

    testWidgets('displays Start button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      expect(find.text('Start'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays Scientific Background expandable section', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      expect(find.text('Scientific Background'), findsOneWidget);
    });

    testWidgets('Start button navigates to gameplay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const IntroScreen(),
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
      await tester.pumpWidget(const MaterialApp(home: IntroScreen()));

      final expandableFinder = find.text('Scientific Background');
      expect(expandableFinder, findsOneWidget);

      // Should not throw when tapped
      await tester.tap(expandableFinder);
      await tester.pump();

      // Screen should still be functional
      expect(find.text('Worry vs Fear'), findsOneWidget);
    });
  });
}
