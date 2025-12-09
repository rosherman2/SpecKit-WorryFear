# Worry vs Fear Game - Product Specification

## 1. Overview

### 1.1 Purpose
A mobile game (iOS & Android) designed to train rapid conceptual discrimination between worry and fear, helping users build cognitive clarity around their mental experiences.

### 1.2 Core Mechanic
Drag-and-drop gameplay where users classify scenarios into two categories:
- **Fear**: Immediate, present danger
- **Worry**: Future-focused "what if" thinking

---

## 2. Intro Screen (4 Sections)

### Section A: Educational Text
**Position:** Top of screen

**Content:**
```
Worry imagines future what-ifs, while fear reacts to an immediate, present danger.

Knowing which one you feel helps you choose the right response and calm faster.
```

**Visual Style:**
- 2-3 lines of text
- Center-aligned
- Dark gray color
- Easy to read, comfortable font size
- Clean spacing around text

---

### Section B: Start Button
**Position:** Below Section A

**Content:** "Start" button

**Visual Style:**
- Large, rounded button
- Gradient green color (inviting, positive)
- White text
- Centered on screen
- Subtle shadow underneath
- Button should feel interactive and prominent

**Behavior:**
- Tapping navigates to Gameplay Screen
- Brief press animation (button slightly shrinks when tapped)

---

### Section C: Visual Component
**Position:** Center/middle of screen, below Start button

**Content:** Illustration showing two bottles/jars side by side

**Left Bottle - Fear:**
- Warm color theme (orange/red gradient)
- Fire/flame icon 🔥
- Label: "Fear"
- Subtitle: "(Immediate)"
- 3D style with lighting and glass effect

**Right Bottle - Worry:**
- Cool color theme (blue gradient)
- Cloud icon ☁️
- Label: "Worry"
- Subtitle: "(Future)"
- 3D style with lighting and glass effect
- Points badge in top-right corner showing "+2" with sparkle effect

**Visual Style:**
- Match the aesthetic from the provided screenshot
- Beautiful, polished 3D-style bottles
- Glass/translucent appearance with depth
- Soft glow or shine effects
- Should feel premium and delightful

**Animation:**
- Bottles gently float up and down (slow, continuous)
- Fade in smoothly when screen loads
- Small sparkle effects occasionally appear around bottles

---

### Section D: Scientific Background (Expandable Section)
**Position:** Bottom of screen, below the bottles

**Collapsed State:**
```
📚 Scientific Background ▼
```
- Small text, medium gray
- Down arrow indicates it can be expanded
- Tap anywhere on this line to expand

**Expanded State:**
```
📚 Scientific Background ▲

Studies show that distinguishing between worry and fear activates different neural pathways and requires different coping strategies (Borkovec et al., 2004; LeDoux, 2015).

Cognitive clarity about emotional states is associated with better emotion regulation outcomes (Kircanski et al., 2012).
```

**Visual Style (Expanded):**
- Light gray background card
- Rounded corners
- Comfortable padding
- Smaller, readable font
- Up arrow indicates it can be collapsed

**Animation:**
- Smooth expand/collapse animation
- Arrow rotates 180° when toggling
- Content fades in/out smoothly

---

## 3. Gameplay Screen

### Layout Overview
- **Top:** Progress bar
- **Upper-Middle:** Draggable scenario card
- **Bottom:** Two bottles (Fear and Worry) as drop zones
- Clean, uncluttered layout with focus on the scenario card

---

### Progress Bar
**Position:** Top of screen

**Visual Style:**
- Horizontal bar showing progress through 10 scenarios
- Filled portion is yellow/gold color
- Unfilled portion is light gray
- Smooth, rounded ends
- Progress fills left to right

**Behavior:**
- Updates after each correct answer
- Smooth animation when filling
- Shows current position out of 10 total items

---

### Scenario Card (Draggable)
**Position:** Upper-middle of screen, centered

**Visual Style:**
- White card with rounded corners
- Soft shadow (appears to float above background)
- Comfortable padding inside
- Icon/emoji in top-left corner based on scenario type
- Scenario text below icon, left-aligned
- Medium-sized, easy-to-read text

**Content Example:**
```
💔  Thinking "what if I never 
    find a partner?"
```

**Drag Behavior:**

1. **Initial State:**
   - Card is at rest in center of screen
   - On first scenario only: Subtle finger/touch icon appears briefly to hint at drag gesture (1 second)

2. **First-Time Hint (First Scenario Only):**
   - After 2-3 seconds, the CORRECT bottle begins to glow softly
   - Glow is gentle, pulsing (not harsh or distracting)
   - Gold/yellow glow color
   - Glow fades out after 2-3 seconds
   - This only happens on the very first scenario of first-time users
   - Purpose: Help user understand the mechanic without being intrusive

3. **When User Starts Dragging:**
   - Card lifts up (more shadow, slightly larger)
   - Card follows user's finger
   - Card becomes slightly transparent
   - Phone gives subtle haptic feedback (gentle vibration)
   - Both bottles slightly grow when card gets near them
   - The bottle the card is hovering over gets a soft glow outline

4. **When Dropped on Correct Bottle:**
   - Card snaps to center of correct bottle with spring motion
   - Card fades out
   - **Points Animation:** "+2" flies up from the bottle and fades out
   - **Random Success Feedback:** ONE of these plays (randomly selected):
     - High-five hands clapping animation 🙌
     - Thumbs up with sparkles 👍✨
     - Star burst effect ⭐
     - Confetti burst 🎉
     - Checkmark with glow ✓
   - Positive "ding" sound plays
   - Progress bar advances
   - After brief delay, next scenario card fades in from top

5. **When Dropped on Wrong Bottle:**
   - Card bounces back to center position
   - Card gets red border briefly
   - Card shakes slightly (3 small shakes)
   - Gentle "buzz" sound plays
   - Card stays on screen, user can try again
   - After 1 second, if still wrong, this scenario is saved for review later
   - Next scenario appears

6. **When Dropped Outside Bottles:**
   - Card smoothly returns to center position
   - No feedback sound
   - Elastic/bouncy animation
   - User can drag again immediately

---

### Bottles (Drop Zones)
**Position:** Bottom third of screen, side by side

**Fear Bottle (Left):**
- Orange-red gradient colors
- Fire icon 🔥
- Label: "Fear" with subtitle "(Immediate)" below
- Same 3D style as intro screen
- Gentle floating animation (never stops)
- Glows when card hovers nearby

**Worry Bottle (Right):**
- Blue gradient colors
- Cloud icon ☁️
- Label: "Worry" with subtitle "(Future)" below
- Same 3D style as intro screen
- Gentle floating animation (never stops)
- Glows when card hovers nearby
- **Points Badge:** Small "+2" indicator in top-right corner (visible at all times)

**Visual Style:**
- Beautiful 3D appearance with lighting
- Glass/translucent effect
- Labels are clear and readable below bottles
- Enough space between bottles to distinguish them clearly

**Interaction:**
- Entire bottle area (including some padding around it) is the drop zone
- Visual feedback when card enters drop zone (gentle glow, slight scale up)
- Returns to normal when card leaves drop zone

---

## 4. Success Feedback - Detailed Animations

When user drops card on correct bottle, the following happens simultaneously:

### 4.1 Points Animation
- "+2" text appears above the correct bottle
- Text is large, bold, gold/yellow color
- Flies upward while fading out
- Takes about 1 second total
- Sparkle/star particles appear around the "+2" as it moves up

### 4.2 Random Success Animation (Pick ONE Randomly)
**Option 1: High-Five Hands 🙌**
- Two hands appear in center of screen clapping together
- Hands start small, grow quickly, then return to normal size
- Playful, bouncy motion
- Visible for about 0.6 seconds then fades out

**Option 2: Thumbs Up 👍✨**
- Large thumbs up appears in center
- Surrounded by sparkle effects
- Brief appearance with elastic bounce
- Fades out after 0.6 seconds

**Option 3: Star Burst ⭐**
- Large star appears in center and bursts outward
- Multiple smaller stars fly out in all directions
- Bright, satisfying effect
- Duration: 0.8 seconds

**Option 4: Confetti 🎉**
- Colorful confetti pieces fall from top of screen
- Multiple colors (blue, yellow, red, green)
- Gentle falling motion with rotation
- Duration: 1 second

**Option 5: Glowing Checkmark ✓**
- Large checkmark appears with bright glow
- Draws itself quickly (like being written)
- Pulsing glow effect
- Duration: 0.6 seconds

**Implementation Note:** Each correct answer randomly selects one of these five animations to keep the experience fresh and delightful.

### 4.3 Audio
- Clear, positive "ding" or chime sound
- Pleasant, not annoying
- Plays immediately when correct drop is detected

### 4.4 Bottle Reaction
- The correct bottle briefly flashes brighter
- Quick, satisfying visual response

---

## 5. Error Feedback

When user drops card on wrong bottle:

### Visual Feedback
- Card returns to center position with bouncy motion
- Red border appears around card (2-3 pixel width)
- Card shakes side to side (3 small, quick shakes)
- Red border fades away after 0.5 seconds
- Card remains draggable

### Audio Feedback
- Gentle, subtle "buzz" or negative tone
- Should NOT be harsh or jarring
- Quick sound (less than 0.5 seconds)

### Haptic Feedback
- Medium-strength vibration on the phone
- Brief, single pulse

### Behavior After Error
- Card stays on screen for user to try again
- After 1 second of incorrect answer, card is marked for review
- Next scenario appears
- Do NOT show which bottle was correct yet

---

## 6. End of Session Review

### When Review Triggers
- After all 10 scenarios have been attempted
- If ANY scenarios were answered incorrectly, show review screen
- If ALL were correct, skip to completion screen

### Review Screen (If Mistakes Were Made)
**Content:**
- Header: "Let's review the tricky ones"
- Subtext: "You'll see the [X] scenarios you missed"
- Button: "Continue"

### Review Gameplay
- Same drag-and-drop interface
- Shows ONLY the scenarios that were answered incorrectly
- Progress bar shows position within review items (e.g., "2 of 5")
- User must answer correctly to proceed
- Same success feedback as main gameplay

**If Wrong Again During Review:**
- Show error feedback (red border, shake, sound)
- Wait 1.5 seconds
- Automatically move card to CORRECT bottle with smooth animation
- Show brief educational text:
  - For Fear: "Fear is about immediate danger"
  - For Worry: "Worry is about future what-ifs"
- Text appears below bottles, readable size
- Wait 3 seconds for user to read
- Move to next review item

### Review Completion
- After all review items completed correctly:
- Show celebration animation (confetti or star burst)
- Message: "Great job! Now you know them all! 🌟"
- Button: "Finish"
- Play success sound

---

## 7. Completion Screen (No Mistakes)

**Trigger:** When user completes all 10 scenarios with no errors

**Content:**
- Large celebration animation (confetti, stars, or similar)
- Message: "Perfect! You've mastered all 10 scenarios! 🎉"
- Show final score: "20 points!" (2 points × 10 scenarios)
- Button: "Finish"
- Positive, upbeat sound

**Behavior:**
- Tapping "Finish" returns to intro screen or main menu

---

## 8. Scenarios Content

Each scenario needs:
- Text description
- Appropriate emoji/icon
- Correct answer (Fear or Worry)

### Worry Scenarios (Future-focused "what ifs")
1. Thinking "what if I never find a partner?" 💔
2. I might lose my job next month 💼
3. The exam tomorrow could go terribly 📝
4. My savings might not last 💰
5. My child could get sick during the trip 🤒
6. There's a chance the flight will be cancelled ✈️
7. I'm afraid I'll say something dumb in the meeting 😰
8. I'm worried home prices will drop before I buy 🏠

### Fear Scenarios (Immediate, present danger)
1. A car just swerved toward me 🚗
2. A dog is growling right next to my leg 🐕
3. I smell gas in the room ⚠️
4. I hear footsteps behind me in the dark 👣
5. There's smoke filling the room 💨
6. A loud bang just happened outside my window 💥
7. The elevator suddenly dropped 🛗
8. I just slipped at the edge of a cliff ⛰️

### Scenario Selection Logic
- Each game session randomly picks 10 scenarios from the full pool of 16
- Should include a mix of both types (at least 3 of each)
- Order should be randomized
- Over multiple sessions, user will see different combinations

---

## 9. Color Palette

### Primary Colors
- **Fear:** Orange-red gradients (warm, urgent feeling)
- **Worry:** Blue gradients (cool, contemplative feeling)
- **Success:** Green (positive reinforcement)
- **Error:** Red (clear but not alarming)

### Neutral Colors
- **Background:** Off-white or very light gray (calm, clean)
- **Text:** Dark gray (easy to read, not harsh black)
- **Card Background:** Pure white
- **Progress Bar Unfilled:** Light gray
- **Progress Bar Filled:** Gold/yellow (rewarding)

### Accent Colors
- **Glow Effects:** Soft gold
- **Points Badge:** Gold/yellow with sparkle
- **Sparkles:** Multiple colors (gold, white, light blue)

---

## 10. Typography

### Text Sizes
- **Intro Educational Text:** Medium-large, very readable
- **Scenario Text:** Large enough to read comfortably while dragging
- **Bottle Labels:** Clear and prominent
- **Subtitles:** Smaller but still readable
- **Points Badge:** Small but noticeable
- **Button Text:** Large, confident

### Font Style
- Clean, modern sans-serif
- Medium weight for most text
- Bold for emphasis (labels, buttons)
- All text should be comfortable to read quickly

---

## 11. Animation Timing & Feel

### Speed Guidelines
- **Fast Actions:** Button presses, card lift on drag start (0.1-0.2 seconds)
- **Medium Actions:** Card movements, success animations (0.3-0.6 seconds)
- **Slow Actions:** Screen transitions, floating bottles (1-2 seconds)
- **Continuous:** Floating bottles, idle sparkles (2-3 second loops)

### Animation Style
- **Bouncy:** Success animations, high-fives, star bursts (playful energy)
- **Smooth:** Card movements, progress bar fill (controlled, precise)
- **Elastic:** Card return on wrong drop (satisfying feedback)
- **Gentle:** Bottle floating, background effects (calming, not distracting)

### Key Animation Principles
- Animations should feel delightful but never delay the user
- Success animations are MORE energetic than error animations
- First-time hints are subtle and fade away naturally
- Nothing should feel jarring or frustrating

---

## 12. Sound Design

### Required Sounds

**Success Sound:**
- Positive chime or "ding"
- Clear, satisfying tone
- Short duration (0.5 seconds)
- Should make user feel good
- Reference: Think "achievement unlocked" or "correct answer"

**Error Sound:**
- Gentle buzz or subtle negative tone
- Short duration (0.3 seconds)
- Should NOT be harsh, jarring, or punishing
- Just a clear "not quite right" signal
- Reference: Think "try again" not "you failed"

**Celebration Sound (End of Session):**
- Upbeat, rewarding
- 1-2 seconds
- Optional fanfare-style sound
- More elaborate than single correct answer

### Audio Behavior
- Sounds play instantly with visual feedback (no delay)
- All sounds should be pleasant, not annoying
- Volume should be comfortable (not too loud)
- Sounds should work even when phone is in silent mode (use vibration as backup)

---

## 13. User Flow Summary

```
1. App Opens
   ↓
2. Intro Screen
   - Read about worry vs fear
   - See bottle visual
   - Optionally expand scientific background
   - Tap "Start"
   ↓
3. Gameplay (10 Scenarios)
   - First scenario: subtle hint (glowing correct bottle for 2-3 seconds)
   - Drag scenario card to correct bottle
   - Get instant feedback (points, animation, sound)
   - If wrong: shake, red border, try again, then move on
   - Progress through all 10 scenarios
   ↓
4. Check Results
   ↓
   ├─→ All Correct → Completion Screen (celebration) → Finish
   │
   └─→ Some Wrong → Review Screen → Review Gameplay → Completion Screen → Finish
   
5. Finish
   - Return to intro screen or exit
```

---

## 14. Screen Layouts Visual Description

### Intro Screen Layout
```
┌─────────────────────────┐
│                         │
│   Educational Text      │
│   (Section A)           │
│                         │
│      [Start Button]     │
│      (Section B)        │
│                         │
│                         │
│   ╔═══╗    ╔═══╗       │
│   ║🔥 ║    ║☁️ ║       │
│   ║ F ║    ║ W ║       │
│   ╚═══╝    ╚═══╝       │
│   Fear     Worry        │
│   (Section C)           │
│                         │
│ 📚 Scientific... ▼      │
│   (Section D)           │
│                         │
└─────────────────────────┘
```

### Gameplay Screen Layout
```
┌─────────────────────────┐
│ ▓▓▓▓▓▓░░░░░░░░░        │ ← Progress bar
│                         │
│                         │
│   ╔═══════════════╗    │
│   ║ 💔            ║    │
│   ║ Scenario text ║    │ ← Draggable card
│   ║               ║    │
│   ╚═══════════════╝    │
│                         │
│                         │
│                         │
│                         │
│   ╔═══╗      ╔═══╗     │
│   ║🔥 ║      ║☁️+2║    │ ← Drop zone bottles
│   ║ F ║      ║ W  ║    │
│   ╚═══╝      ╚═══╝     │
│   Fear       Worry      │
│                         │
└─────────────────────────┘
```

---

## 15. Responsive Design Requirements

### Screen Sizes
- Must work on small phones (iPhone SE size)
- Must work on large phones (iPhone Pro Max size)
- Must work on various Android devices
- All text should remain readable
- All tap targets should be comfortably touchable
- Proportions should scale appropriately

### Orientation
- App should be locked to portrait mode only
- No landscape support needed for this game

### Safe Areas
- Respect iPhone notch/Dynamic Island
- Respect Android status bar and navigation bar
- Content should not be hidden behind device UI elements

---

## 16. Accessibility Requirements

### Visual Accessibility
- Text should scale with device text size settings (within reason)
- Colors should have good contrast (text vs background)
- All interactive elements should be easy to tap (large enough targets)

### Motor Accessibility
- For users who cannot drag:
  - Alternative: Double-tap scenario card to show selection buttons
  - Two buttons appear: "Fear" and "Worry"
  - Tap button to make selection
  - Same feedback as drag-and-drop
  - This should be automatically available, not a setting

### Cognitive Accessibility
- Instructions are clear and simple
- Feedback is immediate and obvious
- No time pressure on any interactions
- Consistent visual language throughout

---

## 17. Edge Cases & Special Situations

### What Happens When...

**User Exits Mid-Game:**
- Game progress is lost
- Next time they open, they start fresh
- No need to save mid-game state (keep it simple)

**User Gets All 10 Wrong:**
- Review mode will show all 10 scenarios
- Same review process applies
- User can eventually complete by following auto-corrections

**User Drags Very Fast:**
- Game should handle rapid dragging smoothly
- No glitches or weird behavior
- Animations may be shortened if needed to keep up

**User Drags Card Then Doesn't Drop:**
- Card stays with finger until released
- If released outside bottles, card returns to center
- No timeout or forced drop

**Phone is in Silent Mode:**
- Sounds won't play
- Haptic feedback (vibration) should still work
- Visual feedback is the primary indicator anyway

---

## 18. First-Time User Experience

### Special Behaviors for First Play

**On Very First Scenario:**
1. Brief finger/touch icon appears (1 second) showing drag gesture
2. After 2-3 seconds, correct bottle begins to glow softly (golden/yellow glow)
3. Glow pulses gently for 2-3 seconds
4. Glow fades out
5. User should understand: "drag card to bottles"

**For Remaining First Session:**
- No more glowing hints
- User has learned the mechanic
- Normal gameplay continues

**On Future Sessions:**
- No hints at all
- User knows how to play
- Jump straight into gameplay

---

## 19. Points System

### Scoring
- Each correct answer: +2 points
- Perfect session (10/10): 20 points total
- No points for incorrect answers
- No time bonuses or streaks (keep it simple)

### Points Display
- Points badge on Worry bottle shows "+2"
- This badge is always visible (static decoration)
- When correct answer: "+2" flies up from bottle
- Total score shown only on completion screen

### Future Consideration
- Points could later be used for:
  - Daily goals
  - Achievements
  - Progress tracking across sessions
  - But for MVP, just show the points during gameplay

---

## 20. Visual Polish Checklist

The app should feel:
- ✨ **Delightful:** Success moments are rewarding and fun
- 🎨 **Beautiful:** 3D bottles, smooth gradients, thoughtful colors
- 🎯 **Clear:** User always knows what to do next
- ⚡ **Responsive:** Instant feedback to all interactions
- 🧘 **Calm:** No harsh sounds or stressful elements
- 💎 **Premium:** High-quality animations and transitions

Design references:
- Look at the provided screenshot for bottle aesthetic
- Think: meditation apps (calm, inviting)
- Think: casual mobile games (fun, rewarding)
- Avoid: clinical/medical feel, boring educational app feel

---

## 21. Future Enhancements (Not in First Version)

Ideas for later versions:
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

For now: Focus on making this ONE game absolutely excellent.

---

## 22. Success Metrics

The game is successful if:
- Users understand the mechanic within first 3 scenarios
- Users complete full sessions (low drop-off rate)
- Users report learning the distinction between worry and fear
- Users feel rewarded and satisfied after completing
- Users want to play again or recommend to others

---

**End of Specification**

