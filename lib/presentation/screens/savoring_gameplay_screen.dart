import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import '../../application/savoring/savoring_cubit.dart';
import '../../application/savoring/savoring_state.dart';
import '../../domain/models/savoring_config.dart';
import '../../domain/models/word_tile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../widgets/sentence_display.dart';
import '../widgets/word_tile_widget.dart';

/// [StatefulWidget] Savoring game gameplay screen.
/// Purpose: Main game screen where users complete sentence stems.
///
/// Features:
/// - Displays current sentence stem with blanks
/// - Shows 3 word tile options for dragging
/// - Handles correct/incorrect feedback
/// - Auto-advances after 1.5s on correct answer
/// - Haptic and audio feedback
/// - Round counter and score display
class SavoringGameplayScreen extends StatefulWidget {
  /// Creates a savoring gameplay screen.
  const SavoringGameplayScreen({required this.savoringConfig, super.key});

  /// The savoring game configuration.
  final SavoringConfig savoringConfig;

  @override
  State<SavoringGameplayScreen> createState() => _SavoringGameplayScreenState();
}

class _SavoringGameplayScreenState extends State<SavoringGameplayScreen> {
  Timer? _autoAdvanceTimer;

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _handleTileDrop(BuildContext context, int blankIndex, WordTile tile) {
    AppLogger.info(
      'SavoringGameplayScreen',
      '_handleTileDrop',
      () => 'Tile dropped: "${tile.text}" on blank $blankIndex',
    );

    // Haptic feedback
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        if (tile.isCorrect) {
          Vibration.vibrate(duration: 50);
        } else {
          Vibration.vibrate(pattern: [0, 50, 50, 50]);
        }
      }
    });

    // TODO: Add audio feedback when AudioService is injected via DI
    // Audio feedback will be added in a future task

    // Update cubit state
    context.read<SavoringCubit>().dropTile(blankIndex: blankIndex, tile: tile);
  }

  void _scheduleAutoAdvance(BuildContext context, SavoringPlaying state) {
    _autoAdvanceTimer?.cancel();

    if (state.isRoundComplete) {
      AppLogger.debug(
        'SavoringGameplayScreen',
        '_scheduleAutoAdvance',
        () => 'Scheduling auto-advance in 1.5s',
      );

      _autoAdvanceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.read<SavoringCubit>().advanceRound();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SavoringCubit(config: widget.savoringConfig)..startGame(),
      child: BlocConsumer<SavoringCubit, SavoringState>(
        listener: (context, state) {
          if (state is SavoringPlaying && state.isRoundComplete) {
            _scheduleAutoAdvance(context, state);
          } else if (state is SavoringCompleted) {
            _autoAdvanceTimer?.cancel();
            // Navigate to completion screen
            Navigator.pushReplacementNamed(
              context,
              '/savoring/completion',
              arguments: state,
            );
          }
        },
        builder: (context, state) {
          if (state is SavoringInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is SavoringPlaying) {
            return _buildGameplayScreen(context, state);
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildGameplayScreen(BuildContext context, SavoringPlaying state) {
    final currentBlank = state.currentStem.blanks.firstWhere(
      (b) => b.index == state.activeBlankIndex,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Round ${state.currentRound}/${state.totalRounds}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${state.score} pts',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Character placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 32),

              // Sentence display
              Expanded(
                flex: 2,
                child: Center(
                  child: SentenceDisplay(
                    stem: state.currentStem,
                    filledTiles: state.filledTiles,
                    blankStates: state.blankStates,
                    lockedBlanks: state.lockedBlanks,
                    onTileDropped: (index, tile) =>
                        _handleTileDrop(context, index, tile),
                  ),
                ),
              ),

              // Feedback message
              if (state.feedbackMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: state.isCurrentBlankCorrect == true
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.feedbackMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: state.isCurrentBlankCorrect == true
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Word tiles
              if (!state.isRoundComplete)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: currentBlank.tiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tile = entry.value;
                    final isUsed = state.filledTiles.values.any(
                      (t) => t.text == tile.text,
                    );

                    return WordTileWidget(tile: tile, isEnabled: !isUsed);
                  }).toList(),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
