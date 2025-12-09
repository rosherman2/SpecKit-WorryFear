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

```text
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

---

## Flutter Best Practices Research (2024)

*Research conducted via Exa Code MCP and Ref MCP documentation search.*

### 1. Game Loop Implementation in Flutter

**Official Flutter Approach** ([Flutter Docs: Tickers](https://docs.flutter.dev/ui/animations/overview#tickers)):

Flutter doesn't use a traditional game loop. Instead, it uses **Tickers** synchronized to the device's vsync:

```dart
// Ticker hooks into scheduler's scheduleFrameCallback()
// All tickers are synchronized - if you start three at different times,
// they'll all sync to the same starting time and tick in lockstep.
```

**Best Practice for This Game**:

- Use `SingleTickerProviderStateMixin` for widgets with ONE animation (most of our widgets)
- Use `TickerProviderStateMixin` only if multiple concurrent AnimationControllers needed
- AnimationController's `vsync: this` ensures animations sync to device refresh rate

**Implication for Plan**:

- Bottle floating animation: Single `AnimationController` with `repeat()` for continuous motion
- Card animations: Implicit widgets (`AnimatedContainer`) for simple transitions
- No custom game loop needed—Flutter's animation system handles 60fps timing

---

### 2. Performance Optimization for 60 FPS

**Key Technique: RepaintBoundary** ([Flutter DevTools: Highlight Repaints](https://docs.flutter.dev/tools/devtools/inspector#highlight-repaints)):

```dart
// ✅ GOOD: Wrap ONLY the dynamic part tightly
Padding(                           // Static parent - OUTSIDE boundary
  padding: EdgeInsets.all(8.0),
  child: RepaintBoundary(          // ← Wrap HERE
    child: AnimatedBuilder(         // The part that changes
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 100, 0),
          child: child,
        );
      },
      child: Container(width: 50, height: 50, color: Colors.red),
    ),
  ),
)

// ❌ BAD: Wrapping too much (includes static Padding)
```

**Performance Checklist**:

| Technique | When to Use | Our Application |
|-----------|-------------|-----------------|
| `RepaintBoundary` | Isolate frequently changing widgets | Around bottles (floating), scenario card (dragging) |
| `const` constructors | Prevent unnecessary rebuilds | All static widgets (labels, icons, progress bar segments) |
| `AnimatedBuilder` with `child` | Avoid rebuilding static children | Card content stays same during drag animation |
| `shouldRepaint: false` | CustomPainter optimization | If using custom bottle painting |

**Debug Performance**:

```dart
// In debug builds only
MaterialApp(
  showPerformanceOverlay: kDebugMode,
  checkerboardRasterCacheImages: kDebugMode,
  checkerboardOffscreenLayers: kDebugMode,
)
```

**Implication for Plan**:

- Add `RepaintBoundary` around: `BottleWidget`, `ScenarioCard`, `SuccessAnimation`
- Mark all text widgets, icons, and labels as `const`
- Use `AnimatedBuilder` with `child` for card drag feedback

---

### 3. Flutter_Bloc Patterns (v8.x)

**Cubit vs Bloc Decision Criteria**:

| Use Cubit | Use Bloc |
|-----------|----------|
| Simple state changes (emit directly) | Complex event-driven logic |
| No event traceability needed | Need event logging/debugging |
| Fewer lines of code | Async event transformations (debounce, throttle) |

**Our Application**:

| Component | Choice | Reason |
|-----------|--------|--------|
| `IntroCubit` | Cubit | Simple: `expand()`, `collapse()` |
| `GameplayBloc` | Bloc | Complex events: `DragStarted`, `DroppedOnBottle`, `AnswerCorrect`, `AnswerWrong`, `NextScenario` |
| `ReviewBloc` | Bloc | Event tracking for auto-correction flow |

**Best Practices Applied**:

```dart
// 1. Use Equatable for all states
class GameplayState extends Equatable {
  final Session session;
  final DragState dragState;
  
  @override
  List<Object?> get props => [session, dragState];
}

// 2. Emit immutable state copies
on<AnswerCorrect>((event, emit) {
  emit(state.copyWith(
    session: state.session.recordCorrect(),
    feedback: FeedbackType.success,
  ));
});

// 3. Use sealed classes for state variants (Dart 3)
sealed class GameplayState {}
class GameplayPlaying extends GameplayState { ... }
class GameplayReview extends GameplayState { ... }
class GameplayComplete extends GameplayState { ... }
```

**Implication for Plan**:

- Use sealed classes for `GameplayState` variants (Dart 3 feature)
- All states extend `Equatable` for proper comparison
- Events use past-tense naming: `DropAttempted`, `AnswerChecked`

---

### 4. Touch Gesture Handling Best Practices

**Draggable/DragTarget Pattern** (Recommended for our use case):

```dart
// Draggable card with custom feedback
Draggable<Scenario>(
  data: scenario,
  feedback: Material(  // Visually lifted card
    elevation: 8,
    child: ScenarioCard(scenario, isDragging: true),
  ),
  childWhenDragging: Opacity(  // Ghost in place
    opacity: 0.3,
    child: ScenarioCard(scenario),
  ),
  child: ScenarioCard(scenario),
)

// DragTarget bottle
DragTarget<Scenario>(
  onWillAcceptWithDetails: (details) {
    // Return true to show "will accept" visual
    return true;
  },
  onAcceptWithDetails: (details) {
    // Handle drop
    context.read<GameplayBloc>().add(
      DroppedOnBottle(details.data, category),
    );
  },
  builder: (context, candidateData, rejectedData) {
    final isHovering = candidateData.isNotEmpty;
    return BottleWidget(
      category: category,
      isGlowing: isHovering,  // Visual feedback
    );
  },
)
```

**Gesture Handling Best Practices**:

| Pattern | Use Case | Implementation |
|---------|----------|----------------|
| `Draggable` + `DragTarget` | Card → Bottle drop | Primary interaction |
| `GestureDetector.onDoubleTap` | Accessibility alternative | Show selection buttons |
| `HitTestBehavior.opaque` | Ensure tap area includes padding | Bottle drop zones |
| Physics simulation | Elastic bounce back | `FrictionSimulation` on drop outside |

**Spring Animation for Card Snap**:

```dart
onPanEnd: (details) {
  final velocity = details.velocity.pixelsPerSecond;
  _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  
  final simulation = SpringSimulation(
    SpringDescription(mass: 1, stiffness: 500, damping: 25),
    currentPosition,
    targetPosition,
    velocity.dx,
  );
  
  _controller.animateWith(simulation);
}
```

**Implication for Plan**:

- Use `Draggable<Scenario>` with custom `feedback` widget
- Use `DragTarget` with `onWillAcceptWithDetails` for glow feedback
- Add `GestureDetector.onDoubleTap` for accessibility mode
- Implement `SpringSimulation` for card snap-back animation

---

## Plan Implications Summary

Based on this research, the following updates are recommended:

### Architecture Updates

1. **Sealed classes** for `GameplayState` variants (Dart 3 pattern)
2. **Cubit for Intro**, **Bloc for Gameplay/Review** (per complexity analysis)

### Performance Updates

1. Add `RepaintBoundary` around dynamic widgets (bottles, card, animations)
2. Use `const` constructors for all static content
3. Add performance overlay toggle for debug builds

### Animation Updates

1. Use `SingleTickerProviderStateMixin` throughout
2. Implement `SpringSimulation` for physics-based card animations
3. Use `AnimatedBuilder` with `child` parameter for drag feedback

### Touch Handling Updates

1. Use `Draggable<Scenario>` with `DragTarget<Scenario>`
2. Implement `GestureDetector.onDoubleTap` for accessibility
3. Add haptic feedback on drag start: `HapticFeedback.lightImpact()`

---

## Updated Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6       # Latest stable
  equatable: ^2.0.5
  audioplayers: ^6.1.0       # Latest stable
  vibration: ^2.0.0          # Updated
  shared_preferences: ^2.3.3
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
  fake_async: ^1.3.2
```
