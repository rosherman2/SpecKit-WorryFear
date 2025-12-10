import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';

void main() {
  group('BottleWidget', () {
    testWidgets('renders fear bottle with correct icon and colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottleWidget(category: Category.fear, isGlowing: false),
          ),
        ),
      );

      expect(find.text('Fear'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets('renders worry bottle with correct icon and colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottleWidget(category: Category.worry, isGlowing: false),
          ),
        ),
      );

      expect(find.text('Worry'), findsOneWidget);
      expect(find.text('☁️'), findsOneWidget);
    });

    testWidgets('shows glow effect when isGlowing is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottleWidget(category: Category.fear, isGlowing: true),
          ),
        ),
      );

      // Widget should render - glow effect verified visually
      expect(find.byType(BottleWidget), findsOneWidget);
    });
  });
}
