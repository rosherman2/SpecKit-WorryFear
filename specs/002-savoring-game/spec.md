# Feature Specification: Savoring Game & Multi-Game Architecture

**Feature Branch**: `002-savoring-game`  
**Created**: 2025-12-13  
**Status**: Draft  
**Input**: User description: "Build a new Savoring Choice Game matching the app style, using same configuration and reusing code. Add a welcome screen for game selection (currently 2 games)."

## Overview

This feature adds two major capabilities to the MindGO app:

1. A **Welcome/Game Selection Screen** where users choose between available games
2. The **Savoring Choice Game** - a new game mode with fill-in-the-blank sentence completion mechanics

The app will be renamed from "WorryFearApp" to "MindGO" to reflect its multi-game nature.

---

## Clarifications

### Session 2025-12-13

- Q: Mid-game interruption handling? → A: Restart on return (lose progress, match existing game behavior)
- Q: Should Savoring Game have review mode like existing game? → A: No review mode (users retry immediately when incorrect, matches non-quiz philosophy)
- Q: CBT loop diagram for intro screen? → A: Skip diagram in MVP (just show educational text)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - App Launch and Game Selection (Priority: P1)

When users launch the MindGO app, they see a welcome screen displaying available games as tappable cards. They can select which game to play.

**Why this priority**: This is the entry point for all user interactions. Without this, users cannot access any game functionality.

**Independent Test**: App launches, displays 2 game cards ("Good Moment vs Other Moment" and "Savoring Choice"), user can tap either to launch that game's intro screen.

**Acceptance Scenarios**:

1. **Given** the app launches for the first time, **When** the welcome screen loads, **Then** the user sees 2 game tiles/cards displayed (Good Moment vs Other Moment, Savoring Choice)
2. **Given** the user is on the welcome screen, **When** they tap a game card, **Then** they navigate to that game's intro screen
3. **Given** the user completes a game, **When** they tap "Finish", **Then** they return to the welcome screen

---

### User Story 2 - Savoring Game Intro Screen (Priority: P2)

Users viewing the Savoring Choice Game intro see a single scrollable screen (matching the existing "Good Moment vs Other Moment" style) with character, educational content, CBT diagram, benefit statement, Start button, and expandable scientific background.

**Why this priority**: The intro sets up the game's purpose and teaches the core concept. Essential for user understanding before gameplay.

**Independent Test**: Navigate to Savoring Game intro, scroll through content, verify all elements display correctly, tap Start to begin game.

**Acceptance Scenarios**:

1. **Given** user selects Savoring Choice game, **When** intro loads, **Then** a single scrollable screen displays with character at top, concept explanation text, benefit statement, Start button, and expandable scientific background
2. **Given** user is on intro screen, **When** they scroll, **Then** they can view all educational content
3. **Given** user taps the expandable scientific background section, **When** tapped, **Then** it expands/collapses with smooth animation
4. **Given** user is on intro screen, **When** they tap Start button, **Then** gameplay begins

---

### User Story 3 - Savoring Game Single-Blank Gameplay (Priority: P2)

Users complete sentences by dragging word tiles into blanks. Single-blank sentences have one blank and three tile options.

**Why this priority**: Core gameplay mechanic. Must work correctly for game to function.

**Independent Test**: Play through single-blank sentence stems, drag correct/incorrect tiles, verify feedback and progression.

**Acceptance Scenarios**:

1. **Given** a single-blank sentence displays, **When** the round starts, **Then** the sentence shows with one underlined blank and 3 word tiles below
2. **Given** user drags a tile, **When** they drop it on the blank, **Then** the game evaluates correctness
3. **Given** user drops correct tile, **When** validated, **Then** positive feedback displays and round advances after 1.5 seconds
4. **Given** user drops incorrect tile, **When** validated, **Then** neutral feedback displays and tile returns to original position
5. **Given** Round 1 on first-ever play, **When** tiles appear, **Then** correct tile glows softly for guidance (disappears when any tile is picked up)

---

### User Story 4 - Savoring Game Double-Blank Gameplay (Priority: P2)

Users complete sentences with two blanks in sequence. Blank 2 is locked until Blank 1 is completed correctly.

**Why this priority**: Advanced gameplay mechanic that appears in 6 of the 10 stems.

**Independent Test**: Play double-blank stems, verify Blank 2 is locked, complete Blank 1, verify Blank 2 unlocks.

**Acceptance Scenarios**:

1. **Given** a double-blank sentence displays, **When** round starts, **Then** both blanks show numbered {1} and {2} with corresponding tile groups
2. **Given** Blank 1 is unfilled, **When** user views Blank 2, **Then** Blank 2 appears dimmed/locked
3. **Given** user completes Blank 1 correctly, **When** validated, **Then** Blank 2 becomes active
4. **Given** both blanks filled correctly, **When** validated, **Then** positive feedback and round advances

---

### User Story 5 - Savoring Game Completion (Priority: P3)

After completing all 10 sentence stems, users see a completion screen with the character and a warm closing message.

**Why this priority**: Provides closure and reinforcement of the practice.

**Independent Test**: Complete all 10 rounds, verify completion screen displays with correct content and Finish button.

**Acceptance Scenarios**:

1. **Given** user completes stem 10 correctly, **When** advancing, **Then** completion screen displays
2. **Given** completion screen displays, **When** loaded, **Then** character shows celebration expression, completion message displays, and Finish button appears
3. **Given** user is on completion screen, **When** they tap Finish, **Then** they return to welcome screen

---

### User Story 6 - Character Behavior During Savoring Game (Priority: P3)

The character displays appropriate expressions based on game state (idle, guiding for first-time, affirming on correct answers).

**Why this priority**: Enhances emotional experience but game functions without it.

**Independent Test**: Observe character during gameplay - idle state, correct answer affirmation, no reaction to incorrect answers.

**Acceptance Scenarios**:

1. **Given** gameplay is active, **When** no interaction, **Then** character shows idle expression with subtle breathing animation
2. **Given** user drops correct tile, **When** feedback displays, **Then** character briefly shows affirming expression then returns to idle
3. **Given** user drops incorrect tile, **When** feedback displays, **Then** character remains in idle state (no negative reaction)

---

### Edge Cases

- What happens when user leaves app mid-game? → Session restarts fresh on return (no progress persistence, matches existing game)
- What happens when user drags tile outside screen? → Tile returns to origin smoothly
- What happens on rapid tapping? → Prevent multiple tiles being dragged simultaneously
- What happens when first-time user replays? → First-time glow never appears again (tracked permanently)
- What happens if user reinstalls app? → Treat as new user (show glow on Round 1)

---

## Requirements *(mandatory)*

### Functional Requirements

#### Welcome Screen

- **FR-001**: System MUST display a welcome screen as the app's initial route
- **FR-002**: Welcome screen MUST show 2 game cards: "Good Moment vs Other Moment" and "Savoring Choice"
- **FR-003**: Each game card MUST be tappable and navigate to that game's intro screen
- **FR-004**: All game completion screens MUST return user to welcome screen

#### App Renaming

- **FR-005**: App MUST be renamed from "WorryFearApp" to "MindGO" in code
- **FR-006**: App title/branding MUST reflect "MindGO" name

#### Savoring Game - Intro Screen (Matches Existing Style)

- **FR-007**: Intro screen MUST be a single scrollable screen (same style as "Good Moment vs Other Moment" intro)
- **FR-008**: Intro MUST display character image at top of screen
- **FR-009**: Intro MUST display concept explanation text (savoring/noticing good moments)
- **FR-010**: Intro MUST display benefit statement text
- **FR-011**: Intro MUST display Start button (same style as existing game)
- **FR-012**: Intro MUST include expandable Scientific Background section at bottom
- **FR-013**: Intro MUST always appear when starting the game (no skip for returning users)

#### Savoring Game - Gameplay

- **FR-013**: Game MUST present exactly 10 sentence stems per session
- **FR-014**: System MUST support single-blank sentences (1 blank, 3 tile options)
- **FR-015**: System MUST support double-blank sentences (2 blanks, 2 tile groups)
- **FR-016**: For double-blank sentences, Blank 2 MUST be locked until Blank 1 is correct
- **FR-017**: Progress bar MUST use the same widget as existing games
- **FR-018**: Drag-and-drop interaction MUST feel responsive (under 0.1 second response)
- **FR-019**: Haptic feedback MUST occur on tile drop (both correct and incorrect)

#### Savoring Game - Feedback

- **FR-020**: Correct answer MUST show positive message for 1.5 seconds, then auto-advance
- **FR-021**: Incorrect answer MUST show neutral message, return tile to origin, allow retry
- **FR-022**: Character MUST show brief affirming expression on correct answer
- **FR-023**: Character MUST show no reaction on incorrect answer

#### Savoring Game - First-Time Experience

- **FR-024**: On Round 1 of first-ever play, correct tile MUST glow softly after 0.5 seconds
- **FR-025**: Glow MUST disappear when any tile is picked up
- **FR-026**: Glow MUST never appear again in any future session (tracked permanently)

#### Savoring Game - Configuration

- **FR-027**: Game content MUST be loaded from JSON config under `assets/configs/`
- **FR-028**: Config MUST include all 10 sentence stems with tiles and correct answers
- **FR-029**: Config MUST include feedback messages for both correct and incorrect answers

#### Code Reuse

- **FR-030**: Progress bar widget MUST be reused from existing implementation
- **FR-031**: Theme, audio services, and animation utilities MUST be reused where applicable
- **FR-032**: Drag-and-drop base mechanics MAY be adapted if 60%+ code remains applicable

---

### Key Entities

#### Welcome Screen Data

- **GameCard**: Represents a game option (id, title, subtitle, icon/image, route)

#### Savoring Game Content

- **SentenceStem**: A sentence with 1-2 blanks and associated word tiles
  - `id`: Unique identifier
  - `templateText`: Sentence with blank markers
  - `blankCount`: 1 or 2
  - `tileGroups`: Array of tile options per blank
  - `correctTiles`: The correct tile(s) by index
  - `incorrectFeedback`: Message when wrong tile selected

- **WordTile**: A draggable word option
  - `text`: The word/phrase
  - `isCorrect`: Whether this is the savoring choice

- **Character**: Visual representation states
  - `idle`, `guiding`, `affirming`, `celebration` image references

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can launch app and select a game within 3 seconds
- **SC-002**: First-time users understand savoring game mechanics within 2-3 seconds of seeing first stem (guided by glow)
- **SC-003**: Users complete all 10 sentence stems in one session (high completion rate)
- **SC-004**: Drag-and-drop interactions feel instant (under 100ms visual response)
- **SC-005**: All animations run smoothly at 60fps
- **SC-006**: Character expressions feel supportive, not instructive (subjective - user validation)
- **SC-007**: Incorrect attempts don't feel discouraging (neutral tone verified)
- **SC-008**: Visual design matches existing app aesthetic (design review)
- **SC-009**: Both iOS and Android platforms function correctly

---

## Assumptions

Based on reasonable defaults:

1. **Asset placeholders**: Character images will be provided later; system should handle placeholder assets initially
2. **Intro always shows**: The intro appears every time the game starts (per spec clarification)
3. **No analytics**: No tracking required for this implementation
4. **Portrait mode**: Landscape handling follows existing app behavior
5. **Mid-game interruption**: Either resume or restart is acceptable (implement easier option first)
6. **No dark mode**: Not required for initial implementation

---

## Content Reference

The 10 sentence stems and their content are fully defined in `robert/savoring_game_spec.md` sections 10-11 and should be encoded into the JSON config:

**Single-blank (4)**: Stems 1-4
**Double-blank (6)**: Stems 5-10

Each stem includes:

- Sentence template with blank markers
- 3 tile options per blank (1 correct savoring choice, 2 dismissive alternatives)
- Specific incorrect feedback message per stem/blank

---

## Out of Scope (Future Considerations)

Per the spec, these are NOT included in this implementation:

- Review mode (users retry immediately, matches non-quiz design)
- CBT loop diagram on intro (skipped for MVP, just educational text)
- More than 10 stems / randomized order
- Difficulty levels or themed sets
- Character customization
- Daily reminders or streak tracking
- Tap-to-select alternative to drag-and-drop
- Voice-over / audio narration
- Analytics or progress dashboard

---

## Design Constraints

- Visual style MUST match existing app aesthetic (calm, warm, inviting)
- Text MUST be large and readable (minimum 16pt)
- Touch targets MUST be large enough (minimum 48pt)
- Color scheme MUST work for colorblind users
- Language MUST be everyday, non-clinical, permission-giving (never "should" statements)
