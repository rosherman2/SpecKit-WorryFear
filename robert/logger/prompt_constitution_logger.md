# Prompt: Add Logger Principle to Constitution

**Use this prompt when creating/updating a Flutter project's constitution.md:**

---

Add a new principle to the constitution for structured logging (assign the next available principle number):

## Principle [X]: Observability & Debugging

All Flutter code MUST use structured logging via the project's `AppLogger` utility. Logging MUST have zero impact on production builds and use lazy evaluation for all messages.

**Rationale**: Mobile apps are difficult to debug remotely. Structured logging with file persistence enables diagnosing issues in development without affecting release performance.

**Usage Standards**:

**Always log with explicit context:**

```dart
AppLogger.debug('ClassName', 'methodName', () => 'message');
AppLogger.info('ClassName', 'methodName', () => 'message');
AppLogger.warning('ClassName', 'methodName', () => 'message');
AppLogger.error('ClassName', 'methodName', () => 'message');
```

**Key Requirements**:

- **Lazy Evaluation Required**: Use `() => 'message'` syntax - expensive computations only execute in debug mode
- **Explicit Context**: Always provide class name and method name strings
- **Appropriate Severity**:
  - `DEBUG`: Detailed flow (loops, conditionals, data transformations)
  - `INFO`: High-level events (user actions, state changes)
  - `WARNING`: Recoverable issues, deprecated usage
  - `ERROR`: Failures impacting functionality

**What NOT to do**:

```dart
// ❌ BAD: Direct string (evaluates in production)
AppLogger.debug('MyClass', 'method', 'Processing $expensiveCall()');

// ✅ GOOD: Lazy evaluation (zero production cost)
AppLogger.debug('MyClass', 'method', () => 'Processing $expensiveCall()');
```

**Initialization** (in main.dart):

```dart
void main() {
  AppLogger.initialize(
    format: LogFormat.console, // or LogFormat.json
    maxFileSize: 5 * 1024 * 1024,
    maxFiles: 5,
  );
  runApp(MyApp());
}
```

**Guaranteed Behavior**:

- Production builds: Zero overhead, complete code elimination
- Debug builds: Logs to console AND local files
- Loop protection: Automatic throttling prevents spam

**Implementation Location**: `lib/core/utils/app_logger.dart`
