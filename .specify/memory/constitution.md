<!--
## Sync Impact Report
- Version Change: N/A → 1.0.0 (initial creation)
- Added Principles:
  - I. Observability & Debugging (Logger)
  - II. Code Documentation Standards
  - III. Test-Driven Development (TDD)
- Added Sections:
  - Technology Stack
  - Development Workflow
  - Governance
- Templates Requiring Updates:
  - plan-template.md: ⚠️ No changes needed (Constitution Check section exists)
  - spec-template.md: ⚠️ No changes needed
  - tasks-template.md: ⚠️ No changes needed (supports TDD test-first pattern)
- Deferred Items: None
-->

# WorryFear Mobile Game Constitution

## Core Principles

### I. Observability & Debugging

All Flutter code MUST use structured logging via the project's `AppLogger` utility. Logging MUST have zero impact on production builds and use lazy evaluation for all messages.

**Rationale**: Mobile apps are difficult to debug remotely. Structured logging with file persistence enables diagnosing issues in development without affecting release performance.

**Usage Standards**:

Always log with explicit context:

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

---

### II. Code Documentation Standards

All Dart/Flutter code MUST be self-documenting for developers with C++/Java backgrounds. Every class, method, function, and significant variable MUST have complete DartDoc comments. Code must be immediately understandable without deep Flutter expertise.

**Rationale**: Self-documenting code reduces onboarding time for developers with C++/Java backgrounds and prevents misunderstandings of Flutter-specific patterns. Consistent documentation standards ensure code maintainability and knowledge transfer.

**Documentation Requirements**:

#### 1. BALANCED VERBOSITY

- Every class, method, and function MUST have documentation
- Use concise but complete descriptions (2-3 sentences max)
- Essential info only - no unnecessary elaboration
- Think "C++ header comment" style

#### 2. STANDARD FORMATS

**Methods/Functions:**

```dart
/// [Brief description of what it does in one sentence].
/// [Additional behavior, return info, or important notes].
/// 
/// Parameters:
/// - [param1]: Description of parameter
/// - [param2]: Description of parameter
/// 
/// Throws: ExceptionType1, ExceptionType2
Future<ReturnType> methodName(Type param1, Type param2) async {
  // implementation
}
```

**Classes:**

```dart
/// [StatelessWidget/StatefulWidget/Service/Model] [What it does/represents].
/// [Additional context about purpose or behavior].
/// Purpose: [Why this class exists]
/// Navigation: [How user reaches it - for screens only]
class ClassName extends BaseClass {
  // implementation
}
```

**Class Members:**

```dart
class Example {
  /// [Description of what this represents].
  /// [Constraints, validation rules, or business logic].
  final Type memberName;
}
```

#### 3. FLUTTER-SPECIFIC ANNOTATIONS

Always indicate widget type in brackets at the start:

- `[StatelessWidget]` - Immutable widget, no internal state
- `[StatefulWidget]` - Mutable widget with internal state management
- `[Provider]` - State management provider
- `[Service]` - Business logic service
- `[Model]` - Data model/entity

Example:

```dart
/// [StatelessWidget] Displays user's profile picture in a circle.
/// Rebuilds when parent updates, no internal state management.
class ProfileAvatar extends StatelessWidget { ... }
```

#### 4. ASYNC/FUTURE DOCUMENTATION

For all async methods:

```dart
/// Asynchronously [action description].
/// Await this method or use .then() callback.
/// 
/// Throws: NetworkException, TimeoutException
Future<User> getUser(String id) async { ... }
```

#### 5. ERROR HANDLING DOCUMENTATION

**For Critical Methods** (auth, payments, data persistence):

```dart
/// [Method description].
/// 
/// Exceptions:
/// - ExceptionType1: When/why it occurs
/// - ExceptionType2: When/why it occurs
/// - ExceptionType3: When/why it occurs
```

**For Standard CRUD Methods**:

```dart
/// [Method description].
/// Throws: ExceptionType1, ExceptionType2, ExceptionType3
```

#### 6. USAGE EXAMPLES

**Simple Methods** - Inline example:

```dart
/// Fetches user data by ID from API.
/// 
/// Usage: `final user = await getUser('123');`
Future<User> getUser(String id) async { ... }
```

**Complex or Non-Obvious APIs** - Full example:

```dart
/// Validates and processes payment transaction.
/// 
/// Example:
/// ```dart
/// try {
///   final result = await processPayment(
///     amount: 99.99,
///     currency: 'USD',
///     paymentMethod: savedCard
///   );
///   print('Transaction ID: ${result.id}');
/// } catch (e) {
///   handlePaymentError(e);
/// }
/// ```
Future<PaymentResult> processPayment({...}) async { ... }
```

#### 7. CONSTANTS & CONFIGURATION

Always provide full rationale for magic numbers and configuration:

```dart
/// [What this constant controls].
/// [Why this specific value was chosen - rationale].
const Type constantName = value;
```

Example:

```dart
/// Maximum number of retry attempts for failed network requests.
/// Set to 3 based on testing - balances UX and server load.
const int maxRetries = 3;

/// Timeout duration for all API calls.
/// 5 seconds chosen to handle slow 3G connections.
const Duration timeout = Duration(seconds: 5);
```

#### 8. CODE ORGANIZATION

Use section dividers in files with multiple logical groups:

```dart
class UserService {
  // ============================================================
  // API Methods
  // ============================================================
  
  /// Fetches user from REST API.
  Future<User> getUser(String id) async { ... }
  
  /// Updates user profile data.
  Future<void> updateUser(User user) async { ... }
  
  // ============================================================
  // Validation Helpers
  // ============================================================
  
  /// Validates email format using RFC 5322 standard.
  bool validateEmail(String email) { ... }
  
  /// Validates phone number (E.164 international format).
  bool validatePhone(String phone) { ... }
  
  // ============================================================
  // Private Helpers
  // ============================================================
  
  /// Converts API response to User model.
  User _parseUserJson(Map<String, dynamic> json) { ... }
}
```

#### 9. NAVIGATION CONTEXT (Screens Only)

For screen widgets, document how users reach them:

```dart
/// [StatefulWidget] Main profile screen with edit capabilities.
/// Purpose: Displays user profile information with edit/save functionality
/// Navigation: Accessed via bottom navigation "Profile" tab
class ProfileScreen extends StatefulWidget { ... }
```

#### 10. VARIABLE NAMING WITH CONTEXT

Use inline comments for variables when type isn't obvious:

```dart
final controller = TextEditingController();  // Manages username input field
final _debouncer = Debouncer(milliseconds: 300);  // Prevents rapid search API calls
bool _isLoading = false;  // Tracks network request state for loading spinner
```

#### 11. INLINE COMMENTS FOR COMPLEX LOGIC

Add inline comments within method bodies for:

- Non-obvious algorithms or data transformations
- Flutter/Dart-specific idioms that differ from C++/Java conventions
- Business logic decisions with rationale
- Performance optimizations or workarounds
- Why something is done a certain way when it's not immediately clear

**When to add inline comments:**

- Complex conditional logic with multiple branches
- Dart-specific operators or patterns (null-aware, cascade, spread, etc.)
- Non-standard approaches chosen for specific reasons
- Calculations with business rules embedded
- Async/await patterns that aren't straightforward

**Key Principle:** If you had to pause and think "why is this done this way?" while writing the code, add a comment explaining it.

**Critical Requirements**:

✅ **ALWAYS document:** classes, methods, functions, important variables, constants
✅ **ALWAYS include:** Widget type indicator, async behavior, exceptions thrown
✅ **ALWAYS explain:** Why constants have specific values, business rules, validation logic
✅ **ALWAYS provide:** Usage examples for complex APIs
✅ **ALWAYS use:** Section dividers in files with 5+ methods
✅ **ALWAYS add inline comments:** For complex logic, Dart idioms, business decisions, and non-obvious code

❌ **NEVER skip:** Documentation for public APIs
❌ **NEVER assume:** Reader knows Flutter-specific concepts
❌ **NEVER use:** Vague descriptions like "handles stuff" or "manages things"
❌ **NEVER leave complex logic unexplained:** If you had to think about why, add a comment

**Enforcement**:

- DartDoc linting MUST be enabled in `analysis_options.yaml`
- All code reviews MUST verify compliance using the quality checklist below
- No pull requests may be merged without complete documentation
- Run `dart doc` to verify zero documentation warnings

**Quality Checklist**:

- [ ] Every class has type indicator (`[StatelessWidget]`, `[Service]`, etc.) and purpose
- [ ] Every method has description and parameter docs
- [ ] All async methods note await requirement
- [ ] All exceptions are documented
- [ ] Constants explain their values and rationale
- [ ] Complex logic has usage examples where appropriate
- [ ] Section dividers separate logical groups (files with 5+ methods)
- [ ] Comments use correct DartDoc style (`///`)
- [ ] Navigation context included for screen widgets
- [ ] Complex logic and Dart idioms have inline explanatory comments
- [ ] `dart doc` runs without warnings
- [ ] Code is immediately understandable for C++/Java developers

---

### III. Test-Driven Development (TDD)

All new features and meaningful behavior changes MUST follow the TDD Red-Green-Refactor cycle. Tests describe desired behavior before implementation. No behavior changes without tests.

**Rationale**: TDD ensures code correctness, prevents regressions, and forces clean API design. Writing tests first creates executable documentation and reduces debugging time.

**Test-First Development**:

- **New features**: Write tests first, then implement code to make them pass
- **Existing untested code with behavior changes**: Add tests describing desired behavior first, then modify code
- **Scope**: Only test functions/methods/flows you are actively changing — do not retroactively test unrelated code
- **Exceptions**: Purely cosmetic changes (comments, renames, formatting) may skip tests, but NEVER mix cosmetic and behavior changes

**Test Distribution (Testing Pyramid)**:

| Level | Coverage | Target |
|-------|---------|--------|
| Unit tests | 60–70% | Individual functions/classes in isolation |
| Widget tests | 20–30% | UI components and their behavior |
| Integration tests | 10–15% | Complete user flows |

**Red-Green-Refactor Cycle**:

1. **🔴 Red**: Write a failing test describing desired behavior
2. **🟢 Green**: Write straightforward, reasonably clean implementation (no fake implementations)
3. **🔵 Refactor** with this priority:
   - Improve naming for clarity
   - Extract methods to reduce complexity
   - Remove obvious duplication within the same module
   - Keep dependencies injected and respect layering
   - Do NOT introduce heavy abstractions unless complexity clearly justifies it

**Testing Libraries (Mandatory)**:

```yaml
dev_dependencies:
  test: ^latest
  flutter_test: sdk
  mocktail: ^latest      # Mocking and stubbing
  bloc_test: ^latest     # Only when testing BLoC classes
```

**Test Structure and Naming**:

Required Organization Pattern:

```dart
group('ClassName or FeatureName', () {
  group('methodName or behavior', () {
    test('should do X when Y happens', () {
      // Arrange: Set up test data and dependencies

      // Act: Execute the behavior being tested

      // Assert: Verify the expected outcome
    });
  });
});
```

**Rules:**

- Use **AAA pattern** (Arrange-Act-Assert) with inline comments
- Use **behavior-oriented test names**: `test('should do X when Y happens')`
- Use `group()` blocks for organization by class/feature, then by behavior
- **Maintain consistency** — do not invent new styles per file

**Test Data and Fixtures**:

| Approach | When to Use |
|----------|-------------|
| Inline data | Small objects, few tests |
| Test builders (in `test/support/` or `test/factories/`) | Complex objects, many tests, verbose setup |

**Rule**: Start with inline data, introduce builders only when needed. No large fixture files.

**Async Testing**:

**Futures:**

- Always use `async`/`await`, not `.then()`

**Streams:**

- Use `expectLater` with `emits`, `emitsInOrder`, or similar matchers

**Widget Tests:**

- `pumpWidget`: Load the widget
- `pump(Duration(...))`: Advance time after actions
- `pumpAndSettle`: Use only when needed for navigation or async completion

**Time-Dependent Behavior:**

- **NEVER rely on real time**
- Pure Dart tests: Use `fake_async` and `elapse(...)`
- Widget tests: Use `pump(Duration(...))`
- **Goal**: Zero timing-based flakiness

**Dependency Injection**:

- **Always inject dependencies through constructors** — no global singletons or service locators
- Put all external dependencies (APIs, databases, platform services) behind **interfaces/abstract classes**
- **No DI frameworks** (`get_it`, etc.) — keep wiring explicit in `main.dart` and composition functions
- Follow layered architecture: **Presentation** → **Application/Services** → **Domain** → **Data**

**Error Handling and Edge Cases**:

| Code Type | Required Tests |
|-----------|----------------|
| Critical flows (auth, payments, data) | Multiple error tests |
| Normal flows | At least one error/edge test |
| Trivial helpers | Happy path may be sufficient |

**Edge Cases to Cover:**

- Empty or null input
- Boundary values
- Invalid parameters
- Network/storage errors

**Focus areas**: Core domain logic, external boundaries (API, storage, platform services, authentication)

**Assertion Messages**:

- **Default**: Rely on matcher defaults: `expect(actual, matcher)`
- **Add `reason:`** only when:
  - Assertion is complex
  - Part of a multi-step flow
  - Inside a loop of scenarios
  - Default failure output would be unclear

**Output Format (Agent Workflow)**:

1. **First**: Output the test code you are adding/changing
2. **Then**: Output the implementation code that makes tests pass
3. **Finally**: Brief 2–3 bullet summary of:
   - What behaviors were tested
   - What code was implemented or refactored

**Critical Requirements**:

✅ **ALWAYS**: Write tests before implementing new behavior
✅ **ALWAYS**: Use AAA pattern with inline comments
✅ **ALWAYS**: Inject dependencies through constructors
✅ **ALWAYS**: Test at least one happy path and one sad path
✅ **ALWAYS**: Use `mocktail` for mocking

❌ **NEVER**: Make behavior changes without tests
❌ **NEVER**: Use real time in tests (fake_async or pump instead)
❌ **NEVER**: Use global singletons or service locators
❌ **NEVER**: Mix cosmetic and behavior changes
❌ **NEVER**: Introduce abstractions without clear complexity justification

**Enforcement**:

- Test coverage MUST be measured and tracked
- All code reviews MUST verify TDD compliance
- No pull requests may merge behavior changes without corresponding tests
- Run full test suite before merging: `flutter test`

**Quality Checklist**:

- [ ] Tests written BEFORE implementation (TDD)
- [ ] Test names describe behavior (`should X when Y`)
- [ ] AAA pattern used with inline comments
- [ ] Group blocks organize by class/feature
- [ ] At least one happy path and one sad path tested
- [ ] Async tests use proper patterns (no real time)
- [ ] Dependencies injected via constructors
- [ ] Mocks created with `mocktail`
- [ ] Test pyramid followed (unit > widget > integration)
- [ ] All tests pass: `flutter test`

---

## Technology Stack

**Language/Version**: Dart 3.x / Flutter 3.x
**Platform**: Mobile (iOS & Android)
**State Management**: flutter_bloc
**Testing**: flutter_test, mocktail, bloc_test
**Architecture**: Clean Architecture (Presentation → Application → Domain → Data)

---

## Development Workflow

**Code Review Requirements**:

1. All PRs MUST verify compliance with the three principles above
2. Documentation checklist MUST be verified before merge
3. TDD quality checklist MUST be verified before merge
4. Logger usage MUST be verified for new functionality

**Quality Gates**:

1. `flutter analyze` MUST pass with zero warnings
2. `dart doc` MUST run without warnings
3. `flutter test` MUST pass with all tests green
4. Test coverage MUST meet pyramid distribution targets

---

## Governance

This constitution supersedes all other development practices. Amendments require:

1. Written documentation of the proposed change
2. Clear rationale for why the change is necessary
3. Assessment of impact on existing code
4. Update to this document with version increment

All development work MUST be guided by the principles defined in this constitution. Complexity must be justified against these principles.

Use `.specify/` for runtime development guidance and feature specifications.

**Version**: 1.0.0 | **Ratified**: 2025-12-09 | **Last Amended**: 2025-12-09
