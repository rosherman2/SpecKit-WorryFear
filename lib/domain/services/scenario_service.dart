import 'dart:math';
import '../../core/utils/app_logger.dart';
import '../models/category.dart';
import '../models/game_config.dart';
import '../models/session_scenario.dart';

/// [Service] Provides scenario selection logic for game sessions.
/// Purpose: Randomly selects 10 scenarios from config, ensuring variety.
///
/// The service ensures each session has:
/// - Exactly 10 scenarios (FR-049)
/// - At least 3 categoryA scenarios
/// - At least 3 categoryB scenarios
/// - No duplicate scenarios in the same session
/// - Random order each session
///
/// Example:
/// ```dart
/// final service = ScenarioService(gameConfig: config);
/// final scenarios = service.getSessionScenarios();
/// // Returns 10 random SessionScenario objects
/// ```
class ScenarioService {
  /// Creates a scenario service with the given game configuration.
  ScenarioService({required this.gameConfig}) {
    AppLogger.info(
      'ScenarioService',
      'constructor',
      () =>
          'Initialized with ${gameConfig.scenarios.length} scenarios from ${gameConfig.gameId}',
    );
  }

  /// The game configuration containing all available scenarios.
  final GameConfig gameConfig;

  /// Random number generator for scenario selection.
  final Random _random = Random();

  /// Gets 10 randomly selected scenarios for a new game session.
  ///
  /// Selection algorithm:
  /// 1. Separate scenarios by category (A and B)
  /// 2. Randomly pick 3-7 scenarios from categoryA pool
  /// 3. Fill remaining slots from categoryB pool to reach 10 total
  /// 4. Shuffle the combined list for random order
  /// 5. Wrap each in SessionScenario for state tracking
  ///
  /// Returns: List of 10 SessionScenario objects in random order
  List<SessionScenario> getSessionScenarios() {
    AppLogger.debug(
      'ScenarioService',
      'getSessionScenarios',
      () => 'Selecting scenarios from pool of ${gameConfig.scenarios.length}',
    );

    // Convert ScenarioConfig to Scenario and separate by category
    final allScenarios = gameConfig.scenarios
        .map((sc) => sc.toScenario())
        .toList();
    final categoryAScenarios = allScenarios
        .where((s) => s.correctCategory is CategoryRoleA)
        .toList();
    final categoryBScenarios = allScenarios
        .where((s) => s.correctCategory is CategoryRoleB)
        .toList();

    AppLogger.debug(
      'ScenarioService',
      'getSessionScenarios',
      () =>
          'Pool: ${categoryAScenarios.length} categoryA, ${categoryBScenarios.length} categoryB',
    );

    // Determine split (ensure at least 3 of each type)
    // Random number between 3 and 7 for categoryA count
    final categoryACount = 3 + _random.nextInt(5); // 3, 4, 5, 6, or 7
    final categoryBCount = 10 - categoryACount; // Remaining slots

    AppLogger.debug(
      'ScenarioService',
      'getSessionScenarios',
      () =>
          'Selected $categoryACount categoryA and $categoryBCount categoryB scenarios',
    );

    // Randomly select from each pool
    final selectedA = _selectRandom(categoryAScenarios, categoryACount);
    final selectedB = _selectRandom(categoryBScenarios, categoryBCount);

    // Combine and shuffle
    final combined = [...selectedA, ...selectedB];
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
