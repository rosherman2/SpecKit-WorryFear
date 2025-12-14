# Manual Testing Verification Checklist

**Task**: T091 - Manual testing on physical device  
**Date**: 2025-12-14  
**Feature**: 002-savoring-game

## Test Environment

**Tester**: _______________  
**Date**: _______________  
**Device Model**: _______________  
**OS Version**: _______________  
**Flutter Version**: _______________  
**Build Mode**: ☐ Debug  ☐ Profile  ☐ Release

---

## Pre-Test Setup

### 1. Build and Install

```bash
# For Android
flutter build apk --release
flutter install

# For iOS (requires Mac + Xcode)
flutter build ios --release
# Then install via Xcode or TestFlight
```

### 2. Reset App State (Optional)

To test first-time experience:

```bash
# Android
adb shell pm clear com.example.worry_fear_game

# iOS
# Uninstall and reinstall app
```

---

## Test Cases

### TC001: App Launch and Welcome Screen

**Priority**: Critical  
**Estimated Time**: 2 minutes

**Steps**:

1. Launch app from device home screen
2. Observe welcome screen loads

**Expected Results**:

- [ ] App launches without crash
- [ ] Welcome screen appears within 2 seconds
- [ ] Title "MindGO" is visible
- [ ] Subtitle "Choose a Game" is visible
- [ ] Two game cards are displayed:
  - [ ] "Good Moment vs Other Moment" with 🎯 icon
  - [ ] "Savoring Choice" with ✨ icon
- [ ] Both cards have subtitles
- [ ] UI is responsive (no lag when scrolling)

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC002: Existing Game Regression Test

**Priority**: Critical  
**Estimated Time**: 5 minutes

**Steps**:

1. From welcome screen, tap "Good Moment vs Other Moment"
2. Verify intro screen appears
3. Tap "Start" button
4. Play through one scenario
5. Complete game or return to welcome

**Expected Results**:

- [ ] Intro screen loads correctly
- [ ] Start button navigates to gameplay
- [ ] Existing game functions normally
- [ ] No crashes or visual glitches
- [ ] Can return to welcome screen
- [ ] No regression from previous version

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC003: Savoring Game - Navigation

**Priority**: Critical  
**Estimated Time**: 3 minutes

**Steps**:

1. From welcome screen, tap "Savoring Choice"
2. Observe intro screen
3. Tap "Start" button
4. Observe gameplay screen loads

**Expected Results**:

- [ ] Intro screen appears with:
  - [ ] Title "Savoring Choice"
  - [ ] Description text
  - [ ] "Start" button
  - [ ] Scientific background section (expandable)
- [ ] Tapping "Start" navigates to gameplay
- [ ] Gameplay screen shows:
  - [ ] Round counter "Round 1/10"
  - [ ] Score "0 pts"
  - [ ] Sentence with blank(s)
  - [ ] Word tiles below sentence
  - [ ] Character animation (breathing)
  - [ ] Back button in app bar

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC004: First-Time Glow Effect

**Priority**: High  
**Estimated Time**: 3 minutes

**Prerequisites**: Fresh install or reset app data

**Steps**:

1. Start savoring game (first time ever)
2. Observe Round 1
3. Look for glowing tile
4. Drag the glowing tile
5. Complete Round 1
6. Return to welcome and restart game

**Expected Results**:

- [ ] Round 1: One tile shows animated pulsing gold glow
- [ ] Glow pulses smoothly (no stuttering)
- [ ] Glow is on the CORRECT tile
- [ ] Glow disappears when tile is dragged
- [ ] After Round 1 completes, glow never appears again
- [ ] On subsequent plays, no glow appears

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC005: Drag and Drop - Correct Tile

**Priority**: Critical  
**Estimated Time**: 2 minutes

**Steps**:

1. In gameplay, identify the correct tile
2. Long-press and drag tile to blank
3. Release tile over blank
4. Observe feedback

**Expected Results**:

- [ ] Tile lifts when dragged (visual feedback)
- [ ] Tile follows finger smoothly
- [ ] Blank highlights when tile hovers over it
- [ ] Tile snaps into blank when released
- [ ] Green checkmark appears
- [ ] Haptic feedback occurs (gentle vibration)
- [ ] Character shows affirming animation
- [ ] Score increases by 10 points
- [ ] Auto-advances to next round after 1.5s

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC006: Drag and Drop - Incorrect Tile

**Priority**: Critical  
**Estimated Time**: 2 minutes

**Steps**:

1. In gameplay, drag an INCORRECT tile to blank
2. Release tile over blank
3. Observe feedback
4. Try dragging correct tile

**Expected Results**:

- [ ] Tile returns to original position
- [ ] Red X appears briefly
- [ ] Vibration pattern occurs (stronger than correct)
- [ ] Character remains in idle state
- [ ] Score does NOT increase
- [ ] Round does NOT advance
- [ ] Can retry with different tile
- [ ] Correct tile still works normally

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC007: Double-Blank Sentences

**Priority**: High  
**Estimated Time**: 3 minutes

**Steps**:

1. Play until Round 4 or 7 (double-blank rounds)
2. Observe both blanks
3. Try to drag tile to Blank 2 first
4. Drag correct tile to Blank 1
5. Observe Blank 2 unlocks
6. Complete both blanks

**Expected Results**:

- [ ] Sentence has TWO blanks: {1} and {2}
- [ ] Blank 2 is initially locked (grayed out)
- [ ] Cannot drop tiles on Blank 2 while locked
- [ ] After Blank 1 is filled correctly:
  - [ ] Blank 2 unlocks (becomes active)
  - [ ] Can now drop tiles on Blank 2
- [ ] Both blanks must be correct to advance
- [ ] If Blank 2 is wrong, can retry
- [ ] Round advances only when both are correct

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC008: Character Animations

**Priority**: Medium  
**Estimated Time**: 3 minutes

**Steps**:

1. Observe character during idle
2. Drag correct tile, observe character
3. Complete game, observe character on completion screen

**Expected Results**:

- [ ] Idle: Character shows breathing animation
  - [ ] Smooth, continuous animation
  - [ ] No stuttering or jank
- [ ] Correct answer: Character shows affirming animation
  - [ ] Plays once per correct answer
  - [ ] Returns to idle after
- [ ] Completion: Character shows celebration animation
  - [ ] Plays on completion screen
  - [ ] Appropriate for celebration

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC009: Complete Full Game Session

**Priority**: Critical  
**Estimated Time**: 5 minutes

**Steps**:

1. Start savoring game
2. Complete all 10 rounds
3. Observe completion screen
4. Tap "Finish" button

**Expected Results**:

- [ ] All 10 rounds complete successfully
- [ ] Completion screen appears showing:
  - [ ] Final score (0-100 points)
  - [ ] Celebration message
  - [ ] Character in celebration state
  - [ ] "Finish" button
- [ ] Tapping "Finish" returns to welcome screen
- [ ] Can start new game immediately
- [ ] Score resets for new game

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC010: Performance and Responsiveness

**Priority**: High  
**Estimated Time**: 5 minutes

**Steps**:

1. Play through entire game
2. Observe all animations
3. Test rapid tile dragging
4. Check memory usage (if possible)

**Expected Results**:

- [ ] All animations run smoothly (60fps)
- [ ] No visible stuttering or lag
- [ ] Drag response is immediate (< 100ms)
- [ ] Screen transitions are smooth
- [ ] No memory leaks (app doesn't slow down)
- [ ] App remains responsive throughout
- [ ] No crashes or freezes

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC011: Edge Cases and Error Handling

**Priority**: Medium  
**Estimated Time**: 5 minutes

**Steps**:

1. Rapidly tap tiles without dragging
2. Drag tile outside screen bounds
3. Rotate device (if supported)
4. Minimize app and resume
5. Interrupt with phone call (if possible)

**Expected Results**:

- [ ] Rapid tapping doesn't cause crashes
- [ ] Dragging outside bounds returns tile safely
- [ ] Rotation handled gracefully (or locked to portrait)
- [ ] App resumes correctly after minimize
- [ ] Phone call interruption handled properly
- [ ] No data loss on interruption

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

### TC012: Debug Features (Debug Build Only)

**Priority**: Low  
**Estimated Time**: 2 minutes

**Prerequisites**: Debug build installed

**Steps**:

1. Navigate to Savoring intro screen
2. Look for debug button
3. Tap "✨ Reset First-Time Glow (Debug)"
4. Restart app and play Round 1

**Expected Results**:

- [ ] Debug button visible in debug mode
- [ ] Button shows confirmation message when tapped
- [ ] After reset, glow appears again in Round 1
- [ ] Button NOT visible in release builds

**Actual Results**: _______________

**Status**: ☐ Pass  ☐ Fail  ☐ Blocked

---

## Summary

### Test Results

**Total Test Cases**: 12  
**Passed**: _____ / 12  
**Failed**: _____ / 12  
**Blocked**: _____ / 12  

**Pass Rate**: _____%

### Critical Issues Found

| Issue ID | Description | Severity | Status |
|----------|-------------|----------|--------|
| | | | |
| | | | |
| | | | |

### Recommendations

☐ **Approve for Release** - All critical tests passed  
☐ **Approve with Minor Issues** - Non-critical issues documented  
☐ **Reject** - Critical issues must be fixed

**Notes**: _______________

---

## Sign-Off

**Tested By**: _______________  
**Date**: _______________  
**Signature**: _______________

**Reviewed By**: _______________  
**Date**: _______________  
**Signature**: _______________

---

## Appendix: Known Issues

### Non-Blocking Issues

- Integration tests timeout due to continuous animations (not a functional issue)
- 207 linter info-level suggestions (style preferences, not errors)

### Future Enhancements

- Audio feedback (currently not implemented)
- Additional character animations
- More sentence stems
- Difficulty levels
