# TDD Guide


## Purpose


Test-driven development is a design discipline in which behavior is specified through a short cycle of writing a failing test, making it pass, and then refactoring. The core value is not only defect detection; it is feedback about design, coupling, naming, and boundary placement while the code is still small.

## The Core Loop


1. **Red**: express the next behavior as one failing test.
2. **Green**: make that one test pass with the smallest plausible change.
3. **Refactor**: remove duplication, clarify names, and improve structure while tests stay green.

This loop is most effective when each cycle is measured in minutes, not hours.

## Good TDD Test Characteristics


Microsoft's unit testing guidance emphasizes that good tests are **fast, isolated, repeatable, self-checking, and timely**. Treat those as gates before accepting a test into the fast inner loop. Source: Microsoft Learn, "Best practices for writing unit tests".  
<https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices>

### Fast


- Prefer pure-domain tests or narrow slice tests for the inner loop.

- Move container startup, real network calls, and full browser automation out of the innermost cycle.

### Isolated


- Control time, randomness, filesystem access, and network effects.

- Replace external collaborators with seams such as injected clocks, repositories, queues, or ports.

### Repeatable


- Eliminate dependence on execution order and shared mutable state.

- Rust's test runner documentation notes that tests run in parallel by default; hidden shared state becomes a flake amplifier. Source: The Rust Programming Language, "Controlling How Tests Are Run".  
<https://doc.rust-lang.org/book/ch11-02-running-tests.html>

### Self-checking


- A test should compute pass or fail automatically.

- Avoid manual log inspection as the primary assertion mechanism.

### Timely


- Write the test when a behavior is being designed or fixed, not after a large implementation has already stabilized.

## Design Signals TDD Exposes


### Too many constructor arguments

Often a sign that one unit owns too many responsibilities or that a missing façade/module boundary exists.

### Hard-to-create test data

Often a sign that the model is too coupled to infrastructure concerns, persistence shape, or framework objects.

### Excessive mocking

Often a sign that the design is interaction-heavy instead of behavior-oriented, or that the test is exercising too many collaborators at once.

### Brittle assertions

Often a sign that the code exposes the wrong contract or that the test is specifying sequence and implementation details rather than outcome.

## Test Levels in a TDD-Oriented Stack


### Unit tests

Use for pure business rules, small policies, parsers, allocation logic, value objects, and error handling rules.

### Slice or component tests

Use when the behavior spans a few local modules and a realistic composition provides better signal than mocking every collaborator.

### Integration tests

Use for database mappings, API wiring, contract checks, migration safety, queue integration, and framework bootstrapping.

### End-to-end tests

Use sparingly to verify a few critical cross-system journeys, not every branch.

## Framework Notes from Primary Sources


### Python / pytest

pytest recommends keeping tests outside application code, using editable installs for local development, and for new projects considering `--import-mode=importlib` to avoid path-related ambiguity. Source: pytest documentation, "Good Integration Practices".  
<https://docs.pytest.org/en/stable/explanation/goodpractices.html>

### C++ / GoogleTest

GoogleTest distinguishes `EXPECT_*` from `ASSERT_*`: the first records a nonfatal failure and continues; the second aborts the current function on failure. Use that distinction to keep tests readable without cascading null dereferences or meaningless follow-up checks. Source: GoogleTest Primer.  
<https://google.github.io/googletest/primer.html>

### C# / .NET

Microsoft Learn recommends avoiding multiple acts inside one test, avoiding logic in test bodies, and using clear naming. It also recommends extracting infrastructure behind interfaces or abstractions so tests remain focused. Source: Microsoft Learn, "Best practices for writing unit tests".  
<https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices>

### Rust

Rust's standard tooling treats tests as a first-class part of `cargo`. Unit tests typically live close to the code they validate, while integration tests sit in `tests/`. Source: The Rust Programming Language, Chapter 11.  
<https://doc.rust-lang.org/book/ch11-01-writing-tests.html>

## Common Failure Modes



- **Test-last drift**: writing large code blocks before creating a failing test.

- **Assertion-free tests**: relying on "no exception thrown" for behaviors that deserve explicit outcomes.

- **Mock-driven design without domain pressure**: creating interfaces only to satisfy mocking frameworks.

- **Overly broad first tests**: starting at full-system scope before the design vocabulary exists.

- **Refactor debt**: repeatedly adding passing behavior without pausing to remove duplication.

## Practical Review Checklist



- What behavior is being specified by the next test?

- Is this the fastest reliable place to observe that behavior?

- Does the failure message explain a real missing capability?

- What design seam is the test forcing into the code?

- After green, what duplication or naming issue should be cleaned up before the next test?

## Suggested Book and Community References


These are influential secondary references worth citing in prose or code reviews when helpful:


- Kent Beck, *Test-Driven Development: By Example*

- Gerard Meszaros, *xUnit Test Patterns*

- Vladimir Khorikov, *Unit Testing Principles, Practices, and Patterns*
