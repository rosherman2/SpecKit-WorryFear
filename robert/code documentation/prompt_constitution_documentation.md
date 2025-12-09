# Prompt: Add Documentation Standards Principle to Constitution

**Use this prompt when creating/updating a Flutter project's constitution.md:**

---

Add a new principle to the constitution for code documentation standards (assign the next available principle number):

## Principle [X]: Code Documentation Standards

All Dart/Flutter code MUST be self-documenting for developers with C++/Java backgrounds. Every class, method, function, and significant variable MUST have complete DartDoc comments. Code must be immediately understandable without deep Flutter expertise.

**Rationale**: Self-documenting code reduces onboarding time for developers with C++/Java backgrounds and prevents misunderstandings of Flutter-specific patterns. Consistent documentation standards ensure code maintainability and knowledge transfer.

---

### Documentation Requirements

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

**Key Principle:** If you had to pause and think "why is this done this way?" while writing the code, add a comment explaining it. The reader (with C++/Java background) will likely have the same question.

---

### Critical Requirements

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

---

### Enforcement

- DartDoc linting MUST be enabled in `analysis_options.yaml`
- All code reviews MUST verify compliance using the quality checklist below
- No pull requests may be merged without complete documentation
- Run `dart doc` to verify zero documentation warnings
- All code must bridge the gap for developers with C++/Java experience

### Quality Checklist

Before merging any Dart/Flutter code, verify:

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

**Target Audience**: Developers with C++/Java experience but limited Flutter knowledge. Write documentation that bridges this gap without being condescending. Be clear, concise, and complete.
