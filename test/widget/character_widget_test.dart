import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/presentation/widgets/character_widget.dart';

void main() {
  group('CharacterWidget Tests', () {
    testWidgets('should display idle state by default', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CharacterWidget(state: CharacterState.idle)),
        ),
      );

      // Assert: Find idle emoji
      expect(find.text('✨'), findsOneWidget);
    });

    testWidgets('should display affirming state', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterWidget(state: CharacterState.affirming),
          ),
        ),
      );

      // Assert: Find affirming emoji
      expect(find.text('🌟'), findsOneWidget);
    });

    testWidgets('should display celebration state', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterWidget(state: CharacterState.celebration),
          ),
        ),
      );

      // Assert: Find celebration emoji
      expect(find.text('🎉'), findsOneWidget);
    });

    testWidgets('should have consistent size', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CharacterWidget(state: CharacterState.idle)),
        ),
      );

      // Assert: Find container with expected size
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('✨'), matching: find.byType(Container))
            .first,
      );

      expect(container.constraints?.minWidth, equals(80.0));
      expect(container.constraints?.minHeight, equals(80.0));
    });

    testWidgets('should transition between states smoothly', (
      WidgetTester tester,
    ) async {
      // Arrange: Start with idle
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CharacterWidget(state: CharacterState.idle)),
        ),
      );
      expect(find.text('✨'), findsOneWidget);

      // Act: Change to affirming
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterWidget(state: CharacterState.affirming),
          ),
        ),
      );
      // Pump for animation duration
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 100));

      // Assert: Now showing affirming
      expect(find.text('🌟'), findsOneWidget);
      expect(find.text('✨'), findsNothing);
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CharacterWidget(state: CharacterState.idle)),
        ),
      );

      // Assert: Find container with decoration
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('✨'), matching: find.byType(Container))
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });
  });
}
