/// Test helpers for config-driven game tests.
///
/// Provides pre-configured GameConfig, CategoryConfig, and Scenario
/// instances for use across all test files.
library;

import 'package:flutter/material.dart';
import 'package:worry_fear_game/domain/models/category.dart';
import 'package:worry_fear_game/domain/models/category_config.dart';
import 'package:worry_fear_game/domain/models/game_config.dart';
import 'package:worry_fear_game/domain/models/intro_config.dart';
import 'package:worry_fear_game/domain/models/scenario.dart';
import 'package:worry_fear_game/domain/models/session_scenario.dart';

/// Test category config for categoryA (analogous to "fear").
const testCategoryA = CategoryConfig(
  id: 'test-category-a',
  name: 'Category A',
  subtitle: '(Test A)',
  colorStart: Color(0xFFFF6B35),
  colorEnd: Color(0xFFE63946),
  icon: '🔥',
  educationalText: 'This is test educational text for category A.',
);

/// Test category config for categoryB (analogous to "worry").
const testCategoryB = CategoryConfig(
  id: 'test-category-b',
  name: 'Category B',
  subtitle: '(Test B)',
  colorStart: Color(0xFF4A90E2),
  colorEnd: Color(0xFF2C5F8D),
  icon: '☁️',
  educationalText: 'This is test educational text for category B.',
);

/// Test intro config.
const testIntroConfig = IntroConfig(
  title: 'Test Game Title',
  educationalText: ['Test paragraph 1.', 'Test paragraph 2.'],
  scientificTitle: '📚 Test Scientific Background',
  scientificContent: 'Test scientific content.',
);

/// Test game config.
const testGameConfig = GameConfig(
  gameId: 'test-game',
  version: '1.0',
  intro: testIntroConfig,
  categoryA: testCategoryA,
  categoryB: testCategoryB,
  scenarios: [],
);

/// Creates a test scenario with categoryA.
Scenario createTestScenarioCategoryA({
  String id = 'test-scenario-a',
  String text = 'Test scenario for category A',
  String emoji = '😨',
}) {
  return Scenario(
    id: id,
    text: text,
    emoji: emoji,
    correctCategory: const CategoryRoleA(),
  );
}

/// Creates a test scenario with categoryB.
Scenario createTestScenarioCategoryB({
  String id = 'test-scenario-b',
  String text = 'Test scenario for category B',
  String emoji = '😰',
}) {
  return Scenario(
    id: id,
    text: text,
    emoji: emoji,
    correctCategory: const CategoryRoleB(),
  );
}

/// Creates a list of test session scenarios.
List<SessionScenario> createTestSessionScenarios({int count = 10}) {
  return List.generate(count, (index) {
    final isCategoryA = index % 2 == 0;
    final scenario = isCategoryA
        ? createTestScenarioCategoryA(
            id: 'scenario-$index',
            text: 'Test scenario $index',
          )
        : createTestScenarioCategoryB(
            id: 'scenario-$index',
            text: 'Test scenario $index',
          );
    return SessionScenario(scenario: scenario);
  });
}

/// Creates a test GameConfig with scenarios.
GameConfig createTestGameConfigWithScenarios({int scenarioCount = 16}) {
  final scenarios = List.generate(scenarioCount, (index) {
    final isCategoryA = index % 2 == 0;
    return isCategoryA
        ? createTestScenarioCategoryA(
            id: 'scenario-$index',
            text: 'Test scenario $index',
          )
        : createTestScenarioCategoryB(
            id: 'scenario-$index',
            text: 'Test scenario $index',
          );
  });

  return GameConfig(
    gameId: 'test-game',
    version: '1.0',
    intro: testIntroConfig,
    categoryA: testCategoryA,
    categoryB: testCategoryB,
    scenarios: scenarios
        .map(
          (s) => ScenarioConfig(
            id: s.id,
            text: s.text,
            emoji: s.emoji,
            correctCategory: s.correctCategory,
          ),
        )
        .toList(),
  );
}
