# Implementation Plan: Worry vs Fear Cognitive Training Game

**Branch**: `001-worry-fear-game` | **Date**: 2025-12-09 | **Spec**: [spec.md](file:///c:/Development/flutter_projects/SpecKit-WorryFear/specs/001-worry-fear-game/spec.md)
**Input**: Feature specification from `/specs/001-worry-fear-game/spec.md`

## Summary

Build a mobile cognitive training game (iOS & Android) that teaches users to distinguish between worry (future-focused "what ifs") and fear (immediate danger) through an engaging drag-and-drop mechanic. Users classify 10 scenario cards per session, receiving instant visual, audio, and haptic feedback. The app includes an intro screen with educational content, gameplay with 3D animated bottles as drop zones, review mode for incorrect answers, and celebration sequences for completion.

**Technical Approach**: Flutter with flutter_bloc for state management, Clean Architecture layers, TDD workflow, AppLogger for debugging. No server/backend required—all game logic runs locally.

---

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.24+
**Primary Dependencies**: flutter_bloc, equatable, audioplayers, vibration
**Storage**: N/A (no persistence required for MVP—fresh start each session)
**Testing**: flutter_test, mocktail, bloc_test, fake_async
**Target Platform**: iOS 12+ and Android 5.0+ (API 21+)
**Project Type**: Mobile (single Flutter project)
**Performance Goals**: 60fps animations, <200ms feedback response, smooth drag gestures
**Constraints**: Offline-only (no network), <100MB app size, production builds strip all logging
**Scale/Scope**: 3 screens (Intro, Gameplay, Completion), 16 scenarios, single-session gameplay

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Requirement | Compliance |
|-----------|-------------|------------|
| **I. Observability & Debugging** | All code uses `AppLogger` with lazy evaluation | ✅ Will implement `lib/core/utils/app_logger.dart` first |
| **I. Observability** | Zero production overhead | ✅ Use `kDebugMode` guards for complete code elimination |
| **II. Documentation Standards** | All classes/methods have DartDoc | ✅ Every public API will be documented with widget type indicators |
| **II. Documentation** | C++/Java developer accessible | ✅ Section dividers, inline comments for Dart idioms |
| **III. TDD** | Tests before implementation | ✅ Red-Green-Refactor cycle for all features |
| **III. TDD** | Testing pyramid (60-70% unit, 20-30% widget, 10-15% integration) | ✅ Unit tests for models/blocs, widget tests for UI, integration for flows |
| **III. TDD** | No DI frameworks, constructor injection only | ✅ All services injected via constructors, wiring in main.dart |
| **III. TDD** | mocktail for mocking | ✅ Will use mocktail for all test dependencies |
| **Architecture** | Clean Architecture layers | ✅ Presentation → Application → Domain → Data |

**Gate Status**: ✅ All checks pass. Proceeding to Phase 0.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-worry-fear-game/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/          # Quality checklists
└── tasks.md             # Phase 2 output (via /speckit.tasks)
```

### Source Code (Flutter Mobile)

```text
lib/
├── main.dart                          # App entry, DI wiring, AppLogger init
├── app.dart                           # MaterialApp, routing
│
├── core/                              # Shared infrastructure
│   ├── utils/
│   │   └── app_logger.dart            # Structured logging utility
│   ├── theme/
│   │   ├── app_theme.dart             # Color palette, typography
│   │   └── app_colors.dart            # Fear/Worry/Success/Error colors
│   ├── constants/
│   │   └── animation_durations.dart   # Timing constants
│   └── audio/
│       └── audio_service.dart         # Sound playback service
│
├── domain/                            # Business logic (pure Dart)
│   ├── models/
│   │   ├── scenario.dart              # Scenario entity
│   │   ├── category.dart              # Fear/Worry enum
│   │   └── session.dart               # Game session state
│   └── services/
│       └── scenario_service.dart      # Scenario selection logic
│
├── application/                       # State management (BLoCs)
│   ├── intro/
│   │   └── intro_cubit.dart           # Intro screen state
│   ├── gameplay/
│   │   ├── gameplay_bloc.dart         # Main game logic
│   │   ├── gameplay_event.dart
│   │   └── gameplay_state.dart
│   └── review/
│       └── review_bloc.dart           # Review mode logic
│
└── presentation/                      # UI (Widgets)
    ├── screens/
    │   ├── intro_screen.dart          # Intro with bottles, Start button
    │   ├── gameplay_screen.dart       # Drag-drop gameplay
    │   └── completion_screen.dart     # Final celebration
    ├── widgets/
    │   ├── bottle_widget.dart         # 3D animated bottle
    │   ├── scenario_card.dart         # Draggable card
    │   ├── progress_bar.dart          # Session progress
    │   ├── success_animation.dart     # Random celebration effects
    │   └── expandable_section.dart    # Scientific background
    └── animations/
        ├── floating_animation.dart    # Bottle float effect
        └── spring_animation.dart      # Card snap animation

test/
├── unit/                              # 60-70% of tests
│   ├── domain/
│   │   ├── scenario_test.dart
│   │   ├── session_test.dart
│   │   └── scenario_service_test.dart
│   └── application/
│       ├── gameplay_bloc_test.dart
│       └── review_bloc_test.dart
├── widget/                            # 20-30% of tests
│   ├── bottle_widget_test.dart
│   ├── scenario_card_test.dart
│   └── intro_screen_test.dart
├── integration/                       # 10-15% of tests
│   └── gameplay_flow_test.dart
└── support/
    └── test_factories.dart            # Shared test builders
```

**Structure Decision**: Single Flutter project with Clean Architecture layers. Domain layer is pure Dart with no Flutter dependencies, enabling easy unit testing. Application layer uses flutter_bloc for state management. Presentation layer contains all UI widgets.

---

## Complexity Tracking

> **No violations requiring justification.** All decisions follow constitution guidelines.

---

## Implementation Output Format

Per constitution (Principle III - TDD), all feature implementation MUST follow this format:

1. **First**: Output the test code you are adding/changing
2. **Then**: Output the implementation code that makes tests pass
3. **Finally**: Brief 2-3 bullet summary of:
   - What behaviors were tested
   - What code was implemented or refactored
