# Quickstart: Worry vs Fear Game

**Feature**: 001-worry-fear-game
**Date**: 2025-12-09

## Prerequisites

- Flutter 3.24+ installed (`flutter --version`)
- iOS Simulator or Android Emulator configured
- VS Code or Android Studio with Flutter plugin

## Setup

```bash
# Clone and navigate to project
cd SpecKit-WorryFear

# Get dependencies
flutter pub get

# Verify setup
flutter doctor
```

## Running the App

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices               # List available devices
flutter run -d <device_id>    # Run on specific device
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/domain/scenario_test.dart

# Run tests matching pattern
flutter test --name "should"
```

## Verification Commands

```bash
# Verify code quality (constitution gate)
flutter analyze

# Verify documentation
dart doc

# Full test suite
flutter test

# Check formatting
dart format --set-exit-if-changed .
```

## Development Workflow (TDD)

Per constitution, follow this order for each feature:

1. **Write failing test** (`flutter test` → RED)
2. **Implement code** (`flutter test` → GREEN)
3. **Refactor** (improve naming, extract methods)
4. **Commit** with summary of what was tested and implemented

## File Locations

| Purpose | Path |
|---------|------|
| App entry | `lib/main.dart` |
| Logger utility | `lib/core/utils/app_logger.dart` |
| Domain models | `lib/domain/models/` |
| BLoCs | `lib/application/` |
| UI screens | `lib/presentation/screens/` |
| Unit tests | `test/unit/` |
| Widget tests | `test/widget/` |
| Integration tests | `test/integration/` |

## Logging in Development

```dart
// All logging uses lazy evaluation (zero production cost)
AppLogger.debug('ClassName', 'methodName', () => 'message');
AppLogger.info('ClassName', 'methodName', () => 'state changed');
AppLogger.warning('ClassName', 'methodName', () => 'edge case');
AppLogger.error('ClassName', 'methodName', () => 'failure');
```

## Common Tasks

### Add a new scenario

1. Add to `lib/domain/data/scenarios.dart`
2. Update tests in `test/unit/domain/scenario_service_test.dart`

### Add a new animation

1. Create widget in `lib/presentation/animations/`
2. Add widget test in `test/widget/`
3. Document with DartDoc per constitution

### Run on physical device

```bash
# iOS
flutter run --release

# Android
flutter run --release
```
