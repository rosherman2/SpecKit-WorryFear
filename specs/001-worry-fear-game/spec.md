# Feature Specification: Worry vs Fear Cognitive Training Game

**Feature Branch**: `001-worry-fear-game`  
**Created**: 2025-12-09  
**Status**: Draft  
**Input**: Mobile game (iOS & Android) training users to discriminate between worry and fear

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Core Gameplay Session (Priority: P1)

A user opens the app, learns about the difference between worry and fear on the intro screen, then plays a 10-scenario game session where they drag scenario cards to the correct category bottle (Fear = immediate danger, Worry = future what-ifs). They receive instant visual, audio, and haptic feedback on each answer.

**Why this priority**: This is the core value proposition—the cognitive training mechanic. Without this, there is no game.

**Independent Test**: Can be fully tested by completing one full game session with mixed correct and incorrect answers. Delivers the primary learning experience.

**Acceptance Scenarios**:

1. **Given** the app is opened, **When** the intro screen loads, **Then** the user sees: educational text at top, Start button below it, two 3D bottles (Fear orange-red with fire icon, Worry blue with cloud icon) with floating animation, and an expandable Scientific Background section at bottom.

2. **Given** the user taps Start, **When** the gameplay screen appears, **Then** they see a horizontal progress bar at top, a centered draggable scenario card with emoji and text, and two bottle drop zones at bottom.

3. **Given** a scenario card is displayed, **When** the user touches and drags it, **Then** the card lifts with increased shadow, follows the finger, becomes slightly transparent, and provides haptic feedback.

4. **Given** the user drags a card near a bottle, **When** the card enters the drop zone, **Then** the bottle glows softly and scales up slightly.

5. **Given** the user drops the card on the correct bottle, **When** the drop is detected, **Then**: the card snaps to center of bottle with spring motion and fades out, "+2" text flies upward and fades, a random success animation plays (high-five, thumbs up, star burst, confetti, or checkmark), a positive "ding" sound plays, and progress bar advances smoothly.

6. **Given** the user drops the card on the wrong bottle, **When** the drop is detected, **Then**: the card bounces back to center with elastic motion, red border appears (2-3 pixels) and fades after 0.5 seconds, card shakes 3 times quickly, gentle "buzz" sound plays, haptic feedback pulses, and the card remains draggable for retry.

7. **Given** the user drops the card outside both bottles, **When** released, **Then** the card smoothly returns to center with elastic bounce animation and no sound plays.

8. **Given** all 10 scenarios are answered correctly, **When** the session ends, **Then** the completion screen shows large celebration animation (confetti/stars), message "Perfect! You've mastered all 10 scenarios! 🎉", final score "20 points!", and a Finish button.

---

### User Story 2 - Review Mode for Incorrect Answers (Priority: P2)

After completing 10 scenarios, if the user made any mistakes, they enter a review session showing only the scenarios they got wrong. They must answer correctly to proceed, with auto-correction on second failure.

**Why this priority**: Learning from mistakes is essential. Review mode ensures users don't leave with misconceptions.

**Independent Test**: Can be tested by intentionally getting scenarios wrong in P1 gameplay, then verifying review mode appears and functions correctly.

**Acceptance Scenarios**:

1. **Given** the user completed 10 scenarios with at least one error, **When** the session ends, **Then** a review screen appears with header "Let's review the tricky ones", subtext "You'll see the [X] scenarios you missed", and a Continue button.

2. **Given** the user is in review mode, **When** they answer a scenario correctly, **Then** normal success feedback plays and they proceed to next review item.

3. **Given** the user is in review mode and answers incorrectly, **When** 1.5 seconds pass, **Then** the card automatically moves to the correct bottle with smooth animation, educational text appears below bottles ("Fear is about immediate danger" or "Worry is about future what-ifs"), waits 3 seconds for reading, then moves to next item.

4. **Given** all review items are completed, **When** review ends, **Then** celebration animation plays with message "Great job! Now you know them all! 🌟" and Finish button.

---

### User Story 3 - First-Time User Onboarding (Priority: P3)

First-time users receive subtle visual hints on the first scenario only to understand the drag-and-drop mechanic.

**Why this priority**: Prevents confusion and ensures users understand how to play without explicit tutorials.

**Independent Test**: Can be tested by clearing app data and playing first scenario, verifying hints appear appropriately.

**Acceptance Scenarios**:

1. **Given** the user opens the app for the first time, **When** the first scenario appears, **Then** a finger/touch icon appears briefly (1 second) indicating drag gesture.

2. **Given** the user hasn't interacted for 2-3 seconds on first scenario, **When** the timer expires, **Then** the correct bottle begins to glow softly in gold/yellow with pulsing effect for 2-3 seconds, then fades.

3. **Given** the first scenario is completed, **When** subsequent scenarios appear, **Then** no hints or glowing effects appear.

4. **Given** the user returns for a future session, **When** gameplay begins, **Then** no onboarding hints appear.

---

### User Story 4 - Accessibility Alternative Input (Priority: P4)

Users who have difficulty with drag gestures can use an alternative tap-based input method.

**Why this priority**: Ensures inclusivity for users with motor impairments.

**Independent Test**: Can be tested by double-tapping a scenario card and selecting via buttons.

**Acceptance Scenarios**:

1. **Given** a scenario card is displayed, **When** the user double-taps the card, **Then** two selection buttons appear labeled "Fear" and "Worry".

2. **Given** selection buttons are displayed, **When** the user taps a button, **Then** the same feedback occurs as with drag-and-drop.

---

### Edge Cases

- **User exits mid-game**: Progress is lost; next session starts fresh. No need to save mid-game state.
- **User gets all 10 wrong**: Review mode shows all 10 scenarios with auto-correction available.
- **User drags very fast**: Animations may be shortened but behavior remains smooth and glitch-free.
- **User drags but doesn't drop**: Card stays with finger until released; returns to center if released outside bottles.
- **Phone in silent mode**: Sounds won't play but haptic feedback should still work; visual feedback is primary.

---

## Requirements *(mandatory)*

### Intro Screen Requirements

**Section A - Educational Text:**

- **FR-001**: System MUST display 2-3 lines of center-aligned text explaining worry vs fear.
- **FR-002**: Text MUST read: "Worry imagines future what-ifs, while fear reacts to an immediate, present danger. Knowing which one you feel helps you choose the right response and calm faster."
- **FR-003**: Text MUST be dark gray color with comfortable font size and clean spacing.

**Section B - Start Button:**

- **FR-004**: System MUST display a large, rounded Start button with gradient green color and white text.
- **FR-005**: Button MUST have subtle shadow and feel interactive and prominent.
- **FR-006**: On tap, button MUST slightly shrink (press animation) then navigate to Gameplay Screen.

**Section C - Visual Bottles:**

- **FR-007**: System MUST display two 3D-style bottles side by side.
- **FR-008**: Left bottle (Fear) MUST have: orange-red gradient, fire icon 🔥, label "Fear", subtitle "(Immediate)", 3D glass effect with lighting.
- **FR-009**: Right bottle (Worry) MUST have: blue gradient, cloud icon ☁️, label "Worry", subtitle "(Future)", 3D glass effect, "+2" points badge in top-right with sparkle.
- **FR-010**: Both bottles MUST gently float up and down continuously.
- **FR-011**: Bottles MUST fade in smoothly when screen loads with occasional sparkle effects.

**Section D - Scientific Background:**

- **FR-012**: System MUST display collapsed section with "📚 Scientific Background ▼" text at bottom.
- **FR-013**: On tap, section MUST expand with smooth animation showing research citations (Borkovec et al., 2004; LeDoux, 2015; Kircanski et al., 2012).
- **FR-014**: Arrow MUST rotate 180° when toggling; content MUST fade in/out smoothly.
- **FR-015**: Expanded state MUST show light gray background card with rounded corners.

---

### Gameplay Screen Requirements

**Progress Bar:**

- **FR-016**: System MUST display horizontal progress bar at top showing 10-scenario progress.
- **FR-017**: Filled portion MUST be yellow/gold; unfilled MUST be light gray with rounded ends.
- **FR-018**: Progress bar MUST animate smoothly when filling after each correct answer.

**Scenario Card:**

- **FR-019**: System MUST display white card with rounded corners, soft shadow, comfortable padding.
- **FR-020**: Card MUST show emoji/icon in top-left based on scenario type and scenario text below.
- **FR-021**: Card MUST be centered in upper-middle of screen.

**Drag Behavior:**

- **FR-022**: When user starts dragging, card MUST: lift with more shadow and slightly larger size, follow finger, become slightly transparent.
- **FR-023**: System MUST provide haptic feedback (gentle vibration) when drag starts.
- **FR-024**: Both bottles MUST slightly grow when card gets near them.
- **FR-025**: The bottle being hovered over MUST get soft glow outline.

**Correct Answer Feedback:**

- **FR-026**: Card MUST snap to center of correct bottle with spring motion and fade out.
- **FR-027**: "+2" text MUST fly upward from bottle and fade out with sparkle particles (1 second duration).
- **FR-028**: System MUST randomly select ONE success animation: high-five hands 🙌 (0.6s), thumbs up with sparkles 👍✨ (0.6s), star burst ⭐ (0.8s), confetti 🎉 (1s), or glowing checkmark ✓ (0.6s).
- **FR-029**: Positive "ding" sound MUST play immediately.
- **FR-030**: Correct bottle MUST briefly flash brighter.
- **FR-031**: After brief delay, next scenario card MUST fade in from top.

**Incorrect Answer Feedback:**

- **FR-032**: Card MUST return to center with bouncy/elastic motion.
- **FR-033**: Red border (2-3 pixels) MUST appear around card for 0.5 seconds.
- **FR-034**: Card MUST shake side to side 3 times quickly.
- **FR-035**: Gentle "buzz" sound MUST play (less than 0.5 seconds, NOT harsh).
- **FR-036**: Medium-strength haptic vibration MUST pulse once.
- **FR-037**: Card MUST remain draggable for retry.
- **FR-038**: After 1 second of incorrect answer still on screen, scenario MUST be marked for review.
- **FR-039**: System MUST NOT show which bottle was correct.

**Drop Outside Bottles:**

- **FR-040**: Card MUST smoothly return to center with elastic/bouncy animation.
- **FR-041**: No feedback sound MUST play.
- **FR-042**: User MUST be able to drag again immediately.

**Bottles (Drop Zones):**

- **FR-043**: Fear bottle (left) MUST have: orange-red gradient, fire icon, "Fear" label with "(Immediate)" subtitle, same 3D style as intro, gentle floating animation.
- **FR-044**: Worry bottle (right) MUST have: blue gradient, cloud icon, "Worry" label with "(Future)" subtitle, permanent "+2" points badge visible.
- **FR-045**: Bottle drop zone MUST include padding around the bottle for easier targeting.
- **FR-046**: Bottles MUST provide visual feedback (glow, slight scale up) when card enters drop zone.

---

### Scenario Content Requirements

**Pool of 16 Scenarios:**

- **FR-047**: System MUST include 8 Worry scenarios:
  1. 💔 Thinking "what if I never find a partner?"
  2. 💼 I might lose my job next month
  3. 📝 The exam tomorrow could go terribly
  4. 💰 My savings might not last
  5. 🤒 My child could get sick during the trip
  6. ✈️ There's a chance the flight will be cancelled
  7. 😰 I'm afraid I'll say something dumb in the meeting
  8. 🏠 I'm worried home prices will drop before I buy

- **FR-048**: System MUST include 8 Fear scenarios:
  1. 🚗 A car just swerved toward me
  2. 🐕 A dog is growling right next to my leg
  3. ⚠️ I smell gas in the room
  4. 👣 I hear footsteps behind me in the dark
  5. 💨 There's smoke filling the room
  6. 💥 A loud bang just happened outside my window
  7. 🛗 The elevator suddenly dropped
  8. ⛰️ I just slipped at the edge of a cliff

- **FR-049**: Each session MUST randomly select 10 from the pool of 16 with at least 3 of each type.
- **FR-050**: Order MUST be randomized each session.

---

### Review Mode Requirements

- **FR-051**: Review MUST trigger only if at least one error occurred in main gameplay.
- **FR-052**: Review screen MUST show header "Let's review the tricky ones" and count of missed scenarios.
- **FR-053**: Review MUST show only previously incorrect scenarios.
- **FR-054**: Review progress bar MUST show position within review items (e.g., "2 of 5").
- **FR-055**: On second wrong answer during review, card MUST auto-move to correct bottle after 1.5 seconds.
- **FR-056**: Educational text MUST appear below bottles after auto-correction.
- **FR-057**: Wait 3 seconds after educational text before moving to next item.
- **FR-058**: Review completion MUST show celebration with "Great job! Now you know them all! 🌟".

---

### Completion Screen Requirements

- **FR-059**: Perfect completion (no errors) MUST show: large celebration animation, "Perfect! You've mastered all 10 scenarios! 🎉", score "20 points!", Finish button.
- **FR-060**: Tapping Finish MUST return to intro screen.
- **FR-061**: Upbeat celebration sound MUST play (1-2 seconds).

---

### Scoring Requirements

- **FR-062**: Each correct answer MUST award +2 points.
- **FR-063**: Perfect session (10/10 correct) MUST total 20 points.
- **FR-064**: No points MUST be awarded for incorrect answers.
- **FR-065**: No time bonuses or streaks (keep it simple).
- **FR-066**: Total score MUST be shown only on completion screen.

---

### Animation Timing Requirements

- **FR-067**: Fast actions (button presses, card lift) MUST be 0.1-0.2 seconds.
- **FR-068**: Medium actions (card movements, success animations) MUST be 0.3-0.6 seconds.
- **FR-069**: Slow actions (screen transitions, floating bottles) MUST be 1-2 seconds.
- **FR-070**: Continuous animations (floating bottles, idle sparkles) MUST loop at 2-3 seconds.
- **FR-071**: Success animations MUST be bouncy and playful.
- **FR-072**: Error animations MUST be elastic and provide feedback without being punishing.
- **FR-073**: Animations MUST never delay the user; they should feel delightful.

---

### Sound Design Requirements

**Success Sound:**

- **FR-074**: MUST be a positive chime or "ding", clear and satisfying, 0.5 seconds, makes user feel good.

**Error Sound:**

- **FR-075**: MUST be a gentle buzz or subtle negative tone, 0.3 seconds, NOT harsh or jarring.

**Celebration Sound:**

- **FR-076**: MUST be upbeat and rewarding, 1-2 seconds, optional fanfare-style.

**Audio Behavior:**

- **FR-077**: Sounds MUST play instantly with visual feedback (no delay).
- **FR-078**: All sounds MUST be pleasant, not annoying, at comfortable volume.
- **FR-079**: When phone is in silent mode, haptic feedback MUST substitute.

---

### Visual Design Requirements

**Color Palette:**

- **FR-080**: Fear colors MUST be orange-red gradients (warm, urgent).
- **FR-081**: Worry colors MUST be blue gradients (cool, contemplative).
- **FR-082**: Success MUST use green; Error MUST use red (clear but not alarming).
- **FR-083**: Background MUST be off-white or very light gray (calm, clean).
- **FR-084**: Text MUST be dark gray (not harsh black).
- **FR-085**: Card background MUST be pure white.
- **FR-086**: Progress bar: unfilled light gray, filled gold/yellow.
- **FR-087**: Glow effects and sparkles MUST use soft gold, white, light blue.

**Typography:**

- **FR-088**: All text MUST use clean, modern sans-serif font.
- **FR-089**: Intro educational text MUST be medium-large and very readable.
- **FR-090**: Scenario text MUST be large enough to read while dragging.
- **FR-091**: Bottle labels MUST be clear and prominent.
- **FR-092**: Button text MUST be large and confident.

---

### Responsive Design Requirements

- **FR-093**: App MUST work on small phones (iPhone SE size) through large phones (Pro Max size).
- **FR-094**: App MUST work on various Android devices.
- **FR-095**: All text MUST remain readable at all screen sizes.
- **FR-096**: All tap targets MUST be comfortably touchable.
- **FR-097**: Proportions MUST scale appropriately.
- **FR-098**: App MUST be locked to portrait mode only.
- **FR-099**: App MUST respect iPhone notch/Dynamic Island.
- **FR-100**: App MUST respect Android status bar and navigation bar.
- **FR-101**: Content MUST NOT be hidden behind device UI elements.

---

### Accessibility Requirements

- **FR-102**: Text MUST scale with device text size settings (within reason).
- **FR-103**: Colors MUST have good contrast (text vs background).
- **FR-104**: All interactive elements MUST be large enough to tap easily.
- **FR-105**: Double-tap on scenario card MUST show alternative "Fear" and "Worry" buttons.
- **FR-106**: Alternative input MUST provide same feedback and experience as drag-and-drop.
- **FR-107**: Instructions MUST be clear and simple with no time pressure.

---

### First-Time Experience Requirements

- **FR-108**: On very first scenario, drag hint icon MUST appear for 1 second.
- **FR-109**: After 2-3 seconds on first scenario, correct bottle MUST glow gold/yellow with pulsing effect for 2-3 seconds.
- **FR-110**: Remaining first session scenarios MUST have no hints.
- **FR-111**: Future sessions MUST have no hints at all.

---

### Key Entities

- **Scenario**: Situation text, emoji/icon, correct category (Fear or Worry), session answer status.
- **Session**: 10 randomly selected scenarios, progress position, errors list, final score, first-time flag.
- **Category**: Fear (immediate danger) or Worry (future what-ifs).
- **Review**: Subset of scenarios answered incorrectly, auto-correction state.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users understand the drag-and-drop mechanic within the first 3 scenarios.
- **SC-002**: 90% of users who start a session complete all 10 scenarios (low drop-off).
- **SC-003**: Users complete a full session (10 scenarios + review) in under 5 minutes.
- **SC-004**: First-time users require no external instructions to complete their first session.
- **SC-005**: All feedback (visual, audio, haptic) appears within 200ms of user action.
- **SC-006**: Users report learning the worry/fear distinction after one session.
- **SC-007**: 70% of users return for a second session within 7 days.
- **SC-008**: App runs smoothly at 60fps on devices from the last 5 years.
- **SC-009**: Game is fully playable using accessibility features (double-tap mode).
- **SC-010**: App feels delightful, beautiful, clear, responsive, calm, and premium.

---

## Visual Polish Checklist

The app MUST feel:

- ✨ **Delightful**: Success moments are rewarding and fun
- 🎨 **Beautiful**: 3D bottles, smooth gradients, thoughtful colors
- 🎯 **Clear**: User always knows what to do next
- ⚡ **Responsive**: Instant feedback to all interactions
- 🧘 **Calm**: No harsh sounds or stressful elements
- 💎 **Premium**: High-quality animations and transitions

Design references:

- Meditation apps (calm, inviting)
- Casual mobile games (fun, rewarding)
- Avoid: clinical/medical feel, boring educational app feel

---

## Assumptions

- Users have basic familiarity with touch interfaces (tap, drag).
- Session data is not persisted between app sessions (fresh start each time).
- No user accounts or authentication required for MVP.
- Haptic feedback availability varies by device; visual feedback is primary.
- Scenario content is in English only for MVP.
- No audio narration of scenarios for MVP.

---

## Out of Scope (Future Enhancements)

These are explicitly NOT in the first version:

- More game types (other mental health distinctions)
- Daily challenges
- Streak tracking
- Custom scenario creation
- Multiplayer mode
- Achievement system
- Statistics dashboard
- Different difficulty levels
- Audio narration of scenarios
- More elaborate celebration animations
