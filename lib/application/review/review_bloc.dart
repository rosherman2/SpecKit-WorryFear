import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/audio/audio_service.dart';
import '../../core/haptic/haptic_service.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/models/category.dart';
import 'review_event.dart';
import 'review_state.dart';

/// [BLoC] Manages review mode logic and state.
/// Purpose: Handles review session flow, answer validation, and auto-correction.
///
/// Review mode allows users to retry scenarios they got wrong. After two
/// incorrect attempts, the system shows the correct answer with educational
/// text for 1.5 seconds before auto-advancing.
///
/// Example:
/// ```dart
/// final bloc = ReviewBloc(
///   audioService: audioService,
///   hapticService: hapticService,
/// );
/// bloc.add(ReviewStarted(incorrectScenarios));
/// ```
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  /// Creates a review BLoC.
  ReviewBloc({required this.audioService, required this.hapticService})
    : super(const ReviewInitial()) {
    on<ReviewStarted>(_onReviewStarted);
    on<AnswerAttempted>(_onAnswerAttempted);
    on<AutoCorrectionComplete>(_onAutoCorrectionComplete);
    on<NextReviewItem>(_onNextReviewItem);
  }

  /// Audio service for sound effects.
  final AudioService audioService;

  /// Haptic service for tactile feedback.
  final HapticService hapticService;

  /// Handles review session start.
  void _onReviewStarted(ReviewStarted event, Emitter<ReviewState> emit) {
    AppLogger.info(
      'ReviewBloc',
      '_onReviewStarted',
      () => 'Starting review with ${event.reviewScenarios.length} scenarios',
    );
    emit(ReviewPlaying(event.reviewScenarios));
  }

  /// Handles answer attempts with auto-correction logic.
  Future<void> _onAnswerAttempted(
    AnswerAttempted event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewPlaying) return;

    final playingState = state as ReviewPlaying;
    final currentScenario = playingState.currentScenario;
    final isCorrect =
        currentScenario.scenario.correctCategory == event.category;

    if (isCorrect) {
      // Correct answer
      AppLogger.info(
        'ReviewBloc',
        '_onAnswerAttempted',
        () =>
            'Correct answer for review scenario ${playingState.currentIndex + 1}',
      );
      await audioService.playSuccess();
      emit(const ReviewCorrectFeedback());

      // Wait for success animation
      await Future.delayed(const Duration(milliseconds: 900));

      // Check if review complete
      if (playingState.currentIndex >=
          playingState.reviewScenarios.length - 1) {
        emit(const ReviewComplete());
      } else {
        // Advance to next review scenario
        emit(
          ReviewPlaying(
            playingState.reviewScenarios,
            currentIndex: playingState.currentIndex + 1,
            attemptCount: 0,
          ),
        );
      }
    } else {
      // Incorrect answer
      AppLogger.info(
        'ReviewBloc',
        '_onAnswerAttempted',
        () => 'Incorrect answer, attempt ${playingState.attemptCount + 1}',
      );
      await audioService.playError();
      await hapticService.mediumImpact();
      emit(const ReviewIncorrectFeedback());

      // Wait for error feedback
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check attempt count
      if (playingState.attemptCount >= 1) {
        // Second failure - trigger auto-correction
        final correctCategory = currentScenario.scenario.correctCategory;
        final educationalText = _getEducationalText(correctCategory);

        AppLogger.info(
          'ReviewBloc',
          '_onAnswerAttempted',
          () =>
              'Auto-correction triggered for category: ${correctCategory.name}',
        );

        emit(
          ReviewAutoCorrection(
            correctCategory: correctCategory.toString().split('.').last,
            educationalText: educationalText,
          ),
        );

        // Wait 1.5s for user to read
        await Future.delayed(const Duration(milliseconds: 1500));

        // Auto-advance to next scenario
        if (playingState.currentIndex >=
            playingState.reviewScenarios.length - 1) {
          emit(const ReviewComplete());
        } else {
          emit(
            ReviewPlaying(
              playingState.reviewScenarios,
              currentIndex: playingState.currentIndex + 1,
              attemptCount: 0,
            ),
          );
        }
      } else {
        // First failure - allow retry
        emit(
          ReviewPlaying(
            playingState.reviewScenarios,
            currentIndex: playingState.currentIndex,
            attemptCount: playingState.attemptCount + 1,
          ),
        );
      }
    }
  }

  /// Handles auto-correction completion (manual advance).
  void _onAutoCorrectionComplete(
    AutoCorrectionComplete event,
    Emitter<ReviewState> emit,
  ) {
    // This event can be used for manual control if needed
    // Currently auto-correction advances automatically
  }

  /// Handles manual next item request.
  void _onNextReviewItem(NextReviewItem event, Emitter<ReviewState> emit) {
    if (state is! ReviewPlaying) return;

    final playingState = state as ReviewPlaying;
    if (playingState.currentIndex >= playingState.reviewScenarios.length - 1) {
      emit(const ReviewComplete());
    } else {
      emit(
        ReviewPlaying(
          playingState.reviewScenarios,
          currentIndex: playingState.currentIndex + 1,
          attemptCount: 0,
        ),
      );
    }
  }

  /// Gets educational text for a category.
  String _getEducationalText(Category category) {
    switch (category) {
      case Category.fear:
        return 'Fear is about immediate danger or threats happening right now.';
      case Category.worry:
        return 'Worry is about future possibilities and "what-if" scenarios.';
    }
  }
}
