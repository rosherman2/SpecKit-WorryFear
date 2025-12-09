# Research: Worry vs Fear Game

**Feature**: 001-worry-fear-game
**Date**: 2025-12-09

## Technology Decisions

### 1. State Management: flutter_bloc

**Decision**: Use flutter_bloc with Cubit for simple state, Bloc for complex event-driven logic

**Rationale**:

- Required by constitution (Technology Stack section)
- Excellent testing support with bloc_test
- Clear separation of presentation and business logic
- Well-documented patterns for game state management

**Alternatives Considered**:

- Provider: Simpler but less structured for complex game state
- Riverpod: Good but not specified in constitution
- setState: Too simple for multi-screen game with shared state

---

### 2. Audio Playback: audioplayers

**Decision**: Use `audioplayers` package for sound effects

**Rationale**:

- Cross-platform (iOS & Android) support
- Simple API for short sound effects
- Supports multiple simultaneous sounds (success + points animation)
- Active maintenance and community support

**Alternatives Considered**:

- just_audio: More powerful but overkill for simple sound effects
- flutter_sound: Focused on recording, not playback
- assets_audio_player: Less mainstream, fewer examples

---

### 3. Haptic Feedback: vibration

**Decision**: Use `vibration` package for cross-platform haptics

**Rationale**:

- Works on both iOS and Android
- Simple API: `Vibration.vibrate(duration: 50)`
- Graceful degradation on devices without haptic support

**Alternatives Considered**:

- HapticFeedback (Flutter built-in): iOS-optimized patterns only
- flutter_vibrate: Less maintained

---

### 4. Animation Approach: Implicit + Custom Controllers

**Decision**: Use implicit animations for simple transitions, explicit AnimationController for complex effects

**Rationale**:

- AnimatedContainer/AnimatedOpacity for most UI transitions
- Custom controllers for: bottle floating (continuous), card spring (physics-based), success celebrations
- TweenAnimationBuilder for one-off animations

**Alternatives Considered**:

- Rive/Lottie: Overkill for this scope, adds complexity
- Pure CustomPainter: More control but more code
- animation package: Unnecessary abstraction layer

---

### 5. Drag-and-Drop: GestureDetector + Draggable

**Decision**: Use Flutter's built-in Draggable and DragTarget widgets

**Rationale**:

- Native Flutter support with good performance
- Built-in feedback widget support for drag visual
- DragTarget provides clear drop zone detection
- Easy to style and animate

**Alternatives Considered**:

- GestureDetector only: More manual positioning code
- flutter_draggable_gridview: Wrong use case (reordering)

---

### 6. 3D Bottle Visual: Gradient + Shadow Stack

**Decision**: Create 3D bottle effect using layered gradients, shadows, and glass overlay

**Rationale**:

- Pure Flutter (no external assets needed)
- Customizable colors for Fear (orange-red) and Worry (blue)
- Glass effect via overlay with opacity gradient
- Floating animation with Transform.translate

**Implementation Approach**:

```dart
Stack(
  children: [
    // Base bottle shape with gradient
    Container(gradient: LinearGradient(...)),
    // Glass highlight overlay
    Positioned(child: Container(gradient: whiteOverlay)),
    // Shadow layer
    Container(boxShadow: [...]),
    // Icon + Label
  ],
)
```

**Alternatives Considered**:

- SVG assets: Less dynamic, harder to animate colors
- 3D rendering (flutter_cube): Way overkill
- Pre-rendered images: Not responsive to screen sizes

---

### 7. First-Time Detection: SharedPreferences

**Decision**: Use SharedPreferences to persist `hasSeenOnboarding` flag

**Rationale**:

- Simple key-value storage
- Cross-platform
- Only one boolean needed

**Note**: While spec says "no persistence for MVP", first-time detection is a UX requirement (FR-108 to FR-111). This is the minimal persistence needed.

**Alternatives Considered**:

- In-memory only: Would show hints every session (wrong behavior)
- Hive: Overkill for a single boolean

---

## Architecture Decisions

### Clean Architecture Layers

| Layer | Responsibility | Flutter Dependencies |
|-------|---------------|---------------------|
| **Domain** | Scenario, Session, Category models; ScenarioService | None (pure Dart) |
| **Application** | GameplayBloc, ReviewBloc, IntroCubit | flutter_bloc |
| **Presentation** | Screens, Widgets, Animations | Flutter |
| **Core** | AppLogger, AudioService, Theme | Flutter (utilities) |

### State Flow

```
User Drag → Presentation (GestureDetector)
  → Application (GameplayBloc.add(DropOnBottle))
    → Domain (Session.checkAnswer)
      → Application (emit new state)
        → Presentation (rebuild with feedback animations)
```

---

## Dependencies Summary

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0
  audioplayers: ^5.0.0
  vibration: ^1.8.0
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  bloc_test: ^9.1.0
  fake_async: ^1.3.0
```

---

## Resolved Clarifications

All technical context items resolved. No NEEDS CLARIFICATION remaining.
