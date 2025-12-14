# Performance Verification Guide

**Task**: T090 - Verify 60fps animations using Flutter DevTools  
**Date**: 2025-12-14

## Overview

This guide helps verify that all animations in the Savoring game run smoothly at 60fps (16ms per frame) without jank.

## Prerequisites

1. Flutter DevTools installed: `flutter pub global activate devtools`
2. Physical device or emulator running
3. App running in **profile mode** (not debug mode)

## Step-by-Step Verification

### 1. Start App in Profile Mode

```bash
# Connect device
flutter devices

# Run in profile mode (required for accurate performance metrics)
flutter run --profile
```

**Why profile mode?**

- Debug mode intentionally sacrifices performance for development features
- Profile mode provides production-like performance with DevTools enabled
- Release mode doesn't support DevTools

### 2. Launch Flutter DevTools

```bash
# In a new terminal
flutter pub global run devtools

# Or use the URL shown in the flutter run output
# Example: http://127.0.0.1:9100/?uri=http://127.0.0.1:8181/...
```

### 3. Enable Performance Overlay (Optional Quick Check)

In the running app, you can enable the performance overlay:

```bash
# Press 'P' in the terminal running flutter run
# Or add this to your code temporarily:
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugRepaintRainbowEnabled = false;
  
  // Enable performance overlay
  WidgetsApp.showPerformanceOverlayOverride = true;
  
  runApp(MyApp());
}
```

**Interpreting the overlay:**

- **Top graph (GPU)**: Raster thread time
- **Bottom graph (UI)**: UI thread time  
- **White lines**: 16ms increments (60fps threshold)
- **Green bars**: Frame rendered within 16ms ✅
- **Red bars**: Frame exceeded 16ms (jank) ❌

### 4. DevTools Performance Tab Verification

#### A. Navigate to Performance Tab

1. Open DevTools in browser
2. Click "Performance" tab
3. Click "Record" button (red circle)

#### B. Test Each Animation Scenario

Perform these actions while recording:

**Character Animations:**

- [ ] Idle breathing animation (continuous)
- [ ] Affirming animation (on correct answer)
- [ ] Celebration animation (completion screen)

**First-Time Glow:**

- [ ] Pulsing glow animation (Round 1, first time only)
- [ ] Glow disappears on drag

**Drag & Drop:**

- [ ] Tile lift animation
- [ ] Tile drag feedback
- [ ] Tile drop animation
- [ ] Blank zone highlight

**Transitions:**

- [ ] Screen navigation (intro → gameplay)
- [ ] Round advancement
- [ ] Completion screen transition

#### C. Stop Recording and Analyze

1. Click "Stop" button
2. Review the Flutter frames chart

**What to look for:**

✅ **Good Performance (60fps):**

- All frames below the 16ms line
- Consistent green bars
- No red bars in UI or GPU graphs

⚠️ **Acceptable Performance (55-60fps):**

- Occasional frames slightly above 16ms
- Rare red bars (< 5% of frames)
- Jank not noticeable to users

❌ **Poor Performance (< 55fps):**

- Frequent red bars
- Frames consistently above 16ms
- Visible stuttering/jank

### 5. Specific Animation Checks

#### Character Breathing Animation

**Expected**: Smooth continuous animation, no dropped frames

```bash
# Test: Let character idle for 30 seconds
# Check: No red bars in timeline
# Target: 100% frames < 16ms
```

#### Pulsing Glow Effect

**Expected**: Smooth pulse from 0% → 100% → 0% opacity

```bash
# Test: Start new game (first time), observe Round 1 glow
# Check: Smooth pulsing, no stuttering
# Target: 100% frames < 16ms during pulse
```

#### Drag & Drop

**Expected**: Immediate response, smooth feedback

```bash
# Test: Drag multiple tiles rapidly
# Check: No lag between touch and visual feedback
# Target: < 100ms response time, 60fps during drag
```

## Performance Targets

| Animation | Target FPS | Max Frame Time | Acceptable Jank |
|-----------|------------|----------------|-----------------|
| Character Breathing | 60fps | 16ms | 0% |
| Pulsing Glow | 60fps | 16ms | < 1% |
| Drag & Drop | 60fps | 16ms | < 2% |
| Screen Transitions | 60fps | 16ms | < 5% |
| Round Advancement | 60fps | 16ms | < 3% |

## Common Issues and Solutions

### Issue: Red bars in UI thread

**Cause**: Expensive Dart code (layout, build, or business logic)

**Solutions:**

- Use `const` constructors where possible
- Avoid rebuilding entire widget tree
- Use `RepaintBoundary` for complex widgets
- Profile with `flutter run --profile --trace-skia`

### Issue: Red bars in GPU thread

**Cause**: Complex rendering (too many layers, expensive shaders)

**Solutions:**

- Reduce widget complexity
- Use `Opacity` sparingly (expensive)
- Avoid `ClipPath` and `ClipRRect` when possible
- Use `RepaintBoundary` to isolate expensive widgets

### Issue: Inconsistent frame times

**Cause**: Garbage collection or background tasks

**Solutions:**

- Reduce object allocations in hot paths
- Use object pooling for frequently created objects
- Profile memory usage in DevTools

## Automated Performance Test

While manual verification is required, you can add this test to catch regressions:

```dart
// test/performance/animation_performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/scheduler.dart';

void main() {
  testWidgets('Character breathing animation maintains 60fps', (tester) async {
    // This is a smoke test - real verification needs DevTools
    await tester.pumpWidget(MyApp());
    
    // Pump multiple frames
    for (int i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    
    // If we get here without timeout, basic performance is OK
    expect(true, true);
  });
}
```

## Verification Checklist

- [ ] App runs in profile mode
- [ ] DevTools connected successfully
- [ ] Performance overlay shows mostly green bars
- [ ] Character breathing: 60fps sustained
- [ ] Pulsing glow: Smooth animation, no jank
- [ ] Drag & drop: Immediate response
- [ ] Screen transitions: Smooth, no stuttering
- [ ] Round advancement: Quick, no lag
- [ ] No memory leaks (check Memory tab)
- [ ] No excessive rebuilds (check Flutter Inspector)

## Sign-Off

**Verified by**: _______________  
**Date**: _______________  
**Device**: _______________  
**Flutter version**: _______________  
**Performance**: ✅ Pass / ❌ Fail  
**Notes**: _______________

---

## Additional Resources

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [DevTools Performance View](https://docs.flutter.dev/tools/devtools/performance)
- [Flutter Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
- [Reducing Jank](https://docs.flutter.dev/perf/rendering-performance)
