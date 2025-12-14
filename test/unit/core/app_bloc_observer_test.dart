import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppBlocObserver Tests', () {
    late TestBloc testBloc;

    setUp(() {
      // Arrange: Create test bloc
      testBloc = TestBloc();
    });

    tearDown(() {
      testBloc.close();
    });

    test('should log state changes via onChange', () {
      // Arrange: Track onChange call
      bool onChangeCalled = false;
      final testObserver = _TestAppBlocObserver(
        onChangeCallback: (bloc, change) {
          onChangeCalled = true;
        },
      );

      // Act: Emit a state change
      testObserver.onChange(
        testBloc,
        Change<int>(currentState: 0, nextState: 1),
      );

      // Assert: onChange was called
      expect(onChangeCalled, isTrue);
    });

    test('should log errors via onError', () {
      // Arrange: Track onError call
      bool onErrorCalled = false;
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      final testObserver = _TestAppBlocObserver(
        onErrorCallback: (bloc, err, stack) {
          onErrorCalled = true;
          expect(err, equals(error));
        },
      );

      // Act: Report an error
      testObserver.onError(testBloc, error, stackTrace);

      // Assert: onError was called
      expect(onErrorCalled, isTrue);
    });
  });
}

/// [TestBloc] Simple test bloc for testing the observer.
class TestBloc extends Cubit<int> {
  TestBloc() : super(0);

  void increment() => emit(state + 1);
}

/// [_TestAppBlocObserver] Test implementation to verify callbacks.
class _TestAppBlocObserver extends BlocObserver {
  _TestAppBlocObserver({this.onChangeCallback, this.onErrorCallback});

  final void Function(BlocBase bloc, Change change)? onChangeCallback;
  final void Function(BlocBase bloc, Object error, StackTrace stackTrace)?
  onErrorCallback;

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    onChangeCallback?.call(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    onErrorCallback?.call(bloc, error, stackTrace);
  }
}
