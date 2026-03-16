# X++ documentation convention

## Preferred convention

structured line comments above classes and methods

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined line-comment headers because X++ commonly uses ordinary comments for source documentation and lacks a broadly adopted compiler-emitted docstring system.

## Best targets

public classes, methods, service entry points, table methods

## Canonical syntax

```text
// Add two integers.
// Parameters: a, b
public int add(int a, int b)
{
return a + b;
}
```

## Example

```text
// Build the current report snapshot.
// Parameter: request
public ReportSnapshot build(ReportRequest request)
{
...
}
```


## Recommended header fields

In X++, comment headers are most useful when they explain business and data contracts.

- class or method name
- purpose in one sentence
- parameters, return value, and affected tables or buffers
- side effects such as database writes, infolog messages, or transaction scope
- security or role assumptions when the method is part of a service boundary
- dependencies on forms, queries, classes, or configuration keys

## External tool access

model export, repository indexing, IDE navigation

```text
repository search, model export, internal documentation extraction
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- avoid mixing competing documentation styles in one file unless a staged migration explicitly requires it
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] the chosen convention matches the surrounding toolchain or house style
- [ ] comments are attached to the declarations that external tools inspect
- [ ] summaries describe real behavior without invented guarantees
- [ ] parameters, returns, errors, and examples match the code
- [ ] extraction or verification commands are noted when they materially help review or CI

## Notes

Keep comment templates short and consistent. Put integration effects, table access, and transaction expectations in the header when external reviewers need that context.

## Anti-patterns

- documenting business logic only as technical plumbing without naming the affected tables or transactions
- hiding `ttsbegin` or `ttscommit` implications and infolog side effects from callers
- using inconsistent field labels across service classes and table methods
- placing comments above helper locals instead of the public method or class boundary
- copying comments after a refactor without checking renamed tables, queries, or forms

## Reference starting points

- Dynamics or Finance and Operations coding standards used by the team
- repository guidance for service classes, table methods, and transaction scopes
- code review checklists for security, data writes, and business-event side effects
