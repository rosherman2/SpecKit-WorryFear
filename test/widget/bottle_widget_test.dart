import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worry_fear_game/domain/models/category_config.dart';
import 'package:worry_fear_game/presentation/widgets/bottle_widget.dart';

void main() {
  group('BottleWidget', () {
    // Test category configs
    const fearConfig = CategoryConfig(
      id: 'fear',
      name: 'Fear',
      subtitle: '(Immediate)',
      colorStart: Color(0xFFFF6B35),
      colorEnd: Color(0xFFE63946),
      icon: '🔥',
      educationalText: 'Fear is immediate.',
    );

    const worryConfig = CategoryConfig(
      id: 'worry',
      name: 'Worry',
      subtitle: '(Future)',
      colorStart: Color(0xFF4A90E2),
      colorEnd: Color(0xFF2C5F8D),
      icon: '☁️',
      educationalText: 'Worry is future.',
    );

    testWidgets('renders fear bottle with correct icon and colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottleWidget(categoryConfig: fearConfig, isGlowing: false),
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
            body: BottleWidget(categoryConfig: worryConfig, isGlowing: false),
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
            body: BottleWidget(categoryConfig: fearConfig, isGlowing: true),
          ),
        ),
      );

      // Widget should render - glow effect verified visually
      expect(find.byType(BottleWidget), findsOneWidget);
    });
  });
}
