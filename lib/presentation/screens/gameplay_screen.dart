import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/gameplay/gameplay_bloc.dart';
import '../../application/gameplay/gameplay_event.dart';
import '../../application/gameplay/gameplay_state.dart';
import '../../core/audio/audio_service_impl.dart';
import '../../core/haptic/haptic_service_impl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/models/category.dart';
import '../../domain/models/category_config.dart';
import '../../domain/models/game_config.dart';
import '../../domain/models/scenario.dart';
import '../../domain/services/onboarding_service.dart';
import '../../domain/services/scenario_service.dart';
import '../animations/floating_animation.dart';
import '../animations/points_animation.dart';
import '../widgets/bottle_glow_effect.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/drag_hint_icon.dart';
import '../widgets/progress_bar.dart';
import '../widgets/scenario_card.dart';
import '../widgets/success_animation.dart';
import 'completion_screen.dart';

/// [StatefulWidget] Main gameplay screen with drag-drop interaction.
/// Purpose: Core game loop where users classify scenarios.
/// Navigation: Accessed from IntroScreen via Start button.
///
/// Now fully config-driven - uses GameConfig for:
/// - Scenario loading via ScenarioService
/// - Bottle rendering with categoryA/categoryB configs
///
/// Displays:
/// - Progress bar showing session progress
/// - Scenario card (draggable)
/// - Two bottle drop zones (config-driven categories)
/// - Feedback animations for correct/incorrect answers (as overlay)
///
/// Example:
/// ```dart
/// GameplayScreen(gameConfig: loadedConfig)
/// ```
class GameplayScreen extends StatefulWidget {
  /// Creates the gameplay screen with game configuration.
  const GameplayScreen({required this.gameConfig, super.key});

  /// The game configuration.
  final GameConfig gameConfig;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final GameplayBloc _bloc;
  late final OnboardingService _onboardingService;
  CategoryRole? _hoveringOverBottle;
  bool _showError = false;
  bool _showOnboardingHints = false;

  // GlobalKeys to track bottle positions for flying animation
  final GlobalKey _bottleAKey = GlobalKey();
  final GlobalKey _bottleBKey = GlobalKey();

  // Store last playing state for overlay during feedback
  GameplayPlaying? _lastPlayingState;

  @override
  void initState() {
    super.initState();

    AppLogger.debug(
      'GameplayScreen',
      'initState',
      () => 'Initializing gameplay for: ${widget.gameConfig.gameId}',
    );

    _bloc = GameplayBloc(
      scenarioService: ScenarioService(gameConfig: widget.gameConfig),
      audioService: AudioServiceImpl(),
      hapticService: HapticServiceImpl(),
    );
    _bloc.add(const GameStarted());

    // Initialize onboarding service
    _initOnboarding();
  }

  Future<void> _initOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingService = OnboardingService(prefs);

    final isFirst = await _onboardingService.isFirstTime();
    AppLogger.debug(
      'GameplayScreen',
      '_initOnboarding',
      () => 'isFirstTime = $isFirst',
    );
    if (mounted) {
      setState(() {
        _showOnboardingHints = isFirst;
        AppLogger.info(
          'GameplayScreen',
          '_initOnboarding',
          () => '_showOnboardingHints set to $isFirst',
        );
      });
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// Gets the center position of a bottle using its GlobalKey.
  Offset? _getBottlePosition(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    // Return center of the bottle
    return Offset(position.dx + size.width / 2, position.dy + size.height / 2);
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
              // Store playing state for overlay during feedback
              if (state is GameplayPlaying) {
                _lastPlayingState = state;
              }
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
                GameplayCorrectFeedback() => _buildCorrectFeedbackOverlay(
                  context,
                  state,
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

  /// Builds the correct feedback as an overlay on the playing state.
  Widget _buildCorrectFeedbackOverlay(
    BuildContext context,
    GameplayCorrectFeedback state,
  ) {
    return Stack(
      children: [
        // Background: dimmed playing state
        if (_lastPlayingState != null)
          Opacity(
            opacity: 0.5,
            child: IgnorePointer(
              child: _buildPlayingState(context, _lastPlayingState!),
            ),
          ),

        // Points animation flying from bottle to center (if enabled in config)
        if (widget.gameConfig.showSuccessPointsAnimation)
          PointsAnimation(startPosition: state.bottlePosition),

        // Success animation in center (if enabled in config)
        if (widget.gameConfig.showSuccessAnimation)
          const Center(child: SuccessAnimation()),
      ],
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

        // Show drag hint ABOVE scenario card for first-time users
        if (_showOnboardingHints && state.currentScenarioIndex == 0)
          const Padding(
            padding: EdgeInsets.only(bottom: 8), // Small gap to card
            child: DragHintIcon(), // Bouncing arrow (now 48px)
          ),

        // Scenario card (draggable)
        Expanded(
          child: Center(
            child: ScenarioCard(
              scenario: scenario,
              categoryA: widget.gameConfig.categoryA,
              categoryB: widget.gameConfig.categoryB,
              onAccepted: (categoryRole) {
                // This is called by DragTarget, not directly
                final bottleKey = categoryRole is CategoryRoleA
                    ? _bottleAKey
                    : _bottleBKey;
                final position =
                    _getBottlePosition(bottleKey) ?? const Offset(0, 0);
                bloc.add(
                  DroppedOnBottle(
                    category: categoryRole,
                    bottlePosition: position,
                  ),
                );
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
              _buildDragTarget(
                CategoryRole.categoryA,
                widget.gameConfig.categoryA,
                bloc,
                state,
                _bottleAKey,
              ),
              _buildDragTarget(
                CategoryRole.categoryB,
                widget.gameConfig.categoryB,
                bloc,
                state,
                _bottleBKey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDragTarget(
    CategoryRole categoryRole,
    CategoryConfig categoryConfig,
    GameplayBloc bloc,
    GameplayPlaying state,
    GlobalKey bottleKey,
  ) {
    return DragTarget<Scenario>(
      onWillAcceptWithDetails: (details) {
        setState(() => _hoveringOverBottle = categoryRole);
        // Use captured bloc reference instead of context.read
        bloc.add(const DragStarted());
        return true;
      },
      onLeave: (_) {
        setState(() => _hoveringOverBottle = null);
      },
      onAcceptWithDetails: (details) {
        setState(() => _hoveringOverBottle = null);
        // Get bottle position for flying animation
        final position = _getBottlePosition(bottleKey) ?? const Offset(0, 0);
        // Use captured bloc reference instead of context.read
        bloc.add(
          DroppedOnBottle(category: categoryRole, bottlePosition: position),
        );

        // Mark onboarding complete after first drag
        if (_showOnboardingHints) {
          AppLogger.info(
            'GameplayScreen',
            'onAcceptWithDetails',
            () => 'Marking onboarding complete',
          );
          _onboardingService.markOnboardingComplete().then((_) {
            AppLogger.info(
              'GameplayScreen',
              'onAcceptWithDetails',
              () => 'Onboarding marked complete',
            );
          });
          setState(() => _showOnboardingHints = false);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = _hoveringOverBottle == categoryRole;
        final showGlow =
            _showOnboardingHints && state.currentScenarioIndex == 0;

        Widget bottle = FloatingAnimation(
          duration: Duration(
            milliseconds: 2000 + (categoryRole is CategoryRoleA ? 0 : 300),
          ),
          offset: 6.0,
          child: BottleWidget(
            key: bottleKey,
            categoryConfig: categoryConfig,
            isGlowing: isHovering,
          ),
        );

        // Wrap with glow effect for first-time users on first scenario
        if (showGlow) {
          bottle = BottleGlowEffect(
            onStart: () {
              // Glow started
            },
            onComplete: () {
              // Glow complete
            },
            child: bottle,
          );
        }

        // Expand hit area for more reliable drop detection on all devices
        // Show visual feedback when user can drop the card
        final isDraggingOver = candidateData.isNotEmpty;
        return Container(
          width: 150, // 30px larger than bottle width (120)
          height: 220, // 40px larger than bottle height (180)
          decoration: isDraggingOver
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: categoryConfig.colorStart.withValues(alpha: 0.5),
                    width: 3,
                  ),
                )
              : null,
          child: Center(child: bottle),
        );
      },
    );
  }

  Widget _buildCompleteState(BuildContext context, GameplayComplete state) {
    return CompletionScreen(session: state.session);
  }
}
