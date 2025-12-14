import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/application/savoring/savoring_state.dart';
import 'package:worry_fear_game/presentation/screens/savoring_completion_screen.dart';

void main() {
  group('SavoringCompletionScreen Widget Tests', () {
    late SavoringCompleted completedState;

    setUp(() {
      completedState = const SavoringCompleted(totalScore: 80, totalRounds: 10);
    });

    testWidgets('should display final score', (WidgetTester tester) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find score display
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('should display celebration message', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find celebration text
      expect(find.textContaining('completed'), findsOneWidget);
    });

    testWidgets('should display character celebration', (
      WidgetTester tester,
    ) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find celebration emoji
      expect(find.text('✨'), findsWidgets);
    });

    testWidgets('should display Finish button', (WidgetTester tester) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find Finish button
      expect(find.text('Finish'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should navigate to welcome when Finish tapped', (
      WidgetTester tester,
    ) async {
      // Arrange: Build with navigation
      await tester.pumpWidget(
        MaterialApp(
          home: SavoringCompletionScreen(state: completedState),
          routes: {
            '/welcome': (context) =>
                const Scaffold(body: Text('Welcome Screen')),
          },
        ),
      );

      // Act: Scroll to and tap Finish button
      await tester.ensureVisible(find.text('Finish'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Assert: Navigated to welcome
      expect(find.text('Welcome Screen'), findsOneWidget);
    });

    testWidgets('should have AppBar with title', (WidgetTester tester) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find AppBar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display rounds completed', (WidgetTester tester) async {
      // Arrange & Act: Build the completion screen
      await tester.pumpWidget(
        MaterialApp(home: SavoringCompletionScreen(state: completedState)),
      );

      // Assert: Find rounds info
      expect(find.textContaining('10'), findsWidgets);
    });
  });
}
