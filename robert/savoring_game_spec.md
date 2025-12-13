# Savoring Choice Game - Feature Specification

## 1. Feature Purpose

This is a new game modality within the app. It helps users develop metacognitive awareness by recognizing how their interpretations drive emotions and actions. The game trains users to notice and choose savoring interpretations of positive moments through gentle, reflective sentence completion exercises.

---

## 2. Design Philosophy

### Core Experience

- A calm inner moment, not a test
- A gentle nudge, not instruction  
- Permission-giving, not performance-focused
- Feels like placing words into a thought

### Character Role

The character is **not** a mascot or teacher. The character represents a part of the user who is already capable of noticing the good—a silent, supportive inner companion.

### Tone

- Non-clinical, everyday language
- No moral framing or "should" statements
- No self-improvement rhetoric
- Trains awareness, not mood change

---

## 3. Character Assets Required

The developer will provide static character images. The following character images are needed:

1. **character_idle.png** - Default warm, present, attentive expression
2. **character_guiding.png** - Slight head tilt or engaged look (for first-time guidance)
3. **character_affirming.png** - Soft nod or gentle smile (for correct answers)
4. **character_celebration.png** - Calm, warm celebration expression (for completion screen)

---

## 4. Game Flow Overview

```
Intro Screen → Game (10 rounds) → Completion Screen
```

Each session is 10 sentence stems total. User completes the session in one sitting.

---

## 5. Intro Screen

**Design Note:** This intro screen should follow the same design pattern and layout as intro screens in other games within the app.

The intro screen has 4 sequential parts. User advances by tapping or swiping.

### Part 1: Concept Explanation

**What appears:**

- Character at top of screen
- Explanation text below character

**Text content:**

```
Good moments happen all the time—
but we don't always let them in.

Sometimes we rush past them.
Sometimes we dismiss them.

This game helps you practice noticing 
the good and letting it stay a little longer.
```

**User action:** Tap anywhere or swipe to continue

---

### Part 2: CBT Loop Diagram

**What appears:**

- Visual diagram showing four connected steps
- Character still visible but smaller, positioned to the side
- Diagram shows how situation → interpretation → emotion → action

**Diagram content:**

**Step 1: Situation**

- Label: "Situation"
- Example: "A friend texts you"

**Step 2: Interpretation (shows TWO options)**

- Option A (highlighted in warm color): "They remembered me"
- Option B (shown in gray): "They probably need something"

**Step 3: Emotion (branches from both interpretations)**

- From Option A: "Warmth"
- From Option B: "Tension"

**Step 4: Action (branches from both emotions)**

- From warmth path: "Smile and respond"
- From tension path: "Respond quickly, move on"

**Visual design:**

- Arrows connect each step showing cause-and-effect
- Savoring path (left side) uses warm/green colors
- Dismissive path (right side) uses neutral gray
- Clean, minimal, easy to understand at a glance

**User action:** Tap anywhere or swipe to continue

---

### Part 3: Benefit Statement

**What appears:**

- Character back to centered position
- Explanation text

**Text content:**

```
The interpretation you choose 
shapes how you feel and what you do.

In this game, you'll practice choosing 
interpretations that let the good moments in.
```

**User action:** Tap anywhere or swipe to continue

---

### Part 4: Science Reference & Start

**What appears:**

- Character at top
- Small science reference text in middle
- Large "Start" button at bottom

**Text content:**

```
[Small text in middle]
Research shows that savoring—intentionally 
noticing and appreciating positive experiences—
can increase well-being and resilience.

[Button at bottom]
Start
```

**User action:** Tap "Start" button to begin game

---

## 6. Game Screen Layout

### Screen Structure (Top to Bottom)

**1. Progress Bar (Top)**

- Use the same progress bar widget from other games in the app
- Display format and behavior should match exactly how progress is shown in other games
- Shows progress through 10 rounds (current round / total rounds)
- Updates after each correct completion

**2. Character Zone (Upper third)**

- Character centered horizontally
- Static by default with very subtle breathing animation
- Warm, present, attentive expression
- Never leaves the screen during gameplay

**3. Sentence Zone (Middle)**

- Sentence displayed with blank spaces indicated
- Blanks shown as underlined spaces
- For double-blank sentences, blanks are numbered: `{ 1 }` and `{ 2 }`
- Large, readable text

**4. Tile Zone (Bottom third)**

- Word tiles arranged in groups by blank number
- Label "1:" above first group of tiles
- Label "2:" above second group (if double-blank sentence)
- Tiles are draggable
- Evenly spaced with comfortable touch targets

---

## 6. Character States & Behavior

### Idle (Default)

- Very subtle breathing animation (slow, gentle)
- Occasional soft blink
- Calm, present expression
- No movement otherwise

### First-Time Guidance (Round 1 only, first-ever play)

- Slight head tilt toward sentence area
- OR subtle eye movement toward the correct tile
- Gentle, brief, one-time only

### After Correct Choice

- Soft nod OR micro-smile
- Brief, subtle affirmation
- Returns to idle immediately after

### After Incorrect Choice

- No reaction at all
- Stays in idle state
- Shows no disapproval or negativity

---

## 7. Game Interaction

### How It Works

1. User sees a sentence with one or two blanks
2. Word tiles appear below the sentence
3. User drags a tile and drops it into a blank
4. System checks if the tile is correct
5. Feedback appears briefly
6. If correct, move to next round after 1.5 seconds
7. If incorrect, tile returns to original position and user tries again

### Single-Blank Sentences

- One blank in the sentence
- Three word tile options below
- User drags and drops one tile into the blank
- Only one tile is correct (represents savoring interpretation)
- Other tiles are grammatically valid but represent dismissive interpretations

### Double-Blank Sentences

- Two blanks in the sentence, not adjacent to each other
- Both numbered: `{ 1 }` and `{ 2 }`
- Two groups of tiles appear: Group 1 and Group 2
- Blank 2 is locked/disabled until Blank 1 is completed correctly
- User must complete Blank 1 first, then Blank 2 becomes active
- All tile combinations are grammatically valid
- Only one combination represents full savoring

---

## 8. First-Time Experience (Glowing Tile)

**When:** Only happens on Round 1, only for users playing for the very first time

**What happens:**

1. Sentence and tiles appear
2. After a brief moment (0.5 seconds), one tile begins to glow softly
3. The glowing tile is the correct answer
4. Glow is subtle—a soft pulsing effect, warm color, gentle
5. As soon as the user picks up ANY tile (correct or not), the glow disappears permanently
6. Glow never appears again in any future round or session

**Purpose:**

- Guides user to understand what to do without written instructions
- Still requires user to make the choice (not automatic)
- Shows guidance, not demands

---

## 9. Feedback System

### When User Drops Correct Tile

**What appears:**

- Brief positive message below the sentence
- Message appears immediately when tile is dropped
- Character shows subtle affirmation (nod or smile)
- Progress bar updates (using the same progress bar widget from other games)
- Message visible for 1.5 seconds, then fades out

**Haptic feedback:**

- Subtle haptic feedback (light impact) when tile is successfully dropped into blank

**Example correct messages:**

- "You let the moment stay."
- "You made space for the good."
- "That opens you to warmth."
- "You chose to feel it."

**What happens next:**

- After 1.5 seconds, screen transitions to next round
- Total transition time about 2.5 seconds

---

### When User Drops Incorrect Tile

**What appears:**

- Brief neutral message below the sentence
- Message appears immediately
- Character shows NO reaction (stays in idle)
- Tile smoothly returns to original position

**Example incorrect messages:**

- "That focuses away from the good. Try again."
- "That pushes the good aside. Try another."
- "That dismisses the moment. Try another."
- "That moves away from feeling. Try again."

**Tone of incorrect feedback:**

- Neutral, non-judgmental
- Descriptive (explains why it's not savoring)
- Encouraging (includes "try again")
- No teaching language
- No highlighting of what was wrong

**What happens next:**

- Message visible for 2 seconds
- User can immediately try again
- No penalty or negative reinforcement

---

## 10. The 10 Sentence Stems

### Stem 1 (Single-Blank)

**Sentence:** "It's okay to ________"

**Tiles:**

- "enjoy this moment" ✓ CORRECT
- "keep moving"
- "focus on what's wrong"

**Incorrect feedback:** "That focuses away from the good. Try again."

---

### Stem 2 (Single-Blank)

**Sentence:** "I can let the good __________"

**Tiles:**

- "linger a little" ✓ CORRECT
- "disappear"
- "not matter"

**Incorrect feedback:** "That pushes the good aside. Try another."

---

### Stem 3 (Single-Blank)

**Sentence:** "A little joy like this __________"

**Tiles:**

- "is worth pausing for" ✓ CORRECT
- "won't last"
- "distracts me"

**Incorrect feedback:** "That dismisses the moment. Try another."

---

### Stem 4 (Single-Blank)

**Sentence:** "I can choose to __________"

**Tiles:**

- "feel this good thing" ✓ CORRECT
- "hurry up"
- "not think about it"

**Incorrect feedback:** "That moves away from feeling. Try again."

---

### Stem 5 (Double-Blank)

**Sentence:** "I can ___this moment___."

**Blank 1 tiles:**

- "appreciate" ✓ CORRECT
- "dismiss"
- "rush"

**Blank 2 tiles:**

- "fully" ✓ CORRECT
- "briefly"
- "less"

**Incorrect feedback Blank 1:** "That doesn't bring you closer. Try another."
**Incorrect feedback Blank 2:** "That cuts the moment short. Try another."

**Correct complete sentence:** "I can appreciate this moment fully."

---

### Stem 6 (Double-Blank)

**Sentence:** "I can ___the warmth___."

**Blank 1 tiles:**

- "take in" ✓ CORRECT
- "push away"
- "overlook"

**Blank 2 tiles:**

- "gently" ✓ CORRECT
- "quickly"
- "barely"

**Incorrect feedback Blank 1:** "That blocks the feeling. Try again."
**Incorrect feedback Blank 2:** "That rushes past it. Try another."

**Correct complete sentence:** "I can take in the warmth gently."

---

### Stem 7 (Double-Blank)

**Sentence:** "Small joys can help me ___the day___."

**Blank 1 tiles:**

- "soften" ✓ CORRECT
- "tighten"
- "hurry"

**Blank 2 tiles:**

- "a little" ✓ CORRECT
- "less"
- "faster"

**Incorrect feedback Blank 1:** "That adds tension. Try another."
**Incorrect feedback Blank 2:** "That minimizes the joy. Try again."

**Correct complete sentence:** "Small joys can help me soften the day a little."

---

### Stem 8 (Double-Blank)

**Sentence:** "I choose to let moments ___me___."

**Blank 1 tiles:**

- "lift" ✓ CORRECT
- "pressure"
- "distract"

**Blank 2 tiles:**

- "lightly" ✓ CORRECT
- "quickly"
- "hardly"

**Incorrect feedback Blank 1:** "That creates heaviness. Try another."
**Incorrect feedback Blank 2:** "That barely lets it in. Try again."

**Correct complete sentence:** "I choose to let moments lift me lightly."

---

### Stem 9 (Double-Blank)

**Sentence:** "I'm glad I can ___this feeling___."

**Blank 1 tiles:**

- "hold" ✓ CORRECT
- "ignore"
- "shrink"

**Blank 2 tiles:**

- "closer" ✓ CORRECT
- "briefly"
- "less"

**Incorrect feedback Blank 1:** "That pushes it away. Try another."
**Incorrect feedback Blank 2:** "That keeps it distant. Try again."

**Correct complete sentence:** "I'm glad I can hold this feeling closer."

---

### Stem 10 (Double-Blank)

**Sentence:** "I am ___of___."

**Blank 1 tiles:**

- "worthy" ✓ CORRECT
- "afraid"
- "doubtful"

**Blank 2 tiles:**

- "goodness" ✓ CORRECT
- "pressure"
- "mistakes"

**Incorrect feedback Blank 1:** "That closes you off. Try another."
**Incorrect feedback Blank 2:** "That focuses on difficulty. Try again."

**Correct complete sentence:** "I am worthy of goodness."

---

## 11. Completion Screen

**When shown:** After user completes all 10 stems correctly

**What appears:**

- Character at top, slightly larger than game screen
- Character shows gentle, calm celebration (not exuberant)
- Completion message centered below character
- "Finish" or "Done" button at bottom

**Message content:**

```
Wonderful!

Good moments are small—but when you notice them,
they brighten your whole day.

Remember: when something good happens,
you deserve to let it in.
```

**Visual feel:**

- Warm, calm background (slightly more colorful than game)
- Celebratory but not overwhelming
- Feels like closure and consolidation of insight

**User action:**

- Tap "Finish" button
- Returns to app's main game menu or home screen

---

## 12. Visual Design Requirements

### Overall Aesthetic

- Same look and feel as other games in the app
- Calm, soft colors
- Warm, inviting without being childish
- Clean, minimal interface
- Readable text with good spacing

### Progress Bar

- Use the exact same progress bar widget from other games in the app
- Maintain identical styling, positioning, and behavior
- Shows visual progress through the 10 rounds

### Character

- Illustrated style (not photorealistic)
- Warm, friendly, adult appearance
- Wearing glasses and casual clothing
- Neutral/inclusive appearance
- Soft, rounded design
- Consistent across all screens
- **Developer will provide 4 static images:** character_idle.png, character_guiding.png, character_affirming.png, character_celebration.png

### Tiles

- Clean rectangles with rounded corners
- White or light background
- Clear, readable text
- Comfortable size for dragging
- Adequate spacing between them

### Blanks

- Underlined spaces in sentence
- Clear visual indication they're interactive
- Highlight when tile is dragged over them
- Show word once filled correctly

### Feedback Messages

- Appear below sentence
- Soft background color (not harsh)
- Readable text
- Fade in and fade out smoothly

---

## 13. Animation & Timing Requirements

### Character Image Transitions

- **Idle → Guiding (first-time only):** Crossfade between character_idle.png and character_guiding.png
- **Idle → Affirming (correct answer):** Crossfade to character_affirming.png, hold briefly, return to idle
- **Celebration (completion screen):** Show character_celebration.png
- **All transitions:** Smooth crossfades, 0.3-0.4 seconds

### Tile Interactions

- **Dragging:** Tile follows finger smoothly, feels responsive
- **Returning (incorrect):** Smooth spring animation back to origin
- **Moving to blank (correct):** Smooth glide to position
- **Haptic feedback:** Light impact haptic when tile is dropped (correct or incorrect)

### Feedback Display

- **Appear:** Fade in quickly (0.2 seconds)
- **Visible:** 1.5 seconds for correct, 2 seconds for incorrect
- **Disappear:** Fade out (0.3 seconds)

### Round Transitions

- **Total time between rounds:** About 2.5 seconds
- Smooth fade out of old content
- Smooth fade in of new content
- Never abrupt or jarring

### First-Time Glow

- Soft pulsing effect
- 2-second cycle (pulse in and out)
- Warm, inviting color
- Not harsh or demanding

### Screen Transitions

- Between intro parts: 0.3 seconds
- Intro to game: 0.3-0.5 seconds
- Game to completion: 0.3-0.5 seconds

---

## 14. User Experience Requirements

### Must Feel Like

- A quiet moment of self-reflection
- Permission to feel good
- A gentle practice, not a test
- Safe to make mistakes
- Supported by inner wisdom

### Must NOT Feel Like

- A quiz or exam
- Clinical therapy
- Self-improvement homework
- Pressure to perform
- Judgment for wrong choices

### Interaction Quality

- Responsive: Actions feel immediate (under 0.1 seconds to respond)
- Smooth: All animations run at 60fps
- Forgiving: Incorrect choices don't feel punishing
- Intuitive: First-time user understands what to do within 2-3 seconds
- Calm: Nothing rushes the user

---

## 15. Accessibility Requirements

### Visual

- Text large enough to read easily (minimum 16pt)
- High contrast between text and background
- Support for device font scaling
- Works for colorblind users (don't rely only on color)

### Motor

- All touch targets large enough (minimum 48pt)
- Tiles easy to grab and drag
- Adequate spacing between interactive elements
- Works with device accessibility features

### Screen Reader

- All text is readable by screen readers
- Interactive elements properly labeled
- Progress announcements (e.g., "Round 3 of 10")
- Feedback messages announced

---

## 16. Edge Cases to Handle

### User Behavior

- **Rapid tapping:** Don't allow multiple tiles to be dragged at once
- **Dragging outside screen:** Tile returns to origin smoothly
- **Leaving app mid-game:** Resume where they left off OR restart (decide which)
- **Replaying immediately:** Allow, but progress bar resets

### First-Time Experience

- After first play, never show glow again
- Remember this permanently (not just for current session)
- If user reinstalls app, treat as new user (show glow again)

### Double-Blank Logic

- Blank 2 must be completely non-interactive until Blank 1 is correct
- Visual indication that Blank 2 is locked (dimmed/grayed out)
- Once Blank 1 correct, Blank 2 becomes fully active

---

## 17. Content Rules

### All Stems Must Follow

- Grammatically correct for all tile combinations
- Only one option represents savoring per blank
- Incorrect options are realistic (not obviously wrong)
- Incorrect options represent dismissive or rushing interpretations
- Language is everyday, never clinical
- No "should" statements or moral framing

### Feedback Must Follow

- Neutral tone, never harsh or scolding
- Brief (one sentence)
- Descriptive of why it's not savoring
- Includes encouragement to try again
- No technical terms or therapy language

---

## 18. Platform Requirements

### iOS & Android

- Works on both platforms
- Respects safe areas (notch, home indicator)
- Handles different screen sizes appropriately
- Follows platform conventions for back button (Android)

### Screen Orientations

- Portrait mode (primary)
- Landscape support optional (can lock to portrait)

### Performance

- Runs smoothly on devices from last 4-5 years
- No lag during drag interactions
- Consistent 60fps animation
- Fast load times (under 2 seconds per screen)

---

## 19. Success Criteria

### User Experience

- First-time users understand what to do within 2-3 seconds without instructions
- Users complete all 10 rounds in one session (high completion rate)
- Interaction feels calm and unhurried
- Character feels supportive, not instructive
- Incorrect attempts don't feel discouraging

### Quality

- All animations smooth and subtle
- Text is clear and readable
- No bugs in drag-and-drop interaction
- Works well on both iOS and Android
- Accessible via screen reader

### Design Alignment

- Matches look and feel of other games in app
- Character has warm, supportive presence
- Tone is consistently permission-giving
- No clinical or self-improvement language anywhere

---

## 20. What This Game Is NOT

To clarify boundaries:

### Not a Quiz

- No scoring or grading
- No timer or speed requirement
- Mistakes are part of learning
- Not about getting it "right"

### Not Therapy

- No clinical language
- No diagnostic intent
- No treatment claims
- Just a gentle practice

### Not a Lesson

- Character doesn't teach or explain
- No lengthy instructions
- Learning happens through doing
- User discovers through experience

### Not Performance-Based

- No comparison to others
- No achievements or badges
- No streak tracking (for MVP)
- Just personal practice

---

## 21. Future Considerations (Post-MVP)

These are NOT required for first version but could be added later:

### Content

- More stems (15-20 total)
- Randomized order to reduce repetition
- Different difficulty levels
- Themed sets (morning, evening, work, relationships)

### Personalization

- Choose different characters
- Adjust animation speed
- Select preferred feedback style

### Engagement

- Daily reminder to practice
- Track completion streaks
- See personal progress over time
- Share completion message

### Interaction

- Tap-to-select alternative to drag-and-drop
- Voice-over reading stems aloud
- Haptic feedback on correct/incorrect

### Analytics

- Track which stems are most difficult
- See pattern of incorrect choices
- Insights into interpretation tendencies
- Progress dashboard

---

## 22. Answered Questions

These decisions have been made for this feature:

1. **Intro repeat behavior:** Intro always appears every time user starts the game. No need to handle returning users differently.

2. **Mid-game interruption:** If user leaves mid-game, implement whichever approach is easier (resume or restart).

3. **Replay timing:** No cooldown needed. Users can replay immediately whenever they want.

4. **Analytics:** No analytics tracking needed for this stage.

5. **Haptic feedback:** Yes - subtle haptic feedback on tile drop (both correct and incorrect).

6. **Dark mode:** Not required for MVP.

7. **Landscape mode:** Handle the same way as other games in the app.

8. **Character variations:** Fixed character (no multiple options).

---

## 23. Delivery Checklist

### Assets Needed

- [ ] Character images (4 total - developer provides these):
  - [ ] character_idle.png
  - [ ] character_guiding.png  
  - [ ] character_affirming.png
  - [ ] character_celebration.png
- [ ] CBT diagram for intro screen
- [ ] App icon/thumbnail for game selection menu

### Content Needed

- [ ] All 10 stems with correct answers
- [ ] All feedback messages
- [ ] Intro screen text (final copy approval)
- [ ] Completion screen text (final copy approval)

### Screens to Build

- [ ] Intro screen (4 parts)
- [ ] Game screen
- [ ] Completion screen

### Core Features

- [ ] Progress bar (use existing progress bar widget from other games)
- [ ] Character display with image transitions
- [ ] Sentence display with blanks
- [ ] Draggable word tiles
- [ ] Drag-and-drop interaction
- [ ] Haptic feedback on tile drop
- [ ] Feedback system
- [ ] First-time glow (round 1 only)
- [ ] Double-blank sequential logic

### Quality Checks

- [ ] All image transitions smooth
- [ ] Drag-and-drop feels responsive
- [ ] Haptic feedback works on tile drop
- [ ] Feedback messages display correctly
- [ ] Character images transition appropriately
- [ ] Progress bar (from existing widget) updates accurately
- [ ] Screen reader accessible
- [ ] Works on various screen sizes
- [ ] iOS and Android tested

---

## End of Specification

This document describes **what** to build. Implementation decisions on **how** to build it are left to the development team.

**Core principle:** Every interaction should feel like a gentle noticing, a permission to feel good, and a moment of inner wisdom—never a test, lesson, or performance.
