# Data Model: Worry vs Fear Game

**Feature**: 001-worry-fear-game
**Date**: 2025-12-09

## Entities

### Category (Enum)

Represents the two possible classifications for scenarios.

```dart
enum Category {
  fear,   // Immediate, present danger
  worry,  // Future-focused "what if" thinking
}
```

**Validation**: N/A (enum is self-validating)

---

### Scenario (Entity)

A single situation presented to the user for classification.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | `String` | Unique identifier | Required, non-empty |
| `text` | `String` | Scenario description | Required, non-empty |
| `emoji` | `String` | Visual icon (emoji) | Required, single emoji |
| `correctCategory` | `Category` | The correct answer | Required |

**Relationships**: None (standalone entity)

**State Transitions**: Scenario is immutable—no state changes.

**Example**:

```dart
Scenario(
  id: 'worry-1',
  text: 'Thinking "what if I never find a partner?"',
  emoji: '💔',
  correctCategory: Category.worry,
)
```

---

### SessionScenario (Value Object)

Tracks a scenario's state within a game session.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `scenario` | `Scenario` | The scenario being tracked | Required |
| `attempts` | `int` | Number of attempts made | >= 0, default 0 |
| `isCorrect` | `bool?` | Whether answered correctly | null = not attempted yet |

**State Transitions**:

- Initial: `attempts = 0`, `isCorrect = null`
- After correct answer: `attempts += 1`, `isCorrect = true`
- After incorrect answer: `attempts += 1`, `isCorrect = false`

---

### Session (Aggregate Root)

The main game session containing all state.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `scenarios` | `List<SessionScenario>` | All scenarios for this session | Exactly 10 items |
| `currentIndex` | `int` | Current scenario position | 0 <= index < 10 |
| `score` | `int` | Total points earned | >= 0, increments by 2 |
| `isComplete` | `bool` | Whether main gameplay finished | Computed |
| `incorrectScenarios` | `List<SessionScenario>` | Scenarios to review | Computed from scenarios |

**Validation Rules**:

- Session MUST contain exactly 10 scenarios
- Scenarios MUST include at least 3 Fear and 3 Worry types
- Score MUST only increment by 2 (per correct answer)

**State Transitions**:

```
┌──────────────┐     correct      ┌──────────────┐
│   Playing    │ ──────────────→  │ Playing (n+1)│
│ (index = n)  │                  │ (score += 2) │
└──────────────┘                  └──────────────┘
      │                                  │
      │ incorrect                        │ index == 9
      ▼                                  ▼
┌──────────────┐                  ┌──────────────┐
│   Playing    │                  │   Complete   │
│ (mark error) │                  │              │
└──────────────┘                  └──────────────┘
                                         │
                           has errors?   │
                    ┌─────────yes────────┴─────no──────┐
                    ▼                                   ▼
             ┌──────────────┐                   ┌──────────────┐
             │ ReviewMode   │                   │ Celebration  │
             └──────────────┘                   └──────────────┘
```

---

### ReviewSession (Entity)

Manages the review mode for incorrect answers.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `reviewScenarios` | `List<SessionScenario>` | Incorrect scenarios | 1 to 10 items |
| `currentIndex` | `int` | Current review position | 0 <= index < count |
| `isAutoCorrection` | `bool` | Whether showing auto-correction | Used after 2nd wrong |

**State Transitions**:

- Correct answer → advance to next review item
- First wrong answer → mark for second attempt
- Second wrong answer → auto-correct with educational text

---

## Scenario Content (Static Data)

### Worry Scenarios (8 total)

| ID | Emoji | Text |
|----|-------|------|
| `worry-1` | 💔 | Thinking "what if I never find a partner?" |
| `worry-2` | 💼 | I might lose my job next month |
| `worry-3` | 📝 | The exam tomorrow could go terribly |
| `worry-4` | 💰 | My savings might not last |
| `worry-5` | 🤒 | My child could get sick during the trip |
| `worry-6` | ✈️ | There's a chance the flight will be cancelled |
| `worry-7` | 😰 | I'm afraid I'll say something dumb in the meeting |
| `worry-8` | 🏠 | I'm worried home prices will drop before I buy |

### Fear Scenarios (8 total)

| ID | Emoji | Text |
|----|-------|------|
| `fear-1` | 🚗 | A car just swerved toward me |
| `fear-2` | 🐕 | A dog is growling right next to my leg |
| `fear-3` | ⚠️ | I smell gas in the room |
| `fear-4` | 👣 | I hear footsteps behind me in the dark |
| `fear-5` | 💨 | There's smoke filling the room |
| `fear-6` | 💥 | A loud bang just happened outside my window |
| `fear-7` | 🛗 | The elevator suddenly dropped |
| `fear-8` | ⛰️ | I just slipped at the edge of a cliff |

---

## Service Interfaces

### ScenarioService

```dart
abstract class ScenarioService {
  /// Returns 10 random scenarios with at least 3 of each type.
  List<Scenario> getSessionScenarios();
  
  /// Returns all available scenarios.
  List<Scenario> getAllScenarios();
}
```

### AudioService

```dart
abstract class AudioService {
  /// Plays success "ding" sound.
  Future<void> playSuccess();
  
  /// Plays error "buzz" sound.
  Future<void> playError();
  
  /// Plays celebration fanfare.
  Future<void> playCelebration();
}
```

### HapticService

```dart
abstract class HapticService {
  /// Light vibration for drag start.
  void lightImpact();
  
  /// Medium vibration for feedback.
  void mediumImpact();
}
```
