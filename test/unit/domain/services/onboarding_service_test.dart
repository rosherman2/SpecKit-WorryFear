import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worry_fear_game/domain/services/onboarding_service.dart';

void main() {
  group('OnboardingService', () {
    late OnboardingService service;

    setUp(() async {
      // Clear all shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = OnboardingService(prefs);
    });

    test('isFirstTime returns true on first launch', () async {
      final isFirst = await service.isFirstTime();
      expect(isFirst, true);
    });

    test('isFirstTime returns false after marking complete', () async {
      // First time should be true
      expect(await service.isFirstTime(), true);

      // Mark as complete
      await service.markOnboardingComplete();

      // Now should be false
      expect(await service.isFirstTime(), false);
    });

    test('markOnboardingComplete persists across service instances', () async {
      // Mark complete with first instance
      await service.markOnboardingComplete();

      // Create new instance (simulates app restart)
      final prefs = await SharedPreferences.getInstance();
      final newService = OnboardingService(prefs);

      // Should still be marked as complete
      expect(await newService.isFirstTime(), false);
    });

    test('multiple calls to isFirstTime return consistent results', () async {
      // Before marking complete
      expect(await service.isFirstTime(), true);
      expect(await service.isFirstTime(), true);

      // After marking complete
      await service.markOnboardingComplete();
      expect(await service.isFirstTime(), false);
      expect(await service.isFirstTime(), false);
    });

    test(
      'markOnboardingComplete can be called multiple times safely',
      () async {
        await service.markOnboardingComplete();
        await service.markOnboardingComplete();
        await service.markOnboardingComplete();

        expect(await service.isFirstTime(), false);
      },
    );
  });
}
