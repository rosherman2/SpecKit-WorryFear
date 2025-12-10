import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/gameplay/gameplay_bloc.dart';
import '../../application/gameplay/gameplay_event.dart';
import '../../application/gameplay/gameplay_state.dart';
import '../../core/audio/audio_service_impl.dart';
import '../../core/haptic/haptic_service_impl.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';
import '../../domain/models/scenario.dart';
import '../../domain/services/scenario_service.dart';
import '../animations/floating_animation.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/progress_bar.dart';
import '../widgets/scenario_card.dart';
import '../widgets/success_animation.dart';

/// [StatefulWidget] Main gameplay screen with drag-drop interaction.
/// Purpose: Core game loop where users classify scenarios.
/// Navigation: Accessed from IntroScreen via Start button.
///
/// Displays:
/// - Progress bar showing session progress
/// - Scenario card (draggable)
/// - Two bottle drop zones (Fear and Worry)
/// - Feedback animations for correct/incorrect answers
///
/// Example:
/// ```dart
/// Navigator.pushNamed(context, '/gameplay');
/// ```
class GameplayScreen extends StatefulWidget {
  /// Creates the gameplay screen.
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final GameplayBloc _bloc;
  Category? _hoveringOverBottle;
  bool _showError = false;

  @override
  void initState() {
    super.initState();

    // Initialize services and BLoC (constructor injection)
    _bloc = GameplayBloc(
      scenarioService: ScenarioService(),
      audioService: AudioServiceImpl(),
      hapticService: HapticServiceImpl(),
    );

    // Start the game
    _bloc.add(const GameStarted());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<GameplayBloc, GameplayState>(
            listener: (context, state) {
              // Show error state briefly on incorrect answer
              if (state is GameplayIncorrectFeedback) {
                setState(() => _showError = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _showError = false);
                  }
                });
              }
            },
            builder: (context, state) {
              return switch (state) {
                GameplayInitial() => const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                ),
                GameplayPlaying() => _buildPlayingState(context, state),
                GameplayCorrectFeedback() => const Center(
                  child: SuccessAnimation(),
                ),
                GameplayIncorrectFeedback() => const Center(
                  child: Text(
                    '❌ Try Again',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
                GameplayComplete() => _buildCompleteState(context, state),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayingState(BuildContext context, GameplayPlaying state) {
    final scenario = state.currentScenario.scenario;
    // Capture bloc reference to avoid context issues in drag callbacks
    final bloc = _bloc;

    return Column(
      children: [
        // Progress bar (FR-016 to FR-018)
        Padding(
          padding: const EdgeInsets.all(16),
          child: ProgressBar(
            current: state.currentScenarioIndex + 1,
            total: 10,
          ),
        ),

        const SizedBox(height: 40),

        // Scenario card (draggable)
        Expanded(
          child: Center(
            child: ScenarioCard(
              scenario: scenario,
              onAccepted: (category) {
                bloc.add(DroppedOnBottle(category: category));
              },
              showError: _showError,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Bottles (drag targets)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDragTarget(Category.fear, bloc),
              _buildDragTarget(Category.worry, bloc),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDragTarget(Category category, GameplayBloc bloc) {
    return DragTarget<Scenario>(
      onWillAcceptWithDetails: (details) {
        setState(() => _hoveringOverBottle = category);
        // Use captured bloc reference instead of context.read
        bloc.add(const DragStarted());
        return true;
      },
      onLeave: (_) {
        setState(() => _hoveringOverBottle = null);
      },
      onAcceptWithDetails: (details) {
        setState(() => _hoveringOverBottle = null);
        // Use captured bloc reference instead of context.read
        bloc.add(DroppedOnBottle(category: category));
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = _hoveringOverBottle == category;

        return FloatingAnimation(
          duration: Duration(
            milliseconds: 2000 + (category == Category.fear ? 0 : 300),
          ),
          offset: 6.0,
          child: BottleWidget(category: category, isGlowing: isHovering),
        );
      },
    );
  }

  Widget _buildCompleteState(BuildContext context, GameplayComplete state) {
    final scorePercent = (state.session.score / 20 * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            const Text(
              'Session Complete!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '${state.session.score} / 20 points ($scorePercent%)',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 32),
            if (state.session.incorrectScenarios.isNotEmpty) ...[
              Text(
                'Review ${state.session.incorrectScenarios.length} scenarios',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 20,
                ),
              ),
              child: const Text(
                'Finish',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
