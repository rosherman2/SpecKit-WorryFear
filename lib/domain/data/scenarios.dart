import '../models/category.dart';
import '../models/scenario.dart';

/// [StaticData] Pool of all available scenarios for the game.
/// Purpose: Centralized repository of the 16 scenarios (8 worry, 8 fear).
///
/// This class provides the complete pool of scenarios from which each session
/// randomly selects 10. Scenarios are organized by category for easy reference.
///
/// Content follows spec requirements (FR-047, FR-048):
/// - 8 Worry scenarios (future-focused "what ifs")
/// - 8 Fear scenarios (immediate danger)
class Scenarios {
  // ============================================================
  // Worry Scenarios (Future-Focused Concerns)
  // ============================================================

  /// Worry scenario: Romantic relationship concern
  static const Scenario worry1 = Scenario(
    id: 'worry-1',
    text: 'Thinking "what if I never find a partner?"',
    emoji: '💔',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Job security concern
  static const Scenario worry2 = Scenario(
    id: 'worry-2',
    text: 'I might lose my job next month',
    emoji: '💼',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Academic performance concern
  static const Scenario worry3 = Scenario(
    id: 'worry-3',
    text: 'The exam tomorrow could go terribly',
    emoji: '📝',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Financial security concern
  static const Scenario worry4 = Scenario(
    id: 'worry-4',
    text: 'My savings might not last',
    emoji: '💰',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Child health concern
  static const Scenario worry5 = Scenario(
    id: 'worry-5',
    text: 'My child could get sick during the trip',
    emoji: '🤒',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Travel disruption concern
  static const Scenario worry6 = Scenario(
    id: 'worry-6',
    text: "There's a chance the flight will be cancelled",
    emoji: '✈️',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Social embarrassment concern
  static const Scenario worry7 = Scenario(
    id: 'worry-7',
    text: "I'm afraid I'll say something dumb in the meeting",
    emoji: '😰',
    correctCategory: Category.worry,
  );

  /// Worry scenario: Real estate market concern
  static const Scenario worry8 = Scenario(
    id: 'worry-8',
    text: "I'm worried home prices will drop before I buy",
    emoji: '🏠',
    correctCategory: Category.worry,
  );

  // ============================================================
  // Fear Scenarios (Immediate Danger)
  // ============================================================

  /// Fear scenario: Vehicle collision threat
  static const Scenario fear1 = Scenario(
    id: 'fear-1',
    text: 'A car just swerved toward me',
    emoji: '🚗',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Animal threat
  static const Scenario fear2 = Scenario(
    id: 'fear-2',
    text: 'A dog is growling right next to my leg',
    emoji: '🐕',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Gas leak hazard
  static const Scenario fear3 = Scenario(
    id: 'fear-3',
    text: 'I smell gas in the room',
    emoji: '⚠️',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Stalking threat
  static const Scenario fear4 = Scenario(
    id: 'fear-4',
    text: 'I hear footsteps behind me in the dark',
    emoji: '👣',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Fire hazard
  static const Scenario fear5 = Scenario(
    id: 'fear-5',
    text: "There's smoke filling the room",
    emoji: '💨',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Explosion threat
  static const Scenario fear6 = Scenario(
    id: 'fear-6',
    text: 'A loud bang just happened outside my window',
    emoji: '💥',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Elevator malfunction
  static const Scenario fear7 = Scenario(
    id: 'fear-7',
    text: 'The elevator suddenly dropped',
    emoji: '🛗',
    correctCategory: Category.fear,
  );

  /// Fear scenario: Fall hazard
  static const Scenario fear8 = Scenario(
    id: 'fear-8',
    text: 'I just slipped at the edge of a cliff',
    emoji: '⛰️',
    correctCategory: Category.fear,
  );

  // ============================================================
  // Collections
  // ============================================================

  /// All 8 worry scenarios in a list.
  static const List<Scenario> worryScenarios = [
    worry1,
    worry2,
    worry3,
    worry4,
    worry5,
    worry6,
    worry7,
    worry8,
  ];

  /// All 8 fear scenarios in a list.
  static const List<Scenario> fearScenarios = [
    fear1,
    fear2,
    fear3,
    fear4,
    fear5,
    fear6,
    fear7,
    fear8,
  ];

  /// Complete pool of all 16 scenarios.
  /// Used by ScenarioService to randomly select 10 per session.
  static const List<Scenario> allScenarios = [
    ...worryScenarios,
    ...fearScenarios,
  ];
}
