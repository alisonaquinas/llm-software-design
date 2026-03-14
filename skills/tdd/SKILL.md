---
name: tdd
description: >
  drive design with test-first development, fast feedback loops, and small
  refactoring steps. use when the user asks how to apply test-driven
  development, how to write the next failing test, how to design seams for
  testability, how to keep tests fast and isolated, or how to map red-green-
  refactor into python, typescript, javascript, c, c++, c#, rust, or related
  test frameworks.
---

# TDD

Use this skill to shape code through a test-first workflow instead of designing the full implementation up front.

## Intent Router

| Need | Load |
| --- | --- |
| red-green-refactor workflow, seam design, test quality heuristics, and anti-patterns | `references/tdd-guide.md` |
| language and framework examples for python, typescript, javascript, c, c++, c#, and rust | `references/language-examples.md` |

## Quick Start

1. Start from one observable behavior, not an internal helper.
2. Write the smallest failing test that names the next capability.
3. Make the test pass with the simplest implementation that preserves intent.
4. Refactor only while the test suite stays green.
5. Keep the cycle small enough that each failure explains one design decision.

## Workflow

1. Restate the requirement as an example with a single input, action, and expected outcome.
2. Choose the narrowest test level that gives fast feedback and exposes the behavior clearly.
3. Write one failing test and explain why it fails now.
4. Add the minimum implementation needed to make that test pass.
5. Refactor names, duplication, and structure only after green.
6. Repeat by promoting the next edge case, rule, or collaboration seam into its own failing test.
7. When the design involves I/O, time, randomness, or concurrency, first create a seam that makes the behavior deterministic under test.

## Outputs to Prefer

- express progress as explicit red-green-refactor steps
- keep each suggested test narrow, deterministic, and fast
- tie design advice to what the next test forces into existence
- favor test names that describe business intent or externally visible behavior
- separate unit-level feedback from slower integration or acceptance checks

## Common Requests

```text
Given this requirement or bug, propose the next failing test and the smallest implementation step.
```

```text
Review this test suite for TDD drift, overspecification, brittle mocks, or design signals revealed by the tests.
```

```text
Show a red-green-refactor sequence in Python, TypeScript, JavaScript, C, C++, C#, or Rust.
```

## Safety Notes

- do not start with broad end-to-end scenarios when a focused unit or slice test would reveal the design faster
- avoid asserting incidental implementation details unless those details are part of the contract
- avoid large speculative abstractions before a failing test proves the seam is needed
- do not let mocks replace domain thinking; use them only where a true boundary exists
