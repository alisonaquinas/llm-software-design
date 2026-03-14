# Kotlin documentation convention

## Preferred convention

KDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer KDoc because it is Kotlin’s native API documentation syntax and integrates cleanly with Dokka and IDE help.

## Best targets

public classes, functions, properties, type parameters, receivers

## Canonical syntax

```text
/**
 * Add two integers.
 *
 * @param a left operand
 * @param b right operand
 * @return sum of the operands
 */
fun add(a: Int, b: Int): Int = a + b
```

## Example

```text
/**
 * Build the current report snapshot.
 *
 * @param request immutable report request
 * @return generated snapshot
 */
fun build(request: ReportRequest): ReportSnapshot = TODO()
```

## External tool access

Dokka, IDE hover help, generated API sites

```text
dokkaHtml
./gradlew dokkaGfm
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

Use Markdown sparingly and keep tag names aligned with the real signature so generated docs stay trustworthy.
