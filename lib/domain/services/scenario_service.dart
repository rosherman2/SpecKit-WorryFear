import 'dart:math';
import '../data/scenarios.dart';
import '../models/session_scenario.dart';

/// [Service] Provides scenario selection logic for game sessions.
/// Purpose: Randomly selects 10 scenarios from the pool of 16, ensuring variety.
///
/// The service ensures each session has:
/// - Exactly 10 scenarios (FR-049)
/// - At least 3 worry scenarios
/// - At least 3 fear scenarios
/// - No duplicate scenarios in the same session
/// - Random order each session
///
/// Example:
/// ```dart
/// final service = ScenarioService();
/// final scenarios = service.getSessionScenarios();
/// // Returns 10 random SessionScenario objects
/// ```
class ScenarioService {
  /// Random number generator for scenario selection.
  final Random _random = Random();

  /// Gets 10 randomly selected scenarios for a new game session.
  ///
  /// Selection algorithm:
  /// 1. Randomly pick 3-7 scenarios from worry pool
  /// 2. Fill remaining slots from fear pool to reach 10 total
  /// 3. Shuffle the combined list for random order
  /// 4. Wrap each in SessionScenario for state tracking
  ///
  /// Returns: List of 10 SessionScenario objects in random order
  List<SessionScenario> getSessionScenarios() {
    // Determine split (ensure at least 3 of each type)
    // Random number between 3 and 7 for worry count
    final worryCount = 3 + _random.nextInt(5); // 3, 4, 5, 6, or 7
    final fearCount = 10 - worryCount; // Remaining slots

    // Randomly select from each pool
    final selectedWorry = _selectRandom(Scenarios.worryScenarios, worryCount);
    final selectedFear = _selectRandom(Scenarios.fearScenarios, fearCount);

    // Combine and shuffle
    final combined = [...selectedWorry, ...selectedFear];
    combined.shuffle(_random);

    // Wrap in SessionScenario for state tracking
    return combined
        .map((scenario) => SessionScenario(scenario: scenario))
        .toList();
  }

  /// Randomly selects a specified number of items from a list.
  ///
  /// Uses Fisher-Yates shuffle algorithm to ensure fair random selection
  /// without duplicates.
  ///
  /// Parameters:
  /// - [source]: Source list to select from
  /// - [count]: Number of items to select
  ///
  /// Returns: List of randomly selected items
  List<T> _selectRandom<T>(List<T> source, int count) {
    final shuffled = List<T>.from(source);
    shuffled.shuffle(_random);
    return shuffled.take(count).toList();
  }
}
