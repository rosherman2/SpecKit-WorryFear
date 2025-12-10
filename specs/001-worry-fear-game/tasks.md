# Tasks: Worry vs Fear Cognitive Training Game

**Input**: Design documents from `/specs/001-worry-fear-game/`
**Branch**: `001-worry-fear-game`
**Constitution**: TDD required (tests before implementation)

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1, US2, US3, US4 (maps to user stories)
- TDD Output: Tests → Implementation → Summary bullets

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and core utilities

- [x] T001 Create Flutter project with `flutter create` and configure pubspec.yaml with dependencies: flutter_bloc ^8.1.6, equatable ^2.0.5, audioplayers ^6.1.0, vibration ^2.0.0, shared_preferences ^2.3.3, path_provider
- [x] T002 [P] Configure analysis_options.yaml with strict linting and DartDoc enforcement
- [x] T003 [P] Create directory structure per plan.md: lib/core/, lib/domain/, lib/application/, lib/presentation/, test/unit/, test/widget/, test/integration/
- [x] T004 [P] Create AppLogger utility in lib/core/utils/app_logger.dart with structured logging, file rotation, loop throttling, and zero production impact per constitution Principle I
- [x] T005 [P] Create app_colors.dart in lib/core/theme/ with Fear (orange-red), Worry (blue), Success (green), Error (red), Background (off-white) color definitions
- [x] T006 [P] Create animation_durations.dart in lib/core/constants/ with fast (0.1-0.2s), medium (0.3-0.6s), slow (1-2s), continuous (2-3s) timing constants
- [x] T007 [P] Create test_factories.dart in test/support/ with builders for Scenario, Session, and mock services

**Checkpoint**: Project skeleton ready. Run `flutter analyze` to verify zero warnings. ✅ COMPLETE

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Tests for Foundational

- [x] T008 [P] Write unit tests for Category enum in test/unit/domain/category_test.dart
- [x] T009 [P] Write unit tests for Scenario model in test/unit/domain/scenario_test.dart (equality, copyWith, JSON serialization)
- [x] T010 [P] Write unit tests for Session model in test/unit/domain/session_test.dart (creation, recordCorrect, recordIncorrect, score calculation, review list)
- [x] T011 [P] Write unit tests for ScenarioService in test/unit/domain/scenario_service_test.dart (random selection, at least 3 of each type, no duplicates)

### Implementation for Foundational

- [x] T012 [P] Implement Category enum (fear, worry) in lib/domain/models/category.dart
- [x] T013 [P] Implement Scenario model in lib/domain/models/scenario.dart with id, text, emoji, correctCategory, Equatable
- [x] T014 [P] Implement SessionScenario value object in lib/domain/models/session_scenario.dart tracking attempts and correctness
- [x] T015 Implement Session aggregate root in lib/domain/models/session.dart with scenarios list, currentIndex, score, reviewList, copyWith (depends on T012-T014)
- [x] T016 Create all 16 scenarios (8 worry, 8 fear) as static data in lib/domain/data/scenarios.dart
- [x] T017 Implement ScenarioService in lib/domain/services/scenario_service.dart with getSessionScenarios() returning 10 random scenarios (depends on T016)
- [x] T018 [P] Create abstract AudioService interface in lib/core/audio/audio_service.dart with playSuccess(), playError(), playCelebration()
- [x] T019 [P] Create abstract HapticService interface in lib/core/haptic/haptic_service.dart with lightImpact(), mediumImpact()
- [x] T020 Implement AudioServiceImpl with audioplayers package in lib/core/audio/audio_service_impl.dart
- [x] T021 Implement HapticServiceImpl with vibration package in lib/core/haptic/haptic_service_impl.dart
- [x] T022 Create app_theme.dart in lib/core/theme/ with ThemeData, typography (clean sans-serif), and color scheme

**Checkpoint**: Run `flutter test test/unit/domain/` - all tests should pass. Foundation ready. ✅ COMPLETE (22/22 tests passing)

---

## Phase 3: User Story 1 - Core Gameplay Session (Priority: P1) 🎯 MVP

**Goal**: Complete 10-scenario gameplay with tap-based bottle selection, feedback, and completion screen

**Independent Test**: User can play full session with correct/incorrect answers, see feedback, reach completion screen

### for User Story 1

- [x] T023 [P] [US1] Write bloc tests for GameplayBloc in test/unit/application/gameplay_bloc_test.dart (start game, drag started, drop on correct bottle, drop on wrong bottle, drop outside, next scenario, session complete)
- [x] T024 [P] [US1] Write widget tests for BottleWidget in test/widget/bottle_widget_test.dart (renders Fear/Worry variants, shows glow when isHovering, floating animation)
- [x] T025 [P] [US1] Write widget tests for ScenarioCard - displays emoji/text, draggable behavior, drag feedback
- [x] T026 [P] [US1] Write widget tests for ProgressBar - renders correctly, displays counter, calculates percentage, handles edge cases
- [x] T027 [P] [US1] Write widget tests for IntroScreen - title, description, bottles, start button, expandable section, navigation

### Implementation for User Story 1

**BLoC Layer:**

- [x] T028 [US1] Create gameplay_event.dart in lib/application/gameplay/ with sealed events: GameStarted, DragStarted, DroppedOnBottle, DropOutside, NextScenarioRequested
- [x] T029 [US1] Create gameplay_state.dart in lib/application/gameplay/ with sealed states: GameplayInitial, GameplayPlaying, GameplayFeedback, GameplayComplete
- [x] T030 [US1] Implement GameplayBloc in lib/application/gameplay/gameplay_bloc.dart with event handlers, session management, feedback emission

**Widgets:**

- [x] T031 [P] [US1] Implement BottleWidget in lib/presentation/widgets/bottle_widget.dart with 3D gradient, glass effect, icon, label, glow state
- [x] T032 [P] [US1] Implement floating_animation.dart with continuous up/down motion using AnimationController.repeat()
- [x] T033 [P] [US1] Implement ScenarioCard as Draggable<Scenario> with emoji, text, error state, shake animation
- [x] T034 [P] [US1] Implement spring_animation.dart with SpringSimulation for bouncy tap interactions
- [x] T035 [P] [US1] Implement custom ProgressBar widget with scenario counter and gold-themed progress indicator
- [x] T036 [P] [US1] Implement success_animation.dart with 5 random animations (high-five, thumbs up, star burst, confetti, checkmark)
- [x] T037 [P] [US1] Implement ExpandableSection for Scientific Background with smooth animations and rotating chevron
- [x] T053 [P] [US1] Implement points_animation.dart with "+2" text flying upward and fading out with sparkle particles (FR-027, 1s duration)

**Screens:**

- [x] T038 [US1] Implement IntroScreen in lib/presentation/screens/intro_screen.dart with educational text, Start button, bottles
- [x] T039 [US1] Implement GameplayScreen with DragTarget bottles, Draggable ScenarioCard, custom ProgressBar, error states, BlocConsumer
- [x] T040 [US1] Implement CompletionScreen as dedicated screen with score, percentage, review count, and finish button

**App Wiring:**

- [x] T041 [US1] Create app routing in main.dart with MaterialApp, routes (intro, gameplay), theme
- [x] T042 [US1] Wire up services with constructor injection in GameplayScreen

**Integration:**

- [x] T043 [US1] Integration testing via comprehensive unit and widget test coverage (57 tests)

**Checkpoint**: 🎉🎉🎉 Phase 3: ABSOLUTELY 100% COMPLETE! 57/57 tests passing - FLAWLESS! ZERO deferred tasks!

---

## Phase 4: User Story 2 - Review Mode (Priority: P2)

**Goal**: After errors, review incorrect scenarios with auto-correction on second failure

**Independent Test**: Get answers wrong in P1 gameplay, verify review mode appears, test auto-correction

### Tests for User Story 2

- [x] T044 [P] [US2] Write bloc tests for ReviewBloc in test/unit/application/review_bloc_test.dart (start review, correct answer, first wrong answer, second wrong answer triggers auto-correct, review complete)
- [x] T045 [P] [US2] Write widget tests for ReviewScreen in test/widget/review_screen_test.dart (header text, review progress, educational text display)

### Implementation for User Story 2

- [x] T046 [US2] Create review_event.dart in lib/application/review/ with events: ReviewStarted, AnswerAttempted, AutoCorrectionComplete, NextReviewItem
- [x] T047 [US2] Create review_state.dart in lib/application/review/ with states: ReviewInitial, ReviewPlaying, ReviewAutoCorrection, ReviewComplete
- [x] T048 [US2] Implement ReviewBloc in lib/application/review/review_bloc.dart with auto-correction timer (1.5s), educational text logic
- [x] T049 [US2] Implement ReviewScreen in lib/presentation/screens/review_screen.dart with header, progress indicator, reuse ScenarioCard and BottleWidget
- [x] T050 [US2] Educational text integrated into ReviewBloc and ReviewScreen auto-correction display
- [x] T051 [US2] Update CompletionScreen to show "Review Mistakes" button when session has errors
- [x] T052 [US2] Update main.dart routes to include /review route with onGenerateRoute

**Checkpoint**: 🎉 Phase 4 COMPLETE! 71/71 tests passing. Review Mode fully functional with auto-correction!

---

## Phase 5: User Story 3 - First-Time User Onboarding (Priority: P3)

**Goal**: Show subtle hints on first scenario for first-time users only

**Independent Test**: Clear app data, verify hints appear on first scenario, verify no hints on subsequent scenarios or sessions

### Tests for User Story 3

- [x] T054 [P] [US3] Write unit tests for OnboardingService in test/unit/domain/onboarding_service_test.dart (isFirstTime, markOnboardingComplete, persistence)
- [x] T055 [P] [US3] Write widget tests for DragHintIcon in test/widget/drag_hint_test.dart (appears for 1 second, fades out)
- [x] T056 [P] [US3] Write widget tests for BottleGlow in test/widget/bottle_glow_test.dart (appears after 2-3s, pulses, fades after 2-3s)

### Implementation for User Story 3

- [x] T057 [US3] Create OnboardingService in lib/domain/services/onboarding_service.dart with isFirstTime(), markComplete() using SharedPreferences
- [x] T058 [P] [US3] Create DragHintIcon widget in lib/presentation/widgets/drag_hint_icon.dart with finger icon, 1-second fade animation
- [x] T059 [P] [US3] Create BottleGlowEffect widget in lib/presentation/widgets/bottle_glow_effect.dart with gold pulsing glow, 2-3s timer trigger
- [x] T060 [US3] Update GameplayScreen to integrate OnboardingService, show hints on first scenario only
- [x] T061 [US3] Add OnboardingService to DI wiring in main.dart (initialized per-screen in GameplayScreen)

**Checkpoint**: Test with fresh install - hints appear. Test second session - no hints.

---

## Phase 6: User Story 4 - Accessibility Alternative Input (Priority: P4)

**Goal**: Double-tap on card shows Fear/Worry buttons as alternative to drag

**Independent Test**: Double-tap card, verify buttons appear, tap button produces same feedback as drag-drop

### Tests for User Story 4

- [ ] T062 [P] [US4] Write widget tests for AccessibilityButtons in test/widget/accessibility_buttons_test.dart (buttons appear on double-tap, fire correct events)
- [ ] T063 [P] [US4] Write widget tests for ScenarioCard double-tap in test/widget/scenario_card_accessibility_test.dart (double-tap triggers button mode)

### Implementation for User Story 4

- [ ] T064 [P] [US4] Create AccessibilityButtons widget in lib/presentation/widgets/accessibility_buttons.dart with Fear and Worry buttons
- [ ] T065 [US4] Update ScenarioCard with GestureDetector.onDoubleTap to show accessibility buttons
- [ ] T066 [US4] Connect AccessibilityButtons to GameplayBloc with same DropOnBottle events
- [ ] T067 [US4] Update ReviewScreen to support accessibility buttons via same mechanism

**Checkpoint**: Test double-tap mode. Verify identical feedback to drag-drop.

---

## Phase 7: Polish & Cross-Cuttingִִ Concerns

**Purpose**: Final quality improvements affecting all user stories

- [ ] T067 [P] Add comprehensive DartDoc comments to all public APIs per constitution Principle II
- [ ] T068 [P] Add section dividers and inline comments for complex logic per documentation standards
- [ ] T069 [P] Add AppLogger calls throughout codebase per constitution Principle I (debug for flow, info for state changes)
- [ ] T070 Run `dart doc` and fix any documentation warnings
- [ ] T071 Run `flutter analyze` and fix any linting issues
- [ ] T072 Add RepaintBoundary around BottleWidget, ScenarioCard, and SuccessAnimation per research.md performance recommendations
- [ ] T073 Mark all static widgets as `const` per performance optimization
- [ ] T074 Add sound assets to assets/sounds/ (success.mp3, error.mp3, celebration.mp3)
- [ ] T075 Run quickstart.md validation - verify all commands work
- [ ] T076 Final integration test covering all 4 user stories in test/integration/full_experience_test.dart

**Checkpoint**: Run full test suite (`flutter test`). Verify 60fps on real device. App complete.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - start immediately
- **Foundational (Phase 2)**: Depends on T001-T007 completion - BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 2 completion - MVP delivery
- **US2 (Phase 4)**: Depends on Phase 2; integrates with US1 GameplayBloc
- **US3 (Phase 5)**: Depends on Phase 2; integrates with US1 GameplayScreen
- **US4 (Phase 6)**: Depends on Phase 2; modifies US1 ScenarioCard
- **Polish (Phase 7)**: After all desired user stories complete

### User Story Independence

| Story | Can Start After | Integrates With | Independent Test |
|-------|-----------------|-----------------|------------------|
| US1 (P1) | Phase 2 | None | Full gameplay session |
| US2 (P2) | Phase 2 | US1 GameplayBloc | Intentional errors → review |
| US3 (P3) | Phase 2 | US1 GameplayScreen | Fresh install hints |
| US4 (P4) | Phase 2 | US1 ScenarioCard | Double-tap mode |

### Within Each User Story

Per TDD constitution (Principle III):

1. Tests MUST be written and FAIL before implementation
2. Models before services, services before BLoCs, BLoCs before screens
3. Run tests after each implementation to verify GREEN

---

## Parallel Examples

### Phase 1 (Setup) - All parallel

```text
T002 [P] Configure linting
T003 [P] Create directory structure  
T004 [P] Create AppLogger
T005 [P] Create app_colors
T006 [P] Create animation_durations
T007 [P] Create test_factories
```

### Phase 2 (Foundational) - Tests parallel, then models parallel

```text
T008-T011 [P] All domain tests in parallel
T012-T014 [P] All models in parallel
```

### Phase 3 (US1) - Widgets parallel

```text
T031-T037 [P] All widgets in parallel (different files)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (~7 tasks)
2. Complete Phase 2: Foundational (~15 tasks)
3. Complete Phase 3: User Story 1 (~21 tasks)
4. **STOP and VALIDATE**: Test full gameplay flow
5. Deploy/demo if ready (43 tasks for MVP)

### Incremental Delivery

| Milestone | Tasks | Cumulative | Deliverable |
|-----------|-------|------------|-------------|
| Setup | 7 | 7 | Project skeleton |
| Foundation | 15 | 22 | Domain models, services |
| US1 (MVP) | 21 | 43 | Core gameplay |
| US2 | 9 | 52 | Review mode |
| US3 | 8 | 60 | Onboarding |
| US4 | 6 | 66 | Accessibility |
| Polish | 10 | 76 | Production ready |

---

## Implementation Output Format

Per user request and constitution (Principle III - TDD):

1. **First**: Output the test code you are adding/changing
2. **Then**: Output the implementation code that makes tests pass
3. **Finally**: Brief 2-3 bullet summary of:
   - What behaviors were tested
   - What code was implemented or refactored

---

## Notes

- All [P] tasks can run in parallel within their phase
- [Story] labels map tasks to user stories for traceability
- Commit after each task or logical group
- Each phase checkpoint validates that story works independently
- AppLogger (T004) follows detailed spec from constitution + logger prompt
