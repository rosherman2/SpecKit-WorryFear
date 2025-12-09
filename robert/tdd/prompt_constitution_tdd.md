# Prompt: Add TDD Principle to Constitution

**Use this prompt when creating/updating a Flutter project's constitution.md:**

---

Add a new principle to the constitution for Test-Driven Development (assign the next available principle number):

## Principle [X]: Test-Driven Development (TDD)

All new features and meaningful behavior changes MUST follow the TDD Red-Green-Refactor cycle. Tests describe desired behavior before implementation. No behavior changes without tests.

**Rationale**: TDD ensures code correctness, prevents regressions, and forces clean API design. Writing tests first creates executable documentation and reduces debugging time.

---

### Test-First Development

- **New features**: Write tests first, then implement code to make them pass
- **Existing untested code with behavior changes**: Add tests describing desired behavior first, then modify code
- **Scope**: Only test functions/methods/flows you are actively changing — do not retroactively test unrelated code
- **Exceptions**: Purely cosmetic changes (comments, renames, formatting) may skip tests, but NEVER mix cosmetic and behavior changes

### Test Distribution (Testing Pyramid)

| Level | Coverage | Target |
|-------|---------|--------|
| Unit tests | 60–70% | Individual functions/classes in isolation |
| Widget tests | 20–30% | UI components and their behavior |
| Integration tests | 10–15% | Complete user flows |

### Red-Green-Refactor Cycle

1. **🔴 Red**: Write a failing test describing desired behavior
2. **🟢 Green**: Write straightforward, reasonably clean implementation (no fake implementations)
3. **🔵 Refactor** with this priority:
   - Improve naming for clarity
   - Extract methods to reduce complexity
   - Remove obvious duplication within the same module
   - Keep dependencies injected and respect layering
   - Do NOT introduce heavy abstractions unless complexity clearly justifies it

---

### Testing Libraries (Mandatory)

```yaml
dev_dependencies:
  test: ^latest
  flutter_test: sdk
  mocktail: ^latest      # Mocking and stubbing
  bloc_test: ^latest     # Only when testing BLoC classes
```

---

### Test Structure and Naming

**Required Organization Pattern:**

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

---

### Test Data and Fixtures

| Approach | When to Use |
|----------|-------------|
| Inline data | Small objects, few tests |
| Test builders (in `test/support/` or `test/factories/`) | Complex objects, many tests, verbose setup |

**Rule**: Start with inline data, introduce builders only when needed. No large fixture files.

---

### Async Testing

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

---

### Dependency Injection

- **Always inject dependencies through constructors** — no global singletons or service locators
- Put all external dependencies (APIs, databases, platform services) behind **interfaces/abstract classes**
- **No DI frameworks** (`get_it`, etc.) — keep wiring explicit in `main.dart` and composition functions
- Follow layered architecture: **Presentation** → **Application/Services** → **Domain** → **Data**

---

### Error Handling and Edge Cases

**Testing Requirements:**

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

---

### Assertion Messages

- **Default**: Rely on matcher defaults: `expect(actual, matcher)`
- **Add `reason:`** only when:
  - Assertion is complex
  - Part of a multi-step flow
  - Inside a loop of scenarios
  - Default failure output would be unclear

---

### Output Format (Agent Workflow)

1. **First**: Output the test code you are adding/changing
2. **Then**: Output the implementation code that makes tests pass
3. **Finally**: Brief 2–3 bullet summary of:
   - What behaviors were tested
   - What code was implemented or refactored

---

### Critical Requirements

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

---

### Enforcement

- Test coverage MUST be measured and tracked
- All code reviews MUST verify TDD compliance
- No pull requests may merge behavior changes without corresponding tests
- Run full test suite before merging: `flutter test`

### Quality Checklist

Before merging any behavior change, verify:

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

**Core Principle**: Be pragmatic — test business logic and critical paths thoroughly; trivial code can have minimal tests. Be consistent — follow these conventions in every file. Be disciplined — no meaningful behavior changes without tests.
