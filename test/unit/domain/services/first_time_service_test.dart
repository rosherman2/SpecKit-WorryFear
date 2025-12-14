import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worry_fear_game/domain/services/first_time_service.dart';

void main() {
  group('FirstTimeService Tests', () {
    late FirstTimeService service;

    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = FirstTimeService(prefs);
    });

    test('should return true for first time savoring game', () async {
      // Act
      final isFirstTime = await service.isFirstTimeSavoringGame();

      // Assert
      expect(isFirstTime, isTrue);
    });

    test('should return false after marking as completed', () async {
      // Arrange
      await service.markSavoringGameCompleted();

      // Act
      final isFirstTime = await service.isFirstTimeSavoringGame();

      // Assert
      expect(isFirstTime, isFalse);
    });

    test('should persist completion across service instances', () async {
      // Arrange: Mark as completed
      await service.markSavoringGameCompleted();

      // Act: Create new service instance
      final prefs = await SharedPreferences.getInstance();
      final newService = FirstTimeService(prefs);
      final isFirstTime = await newService.isFirstTimeSavoringGame();

      // Assert
      expect(isFirstTime, isFalse);
    });

    test('should use correct SharedPreferences key', () async {
      // Arrange
      await service.markSavoringGameCompleted();

      // Act
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool('first_time_savoring_game_complete');

      // Assert
      expect(value, isTrue);
    });
  });
}
