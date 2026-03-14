# Scala documentation convention

## Preferred convention

Scaladoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Scaladoc comments because they are the standard API documentation mechanism for Scala libraries and support Markdown-rich generated reference sites.

## Best targets

public classes, traits, objects, methods, type params, givens

## Canonical syntax

```text
/**
 * Add two integers.
 * @param a left operand
 * @param b right operand
 * @return sum of the operands
 */
def add(a: Int, b: Int): Int = a + b
```

## Example

```text
/**
 * Build the current report snapshot.
 * @param request immutable report request
 * @return generated snapshot
 */
def build(request: ReportRequest): ReportSnapshot = ???
```

## External tool access

scaladoc, IDE hover help, generated API sites

```text
scaladoc src/main/scala/**/*.scala
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

Document the library boundary that external callers consume. Avoid burying important contracts in private implementation comments.
