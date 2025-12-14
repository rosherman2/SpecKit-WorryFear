import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worry_fear_game/core/utils/app_logger.dart';

/// [BlocObserver] Global observer for all BLoCs/Cubits in the application.
/// Purpose: Provides centralized debugging and logging for state changes and errors.
///
/// This observer logs all state transitions and errors across all BLoCs in the app,
/// making it easier to debug state management issues during development.
///
/// Registered in main.dart (debug mode only):
/// ```dart
/// if (kDebugMode) {
///   Bloc.observer = AppBlocObserver();
/// }
/// ```
///
/// Per Constitution I, all logging uses AppLogger with lazy evaluation.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    // Log state changes with lazy evaluation
    AppLogger.debug(
      'AppBlocObserver',
      'onChange',
      () =>
          '${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // Log errors with lazy evaluation
    AppLogger.error(
      'AppBlocObserver',
      'onError',
      () => '${bloc.runtimeType}: $error\n$stackTrace',
    );
  }
}
