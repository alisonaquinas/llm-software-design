# TypeScript documentation convention

## Preferred convention

TSDoc-style JSDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer TSDoc-compatible comments because TypeScript ecosystems commonly combine JSDoc syntax with stricter TSDoc tag semantics for API extraction.

## Best targets

exported functions, interfaces, classes, type aliases, namespaces

## Canonical syntax

```text
/**
 * Add two integers.
 * @param a - Left operand.
 * @param b - Right operand.
 * @returns Sum of the operands.
 */
export function add(a: number, b: number): number {
  return a + b;
}
```

## Example

```text
/**
 * Build the current report snapshot.
 * @param request Immutable report request.
 * @returns Generated snapshot.
 */
export function build(request: ReportRequest): ReportSnapshot {
  ...
}
```

## External tool access

TypeDoc, API Extractor, TS server, IDE hover help

```text
typedoc src
api-extractor run
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

Document the emitted API surface, not only the source-level implementation detail. That matters when declaration files are the external contract.
