# Implementation Plan: Savoring Game & Multi-Game Architecture

**Branch**: `002-savoring-game` | **Date**: 2025-12-13 | **Spec**: [spec.md](file:///c:/Development/flutter_projects/SpecKit-WorryFear/specs/002-savoring-game/spec.md)
**Input**: Feature specification from `/specs/002-savoring-game/spec.md`

## Summary

This feature adds two major capabilities to the MindGO app:

1. **Welcome Screen** - A game selection screen displaying 2 games as tappable cards
2. **Savoring Choice Game** - A new game mode with fill-in-the-blank sentence completion mechanics using drag-and-drop tiles

The app will be renamed from "WorryFearApp" to "MindGO". The implementation prioritizes code reuse (progress bar, theme, audio, animations) while creating new UI components for the sentence-based gameplay.

**TDD Output Format (per Constitution III)**:

1. First: Output test code
2. Then: Output implementation code that makes tests pass
3. Finally: Brief 2-3 bullet summary of what was tested and implemented

---

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.24+
**Primary Dependencies**: flutter_bloc, equatable, audioplayers, vibration (existing)
**Storage**: SharedPreferences (first-time flag only)
**Testing**: flutter_test, mocktail, bloc_test
**Target Platform**: iOS & Android (mobile)
**Project Type**: Mobile Flutter app
**Performance Goals**: 60fps animations, <100ms drag response
**Constraints**: Portrait mode only, offline-capable, no server
**Scale/Scope**: 2 games, 10 sentence stems per session

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### I. Observability & Debugging ✅

- All new classes/services MUST use `AppLogger` with lazy evaluation
- Logging for: game selection, intro navigation, tile drops, round transitions, completion

### II. Code Documentation Standards ✅

- All new code MUST follow DartDoc format with widget type indicators
- Section dividers for files with 5+ methods
- Inline comments for complex logic (drag-drop, blank locking)

### III. Test-Driven Development (TDD) ✅

- Write tests BEFORE implementation (Red-Green-Refactor)
- Test pyramid: 60-70% unit, 20-30% widget, 10-15% integration
- AAA pattern with inline comments
- Use mocktail for mocking

**Gate Status**: ✅ PASS - No violations

---

## Project Structure

### Documentation (this feature)

```text
specs/002-savoring-game/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── application/         # BLoC state management
│   └── savoring/        # [NEW] Savoring game BLoC
│       ├── savoring_bloc.dart
│       ├── savoring_event.dart
│       └── savoring_state.dart
├── core/
│   ├── theme/           # [REUSE] AppColors, AppTheme
│   └── utils/           # [REUSE] AppLogger
├── domain/
│   ├── models/          # Game models
│   │   ├── game_config.dart  # [MODIFY] Add gameType field
│   │   ├── savoring_config.dart    # [NEW] Savoring game config model
│   │   ├── sentence_stem.dart      # [NEW] Sentence stem model
│   │   └── word_tile.dart          # [NEW] Word tile model
│   └── services/
│       ├── game_config_loader.dart # [MODIFY] Support multiple configs
│       └── savoring_config_loader.dart # [NEW] Savoring-specific loader
├── main.dart            # [MODIFY] Rename to MindGO, add routes
└── presentation/
    ├── animations/      # [REUSE] FloatingAnimation, etc.
    ├── screens/
    │   ├── welcome_screen.dart           # [NEW] Game selection screen
    │   ├── savoring_intro_screen.dart    # [NEW] Savoring intro
    │   ├── savoring_gameplay_screen.dart # [NEW] Savoring gameplay
    │   └── savoring_completion_screen.dart  # [NEW] Savoring completion
    └── widgets/
        ├── progress_bar.dart      # [REUSE] No changes needed
        ├── expandable_section.dart # [REUSE] No changes needed
        ├── game_card.dart         # [NEW] Welcome screen card widget
        ├── sentence_display.dart  # [NEW] Sentence with blanks
        ├── word_tile_widget.dart  # [NEW] Draggable word tile
        ├── blank_zone.dart        # [NEW] Drop zone for tiles
        └── character_widget.dart  # [NEW] Character display

assets/
├── configs/
│   ├── good-moments.json    # [EXISTING]
│   ├── worry-vs-fear.json   # [EXISTING]
│   └── savoring.json        # [NEW] Savoring game content
└── images/
    └── savoring/            # [NEW] Character placeholders
        ├── character_idle.png
        ├── character_affirming.png
        └── character_celebration.png

test/
├── unit/
│   └── domain/
│       ├── models/
│       │   ├── sentence_stem_test.dart      # [NEW]
│       │   └── savoring_config_test.dart    # [NEW]
│       └── services/
│           └── savoring_config_loader_test.dart # [NEW]
├── widget/
│   ├── welcome_screen_test.dart         # [NEW]
│   ├── game_card_test.dart              # [NEW]
│   ├── sentence_display_test.dart       # [NEW]
│   ├── word_tile_widget_test.dart       # [NEW]
│   ├── blank_zone_test.dart             # [NEW]
│   └── savoring_gameplay_test.dart      # [NEW]
└── integration/
    └── savoring_flow_test.dart          # [NEW]
```

**Structure Decision**: Follows existing Clean Architecture (Presentation → Application → Domain → Data). New savoring game components parallel existing game structure.

---

## Proposed Changes

### Phase 1: Welcome Screen & App Renaming

#### [MODIFY] [main.dart](file:///c:/Development/flutter_projects/SpecKit-WorryFear/lib/main.dart)

- Rename `WorryFearApp` to `MindGOApp`
- Change `initialRoute` from `/` to `/welcome`
- Add routes: `/welcome`, `/good-moments/intro`, `/savoring/intro`, `/savoring/gameplay`, `/savoring/completion`

#### [NEW] `lib/presentation/screens/welcome_screen.dart`

- Display 2 `GameCard` widgets in a centered column/row
- Tapping navigates to respective game intro screens
- Match existing app aesthetic (AppColors, padding, fonts)

#### [NEW] `lib/presentation/widgets/game_card.dart`

- Tappable card with title, subtitle, icon/image
- Consistent styling with app theme

---

### Phase 2: Savoring Game Config & Models

#### [NEW] `lib/domain/models/sentence_stem.dart`

- `id`, `templateText`, `blanks` (list of `BlankConfig`)
- `correctFeedback`, `incorrectFeedback` per blank

#### [NEW] `lib/domain/models/savoring_config.dart`

- `gameId`, `version`, `intro` (SavoringIntroConfig), `stems`, `character`

#### [NEW] `assets/configs/savoring.json`

- 10 sentence stems from spec (4 single-blank, 6 double-blank)
- All feedback messages

---

### Phase 3: Savoring UI Components

#### [NEW] `lib/presentation/widgets/sentence_display.dart`

- Render sentence with underlined blanks
- Support numbered blanks {1} and {2}
- Accept dropped tiles and display filled words

#### [NEW] `lib/presentation/widgets/word_tile_widget.dart`

- Draggable widget using `Draggable<WordTile>`
- Glow effect for first-time hint
- Visual feedback during drag

#### [NEW] `lib/presentation/widgets/blank_zone.dart`

- `DragTarget<WordTile>` for each blank
- Locked/dimmed state for Blank 2
- Highlight on hover

#### [NEW] `lib/presentation/widgets/character_widget.dart`

- Display character images (idle, affirming, celebration)
- Subtle breathing animation
- Crossfade between states

---

### Phase 4: Savoring Gameplay BLoC & Screens

#### [NEW] `lib/application/savoring/savoring_bloc.dart`

- Events: `StartGame`, `TileDropped`, `AdvanceRound`
- States: `SavoringInitial`, `RoundActive`, `FeedbackShowing`, `GameComplete`
- Track current stem, filled blanks, round number

#### [NEW] `lib/presentation/screens/savoring_gameplay_screen.dart`

- Compose: ProgressBar, CharacterWidget, SentenceDisplay, WordTileWidgets
- Connect to SavoringBloc
- Handle transitions and feedback display

---

## Verification Plan

### Existing Tests to Verify Reused Components

These tests ensure reused widgets still work correctly:

```bash
# Run all existing widget tests
flutter test test/widget/

# Specific reused component tests
flutter test test/widget/progress_bar_test.dart
flutter test test/widget/intro_screen_test.dart
flutter test test/widget/completion_screen_test.dart
```

### New Unit Tests (TDD - write first)

| Test File | What It Tests | Command |
|-----------|---------------|---------|
| `test/unit/domain/models/sentence_stem_test.dart` | SentenceStem parsing, blank count validation | `flutter test test/unit/domain/models/sentence_stem_test.dart` |
| `test/unit/domain/models/savoring_config_test.dart` | SavoringConfig JSON parsing, validation | `flutter test test/unit/domain/models/savoring_config_test.dart` |
| `test/unit/domain/services/savoring_config_loader_test.dart` | Config file loading, error handling | `flutter test test/unit/domain/services/savoring_config_loader_test.dart` |
| `test/unit/application/savoring_bloc_test.dart` | BLoC state transitions, tile drop logic, round advancement | `flutter test test/unit/application/savoring_bloc_test.dart` |

### New Widget Tests (TDD - write first)

| Test File | What It Tests | Command |
|-----------|---------------|---------|
| `test/widget/welcome_screen_test.dart` | 2 game cards displayed, tap navigation | `flutter test test/widget/welcome_screen_test.dart` |
| `test/widget/game_card_test.dart` | Card rendering, tap callback | `flutter test test/widget/game_card_test.dart` |
| `test/widget/sentence_display_test.dart` | Blanks render correctly, filled state | `flutter test test/widget/sentence_display_test.dart` |
| `test/widget/word_tile_widget_test.dart` | Drag behavior, glow effect | `flutter test test/widget/word_tile_widget_test.dart` |
| `test/widget/blank_zone_test.dart` | Drop target, locked state | `flutter test test/widget/blank_zone_test.dart` |
| `test/widget/savoring_gameplay_test.dart` | Full screen composition, BLoC integration | `flutter test test/widget/savoring_gameplay_test.dart` |

### Integration Test

```bash
# Test complete savoring game flow
flutter test test/integration/savoring_flow_test.dart
```

### Quality Gates (Run Before PR)

```bash
# All lints pass
flutter analyze

# All tests pass
flutter test

# Documentation check
dart doc --dry-run
```

### Manual Verification (User Requested)

After implementation, please verify on a physical device or emulator:

1. **App Launch**: App shows welcome screen with 2 game cards
2. **Tap "Good Moment"**: Navigates to existing game intro (verify no regression)
3. **Return to welcome**: Complete game, tap Finish → returns to welcome
4. **Tap "Savoring Choice"**: Navigates to savoring intro screen
5. **Start gameplay**: Tap Start, verify sentence displays with blanks
6. **Drag correct tile**: Tile snaps to blank, feedback shows, round advances
7. **Drag incorrect tile**: Tile returns, neutral feedback shows, can retry
8. **First-time glow**: On Round 1, correct tile glows (first-ever play only)
9. **Complete 10 rounds**: Completion screen appears with character and message
10. **Finish**: Returns to welcome screen

---

## Complexity Tracking

> No constitution violations requiring justification.

| Decision | Rationale |
|----------|-----------|
| Separate SavoringBloc vs extending GameBloc | Different game mechanics (sentence completion vs scenario sorting) warrant separate BLoC to avoid conditional complexity |
| New config format for savoring | Sentence stems need different structure (blanks, tile groups) than scenario cards |
