# Prompt: Add Logger Task to tasks.md

**Use this prompt when creating tasks.md for a Flutter project (add to Phase 1: Setup):**

---

Add this task to **Phase 1: Setup**:

```markdown
- [ ] T0XX [P] Create AppLogger utility in lib/core/utils/app_logger.dart with structured logging, file rotation, and zero production impact
```

**Implementation Specification**:

Create `lib/core/utils/app_logger.dart` with the following:

## 1. Severity Levels

Implement four levels as static methods: `debug`, `info`, `warning`, `error`

## 2. API Signature

```dart
class AppLogger {
  static void initialize({
    required LogFormat format,  // enum: console or json
    int maxFileSize = 5 * 1024 * 1024,  // 5MB default
    int maxFiles = 5,  // keep 5 most recent files
  });

  static void debug(String className, String methodName, String Function() messageFn);
  static void info(String className, String methodName, String Function() messageFn);
  static void warning(String className, String methodName, String Function() messageFn);
  static void error(String className, String methodName, String Function() messageFn);
}

enum LogFormat { console, json }
```

## 3. Zero Production Impact

Wrap ALL operations in `if (kDebugMode)` from `package:flutter/foundation.dart`:

```dart
static void debug(String className, String methodName, String Function() messageFn) {
  if (kDebugMode) {
    final message = messageFn();  // only evaluated in debug
    _writeToConsole(message);
    _writeToFile(message);
  }
}
```

## 4. Loop Throttling

- Track last log time per unique `"$className.$methodName"` location
- Only log if >1 second elapsed since last log from same location
- Use `Map<String, DateTime>` to store last log times
- After throttle expires, allow logging again

## 5. Dual Output

### Console Format (Human-Readable)

```text
[2025-12-03 14:30:45.123] [DEBUG] MyClass.myMethod: Processing item 5
[2025-12-03 14:30:45.456] [ERROR] NetworkClient.fetchData: Connection timeout
```

Format: `[timestamp] [LEVEL] className.methodName: message`

### JSON Format

```json
{
  "timestamp": "2025-12-03T14:30:45.123Z",
  "severity": "DEBUG",
  "class": "MyClass",
  "method": "myMethod",
  "message": "Processing item 5",
  "throttled": false
}
```

Include fields: timestamp (ISO 8601), severity, class, method, message, throttled (boolean)

## 6. File Management

**File Naming**: `app_log_YYYY_MM_DD_HH_mm_ss.log` (sortable timestamps)

**Rotation Logic**:

1. Monitor current log file size
2. When size exceeds `maxFileSize`, create new file
3. Delete oldest files when count exceeds `maxFiles`
4. Ensure atomic rotation (no data loss)

**Storage Location**:

- Use `path_provider` package
- Store in `{documents_directory}/logs/` subdirectory (cross-platform)
- Create the `logs` subdirectory if it doesn't exist on first initialization

**Thread Safety**:

- Use `synchronized` package or mutex for file writes
- Handle concurrent logging from multiple isolates/futures
- Prevent file corruption from simultaneous writes

## 7. Error Handling

- Catch all file system errors gracefully
- Fallback to console-only if file write fails
- Log file errors to console for debugging
- Never crash app due to logging failure

## 8. Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  path_provider: any  # Use the latest compatible version from pub.dev
```

## 9. Testing Checklist

- [ ] Test file rotation when file exceeds 5MB
- [ ] Test old file cleanup (verify only N files kept)
- [ ] Test throttling prevents spam in loops
- [ ] Test concurrent logging from multiple isolates
- [ ] Verify zero production impact (check release build binary size)
- [ ] Test both console and JSON output formats
- [ ] Test error handling (disk full, permission denied)
- [ ] Test initialization with different configurations

## 10. Implementation Notes

- Single file implementation (self-contained)
- Static methods for easy access throughout app
- No instance creation needed
- Minimal external dependencies
- Production-safe by default (all code wrapped in `kDebugMode`)
