# Research: Savoring Game & Multi-Game Architecture

**Feature**: 002-savoring-game
**Date**: 2025-12-13
**Updated**: 2025-12-13 (CTO Best Practices Review)

## Research Summary

Technical decisions resolved through existing codebase patterns, user clarifications, and CTO-level research into latest Flutter best practices for game development.

---

## Part 1: Flutter Best Practices Research (CTO Review)

### 1.1 Game Loop Implementation in Flutter

**Finding**: Flutter does NOT require a traditional game loop for our use case.

Our savoring game is NOT a real-time game (like Flame engine games). It's an event-driven UI with animations. The correct pattern is:

| Use Case | Pattern | Our Applicability |
|----------|---------|-------------------|
| Real-time games (60fps render loop) | `FlameGame.update()` + `render()` | ❌ Not needed |
| Event-driven UI with animations | `AnimationController` + `TickerProviderStateMixin` | ✅ Use this |
| Frame callbacks | `SchedulerBinding.scheduleFrameCallback` | ⚠️ Only if needed |

**Recommendation**: Use `AnimationController` with `SingleTickerProviderStateMixin` for:

- Character breathing animation (idle state)
- Tile glow pulsing effect
- Feedback transitions

**Code Pattern**:

```dart
class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  
  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,  // Uses the TickerProvider
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }
}
```

**Plan Implication**: No changes needed. Our existing `FloatingAnimation` widget already follows this pattern.

---

### 1.2 Performance Optimization for 60fps

**Key Findings from Research**:

#### 1.2.1 RepaintBoundary Placement

**Best Practice**: Wrap ONLY the dynamic/animating parts, NOT static parents.

```dart
// ✅ GOOD: Tight boundary around animated part
Padding(
  padding: EdgeInsets.all(8.0),  // Static - OUTSIDE boundary
  child: RepaintBoundary(
    child: AnimatedBuilder(     // Dynamic - INSIDE boundary
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(controller.value * 100, 0),
        child: child,
      ),
    ),
  ),
)

// ❌ BAD: Boundary includes static elements
RepaintBoundary(
  child: Padding(              // Static part gets repainted unnecessarily
    padding: EdgeInsets.all(8.0),
    child: AnimatedBuilder(...),
  ),
)
```

**Plan Implication**: Add `RepaintBoundary` around:

- `CharacterWidget` (has breathing animation)
- `WordTileWidget` when glowing (first-time hint)
- Individual tiles during drag (not the whole tile container)

#### 1.2.2 Cache Paint Objects

**Best Practice** (from Flame docs): Create Paint objects once, not per frame.

```dart
// ✅ GOOD: Cache Paint object
class MyComponent extends PositionComponent {
  final _paint = Paint();  // Created once
  
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}

// ❌ BAD: Create Paint every render
void render(Canvas canvas) {
  canvas.drawRect(size.toRect(), Paint());  // GC pressure
}
```

**Plan Implication**: Ensure custom painters (if any) cache Paint objects. Our widgets use Flutter's built-in widgets which already handle this.

#### 1.2.3 AnimatedBuilder `child` Parameter

**Best Practice**: Pass static children to `child` parameter to prevent rebuilds.

```dart
// ✅ GOOD: Static text is NOT rebuilt on animation
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _controller.value,
      child: child,  // Static child passed through
    );
  },
  child: const Text('I am static!'),  // Built once
)

// ❌ BAD: Text rebuilds every frame
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _controller.value,
      child: Text('I rebuild every frame!'),  // 60 rebuilds/sec
    );
  },
)
```

**Plan Implication**: Use `child` parameter in all AnimatedBuilder/AnimatedContainer widgets.

#### 1.2.4 Const Constructors & ValueKey

**Best Practice**: Use `const` constructors and `ValueKey` to prevent unnecessary rebuilds.

```dart
// ✅ GOOD: Const and ValueKey for lists
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return ProductTile(
      key: ValueKey(product.id),  // Helps Flutter diff efficiently
      product: product,
    );
  },
)
```

**Plan Implication**:

- Use `const` constructors for all stateless widgets
- Use `ValueKey(tile.text)` for tiles in the tile list
- Use `ValueKey(stemId)` for sentence stems

---

### 1.3 flutter_bloc 9.0 Patterns

**Key Patterns from Official Docs**:

#### 1.3.1 Cubit vs Bloc Decision

| Feature | Cubit | Bloc |
|---------|-------|------|
| Complexity | Simple | More complex |
| Traceability | Lower | Higher (events) |
| Testing | Direct | Event-based |
| Use when | Simple state changes | Complex transformations, event logging |

**Our Decision**: Use **Cubit** for savoring game (simpler, sufficient for our needs).

```dart
class SavoringCubit extends Cubit<SavoringState> {
  SavoringCubit() : super(SavoringInitial());
  
  void startGame(List<SentenceStem> stems) {
    emit(RoundActive(stems: stems, currentIndex: 0));
  }
  
  void dropTile(WordTile tile, int blankIndex) {
    // Evaluate and emit new state
  }
}
```

**Plan Implication**: Change from `SavoringBloc` to `SavoringCubit` for simplicity.

#### 1.3.2 buildWhen for Selective Rebuilds

**Best Practice**: Use `buildWhen` to prevent unnecessary widget rebuilds.

```dart
BlocBuilder<SavoringCubit, SavoringState>(
  buildWhen: (previous, current) {
    // Only rebuild when round changes, not on every state change
    return previous.currentStemIndex != current.currentStemIndex;
  },
  builder: (context, state) {
    return SentenceDisplay(stem: state.currentStem);
  },
)
```

**Plan Implication**: Use `buildWhen` for:

- `ProgressBar`: only rebuild on stem index change
- `CharacterWidget`: only rebuild on expression change
- `SentenceDisplay`: only rebuild on stem or blank fill change

#### 1.3.3 listenWhen for Selective Side Effects

**Best Practice**: Use `listenWhen` to filter when listener triggers.

```dart
BlocListener<SavoringCubit, SavoringState>(
  listenWhen: (previous, current) {
    // Only trigger feedback sounds when feedback appears
    return !previous.showingFeedback && current.showingFeedback;
  },
  listener: (context, state) {
    if (state.isCorrect) {
      AudioService.playCorrect();
      HapticService.success();
    } else {
      AudioService.playIncorrect();
      HapticService.error();
    }
  },
  child: ...,
)
```

**Plan Implication**: Use `BlocListener` with `listenWhen` for audio/haptic feedback.

#### 1.3.4 BlocObserver for Debugging

**Best Practice**: Use BlocObserver for centralized debugging (dev only).

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.debug('BlocObserver', 'onChange', 
      () => '${bloc.runtimeType}: $change');
  }
}

// In main.dart (debug only)
void main() {
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
  runApp(const MindGOApp());
}
```

**Plan Implication**: Add `AppBlocObserver` for development debugging.

---

### 1.4 Touch Gesture Handling Best Practices

**Key Findings**:

#### 1.4.1 Draggable/DragTarget (Official Cookbook)

The official Flutter cookbook pattern for drag-and-drop:

```dart
// Draggable
Draggable<Item>(
  data: item,
  feedback: Material(
    child: Container(
      // Slightly larger, with shadow
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 4)],
      ),
      child: ItemCard(item: item),
    ),
  ),
  childWhenDragging: Opacity(
    opacity: 0.3,
    child: ItemCard(item: item),
  ),
  child: ItemCard(item: item),
)

// DragTarget
DragTarget<Item>(
  onAcceptWithDetails: (details) {
    // Handle drop
  },
  builder: (context, candidateData, rejectedData) {
    final isHovering = candidateData.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        border: Border.all(
          color: isHovering ? Colors.green : Colors.grey,
          width: isHovering ? 3 : 1,
        ),
      ),
      child: ...,
    );
  },
)
```

**Plan Implication**: Use `onAcceptWithDetails` (not deprecated `onAccept`).

#### 1.4.2 Haptic Feedback on Gestures

**Best Practice**: Provide immediate haptic feedback on drag start/end.

```dart
Draggable<WordTile>(
  onDragStarted: () {
    HapticFeedback.selectionClick();
  },
  onDragEnd: (details) {
    if (details.wasAccepted) {
      HapticFeedback.mediumImpact();
    }
  },
  ...
)
```

**Plan Implication**: Matches our existing haptic service usage pattern.

#### 1.4.3 Animation During Drag

**Best Practice**: Use `TickerProviderStateMixin` for drag-related animations.

From the official Flutter cookbook (ExampleDragAndDrop):

```dart
class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {  // Multiple animations
  ...
}
```

**Plan Implication**: Use `TickerProviderStateMixin` for gameplay screen (multiple animations: tile drag, feedback, character).

---

### 1.5 Additional Optimizations for Both Games

#### 1.5.1 Widget Rebuild Prevention

```dart
// Use const constructors
const ProgressBar(current: 3, total: 10)  // ❌ Won't work - dynamic values

// Use const for truly static widgets
const SizedBox(height: 16)  // ✅ Good
const Icon(Icons.check)      // ✅ Good
```

#### 1.5.2 Avoid Heavy Computation in build()

```dart
// ❌ BAD: Heavy work in build
@override
Widget build(BuildContext context) {
  final filtered = items.where((i) => i.isActive).toList();  // Every rebuild
  return ListView.builder(...);
}

// ✅ GOOD: Compute in state/cubit
class ItemCubit extends Cubit<ItemState> {
  void filterItems() {
    final filtered = items.where((i) => i.isActive).toList();
    emit(state.copyWith(filteredItems: filtered));
  }
}
```

**Plan Implication**: Keep sentence stem filtering/selection in Cubit, not in build().

---

## Part 2: Project-Specific Decisions

### Decision 1: Game Configuration Structure

**Decision**: Create a separate `savoring.json` config file with a new structure for sentence stems.

**Rationale**:

- Existing config uses `scenarios` with `text`, `emoji`, `correctCategory`
- Savoring game needs `stems` with `templateText`, `blanks[]`, `tileGroups[]`
- Different structure prevents forcing square peg into round hole
- Follows existing pattern of one config file per game

**Alternatives Considered**:

- Extend existing GameConfig model: Rejected - would add nullable fields and complexity
- Single unified config format: Rejected - structures too different

---

### Decision 2: State Management Architecture

**Decision**: Use `SavoringCubit` (simpler than Bloc) with selective rebuilds via `buildWhen`.

**Rationale** (updated based on research):

- Cubit is simpler and sufficient for our use case
- `buildWhen` prevents unnecessary rebuilds
- `listenWhen` handles audio/haptic side effects cleanly
- `BlocObserver` provides debugging without code clutter

**Alternatives Considered**:

- Full Bloc with Events: Rejected - overkill for simple state changes
- Provider/Riverpod: Rejected - would change existing pattern

---

### Decision 3: Drag-and-Drop Implementation

**Decision**: Use Flutter's built-in `Draggable<T>` and `DragTarget<T>` widgets with `onAcceptWithDetails`.

**Rationale** (updated based on research):

- Official Flutter cookbook pattern
- `onAcceptWithDetails` is the current API (not deprecated `onAccept`)
- Full control over visual feedback
- Works well with existing haptic/audio services

**Best Practice Applied**:

- Use `feedback` for drag shadow
- Use `childWhenDragging` for ghost effect
- Add haptic on drag start/end
- Use `RepaintBoundary` around individual tiles

---

### Decision 4: Character Animation

**Decision**: Use `AnimationController` with `SingleTickerProviderStateMixin` for breathing animation; `AnimatedSwitcher` for state transitions.

**Rationale** (updated based on research):

- `AnimationController` + Ticker is the correct Flutter pattern
- `RepaintBoundary` around character prevents full screen repaints
- Use `child` parameter in AnimatedBuilder to prevent rebuild of static parts

---

### Decision 5: First-Time Glow Persistence

**Decision**: Use SharedPreferences to store `savoring_has_played` boolean flag.

**Rationale**:

- Already using SharedPreferences for existing game's onboarding
- Simple key-value storage sufficient for boolean flag
- Persists across app restarts
- Cleared on reinstall (matches spec requirement)

---

### Decision 6: Mid-Game State Persistence

**Decision**: Do NOT persist mid-game state. Session restarts fresh on app return.

**Rationale**:

- User clarified: matches existing game behavior
- Simpler implementation
- 10 stems complete quickly, minimal lost progress

---

### Decision 7: Progress Bar Reuse

**Decision**: Fully reuse existing `ProgressBar` widget with no modifications.

**Rationale**:

- Existing widget already parameterized
- Use `buildWhen` in BlocBuilder to prevent rebuild on unrelated state changes

---

## Technology Stack (Confirmed)

| Category | Choice | Reason |
|----------|--------|--------|
| State Management | flutter_bloc (Cubit) | Simpler than Bloc, sufficient |
| Testing | flutter_test, mocktail, bloc_test | Existing setup |
| Audio | audioplayers | Existing dependency |
| Haptics | vibration | Existing dependency |
| Persistence | SharedPreferences | Existing for onboarding |
| Drag-Drop | Draggable/DragTarget | Native Flutter (official cookbook) |
| Animation | AnimationController + Ticker | Standard Flutter pattern |

---

## Plan Implications Summary

Based on the CTO research, the following changes are recommended for `plan.md`:

| Area | Original Decision | Updated Decision |
|------|-------------------|------------------|
| State Management | `SavoringBloc` | `SavoringCubit` (simpler) |
| BlocBuilder Usage | Basic | Add `buildWhen` for selective rebuilds |
| Audio/Haptic | In widget | Via `BlocListener` with `listenWhen` |
| Drag Feedback | Custom | Use official Draggable `feedback` parameter |
| Character Widget | Basic | Add `RepaintBoundary` + `AnimatedBuilder.child` |
| Debugging | AppLogger only | Add `AppBlocObserver` (dev mode) |
| Widget Keys | Not specified | Use `ValueKey` for tile lists |

---

## No NEEDS CLARIFICATION Remaining

All technical decisions resolved through:

1. Existing codebase pattern analysis
2. User clarifications during spec phase
3. Latest Flutter best practices research
4. Official Flutter/bloc documentation review
