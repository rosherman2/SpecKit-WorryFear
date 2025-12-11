import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/review/review_bloc.dart';
import '../../application/review/review_event.dart';
import '../../application/review/review_state.dart';
import '../../core/audio/audio_service_impl.dart';
import '../../core/haptic/haptic_service_impl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/models/category.dart';
import '../../domain/models/category_config.dart';
import '../../domain/models/game_config.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/session_scenario.dart';
import '../animations/floating_animation.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/scenario_card.dart';
import '../widgets/success_animation.dart';

/// [StatefulWidget] Review screen for incorrect scenarios.
/// Purpose: Allows users to retry scenarios they got wrong with auto-correction.
///
/// Now fully config-driven - uses GameConfig for:
/// - Educational text during auto-correction (from ReviewBloc)
/// - Bottle rendering with categoryA/categoryB configs
///
/// Features:
/// - Shows review progress (e.g., "Reviewing 1 of 2")
/// - Reuses ScenarioCard and BottleWidget from main gameplay
/// - Tracks attempts (2 max before auto-correction)
/// - Shows config-driven educational text during auto-correction
/// - Returns to main flow when complete
///
/// Example:
/// ```dart
/// ReviewScreen(
///   reviewScenarios: session.incorrectScenarios,
///   gameConfig: loadedConfig,
/// )
/// ```
class ReviewScreen extends StatefulWidget {
  /// Creates a review screen.
  const ReviewScreen({
    required this.reviewScenarios,
    required this.gameConfig,
    super.key,
  });

  /// Scenarios that need review (were answered incorrectly).
  final List<SessionScenario> reviewScenarios;

  /// The game configuration.
  final GameConfig gameConfig;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late ReviewBloc _bloc;

  @override
  void initState() {
    super.initState();

    AppLogger.debug(
      'ReviewScreen',
      'initState',
      () =>
          'Initializing review for ${widget.reviewScenarios.length} scenarios',
    );

    _bloc = ReviewBloc(
      gameConfig: widget.gameConfig,
      audioService: AudioServiceImpl(),
      hapticService: HapticServiceImpl(),
    );
    _bloc.add(ReviewStarted(widget.reviewScenarios));
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
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Review Mode',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is ReviewComplete) {
              // Return to previous screen when review complete
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ReviewPlaying) {
              return _buildReviewPlaying(state);
            } else if (state is ReviewCorrectFeedback) {
              return _buildCorrectFeedback();
            } else if (state is ReviewIncorrectFeedback) {
              return _buildIncorrectFeedback();
            } else if (state is ReviewAutoCorrection) {
              return _buildAutoCorrection(state);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildReviewPlaying(ReviewPlaying state) {
    final currentScenario = state.currentScenario;
    final progress = state.currentIndex + 1;
    final total = state.reviewScenarios.length;

    return SafeArea(
      child: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Reviewing $progress of $total',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / total,
                  minHeight: 8,
                  backgroundColor: AppColors.lightGray,
                  valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                if (state.attemptCount > 0)
                  Text(
                    'Try again - ${2 - state.attemptCount} attempt${2 - state.attemptCount == 1 ? '' : 's'} left',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  const Text(
                    'Try again',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          const Spacer(),

          // Scenario Card
          ScenarioCard(
            scenario: currentScenario.scenario,
            categoryA: widget.gameConfig.categoryA,
            categoryB: widget.gameConfig.categoryB,
            onAccepted: (_) {}, // Not used, handled by DragTarget
            showError: state.attemptCount > 0,
          ),

          const Spacer(),

          // Bottles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDragTarget(
                  CategoryRole.categoryA,
                  widget.gameConfig.categoryA,
                  state,
                ),
                const SizedBox(width: 32),
                _buildDragTarget(
                  CategoryRole.categoryB,
                  widget.gameConfig.categoryB,
                  state,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(
    CategoryRole categoryRole,
    CategoryConfig categoryConfig,
    ReviewPlaying state,
  ) {
    return DragTarget<Scenario>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        _bloc.add(AnswerAttempted(category: categoryRole));
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return FloatingAnimation(
          duration: categoryRole is CategoryRoleA
              ? const Duration(milliseconds: 2000)
              : const Duration(milliseconds: 2300),
          offset: 6.0,
          child: BottleWidget(
            categoryConfig: categoryConfig,
            isGlowing: isHovering,
          ),
        );
      },
    );
  }

  Widget _buildCorrectFeedback() {
    return const Center(child: SuccessAnimation());
  }

  Widget _buildIncorrectFeedback() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: const Text(
          '❌ Not quite',
          style: TextStyle(
            fontSize: 32,
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAutoCorrection(ReviewAutoCorrection state) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '💡 The correct answer is:',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.correctCategory.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              state.educationalText,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
