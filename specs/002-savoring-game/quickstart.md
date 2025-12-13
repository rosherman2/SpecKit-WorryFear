# Quickstart: Savoring Game & Multi-Game Architecture

**Feature**: 002-savoring-game
**Date**: 2025-12-13

## Prerequisites

- Flutter SDK 3.24+ installed
- Project dependencies installed: `flutter pub get`
- Existing tests passing: `flutter test`

---

## Key Files to Understand

### Existing (Reuse)

| File | Purpose | Reuse Level |
|------|---------|-------------|
| `lib/presentation/widgets/progress_bar.dart` | Progress indicator | 100% - no changes |
| `lib/presentation/widgets/expandable_section.dart` | Collapsible section | 100% - no changes |
| `lib/core/theme/app_colors.dart` | Color constants | 100% - no changes |
| `lib/core/theme/app_theme.dart` | Theme configuration | 100% - no changes |
| `lib/core/utils/app_logger.dart` | Structured logging | 100% - no changes |
| `lib/domain/services/audio_service.dart` | Sound playback | 100% - no changes |
| `lib/domain/services/haptic_service.dart` | Haptic feedback | 100% - no changes |

### To Create (TDD Order)

1. **Models first** (pure Dart, easy to test):
   - `lib/domain/models/word_tile.dart`
   - `lib/domain/models/sentence_stem.dart`
   - `lib/domain/models/savoring_config.dart`

2. **Services second**:
   - `lib/domain/services/savoring_config_loader.dart`

3. **BLoC third**:
   - `lib/application/savoring/savoring_bloc.dart`
   - `lib/application/savoring/savoring_event.dart`
   - `lib/application/savoring/savoring_state.dart`

4. **Widgets fourth**:
   - `lib/presentation/widgets/game_card.dart`
   - `lib/presentation/widgets/word_tile_widget.dart`
   - `lib/presentation/widgets/blank_zone.dart`
   - `lib/presentation/widgets/sentence_display.dart`
   - `lib/presentation/widgets/character_widget.dart`

5. **Screens last**:
   - `lib/presentation/screens/welcome_screen.dart`
   - `lib/presentation/screens/savoring_intro_screen.dart`
   - `lib/presentation/screens/savoring_gameplay_screen.dart`
   - `lib/presentation/screens/savoring_completion_screen.dart`

---

## TDD Workflow

For each new file, follow this pattern per Constitution Principle III:

```bash
# 1. Create failing test first
# Example: sentence_stem_test.dart

# 2. Run test to verify it fails (RED)
flutter test test/unit/domain/models/sentence_stem_test.dart

# 3. Write implementation (GREEN)
# Edit: lib/domain/models/sentence_stem.dart

# 4. Run test to verify it passes
flutter test test/unit/domain/models/sentence_stem_test.dart

# 5. Refactor if needed (REFACTOR)
# Keep tests passing
```

---

## Development Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget/welcome_screen_test.dart

# Run tests with coverage
flutter test --coverage

# Lint check
flutter analyze

# Documentation check
dart doc --dry-run

# Build for Android (debug)
flutter build apk --debug

# Build for iOS (debug - requires Mac)
flutter build ios --debug
```

---

## Config File Location

New config: `assets/configs/savoring.json`

Add to `pubspec.yaml` assets section (already covered by `assets/configs/` pattern).

---

## Testing the Feature

### Unit Tests (TDD - write first)

```bash
flutter test test/unit/domain/models/sentence_stem_test.dart
flutter test test/unit/domain/models/savoring_config_test.dart
flutter test test/unit/domain/services/savoring_config_loader_test.dart
flutter test test/unit/application/savoring_bloc_test.dart
```

### Widget Tests (TDD - write first)

```bash
flutter test test/widget/welcome_screen_test.dart
flutter test test/widget/game_card_test.dart
flutter test test/widget/sentence_display_test.dart
flutter test test/widget/word_tile_widget_test.dart
flutter test test/widget/blank_zone_test.dart
flutter test test/widget/savoring_gameplay_test.dart
```

### Integration Test

```bash
flutter test test/integration/savoring_flow_test.dart
```

### Manual Smoke Test

1. Run app: `flutter run`
2. Welcome screen shows 2 game cards
3. Tap "Good Moment vs Other Moment" → existing game works
4. Return to welcome, tap "Savoring Choice"
5. Intro screen shows, tap Start
6. Drag tiles to blanks, verify feedback
7. Complete 10 stems, see completion screen
8. Tap Finish → returns to welcome

---

## Key Patterns

### Logging (Constitution I)

```dart
AppLogger.debug('SavoringBloc', 'onTileDropped', 
  () => 'Tile dropped: ${tile.text} on blank ${blankIndex}');
```

### Documentation (Constitution II)

```dart
/// [StatelessWidget] Displays a single draggable word tile.
/// Purpose: Provides visual drag interaction for sentence completion.
class WordTileWidget extends StatelessWidget { ... }
```

### Testing (Constitution III)

```dart
group('SentenceStem', () {
  group('fromJson', () {
    test('should parse single-blank stem correctly', () {
      // Arrange
      final json = {...};
      
      // Act
      final stem = SentenceStem.fromJson(json);
      
      // Assert
      expect(stem.blankCount, equals(1));
    });
  });
});
```
