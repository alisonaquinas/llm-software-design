# Java documentation convention

## Preferred convention

Javadoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer standard Javadoc because it is the native Java API documentation format and feeds IDEs, build plugins, and generated reference sites.

## Best targets

public packages, classes, records, interfaces, methods, fields

## Canonical syntax

```text
/**
 * Add two integers.
 * @param a left operand
 * @param b right operand
 * @return sum of the operands
 */
int add(int a, int b);
```

## Example

```text
/**
 * Build the current report snapshot.
 * @param request immutable report request
 * @return generated snapshot
 * @throws ReportException when generation fails
 */
ReportSnapshot build(ReportRequest request);
```


## Core tag set

Use the smallest truthful Javadoc tag set that still serves callers.

- `@param` and `@return` for argument and result meaning
- `@throws` only when the declared exception path matters to callers
- `@see` and inline `{@link ...}` for navigation
- `@param <T>` for meaningful type parameters
- `{@inheritDoc}` when an override should inherit the parent contract instead of duplicating text
- package and class docs when callers need entry-point guidance beyond member-level comments

## External tool access

javadoc, Maven and Gradle plugins, IDE help

```text
javadoc -d build/docs src/main/java/**/*.java
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

Write documentation on the API surface that external callers use. Keep implementation-detail comments separate from Javadoc.

## Anti-patterns

- treating Javadoc as a place to restate the method name instead of the contract
- omitting type-parameter or throws information where the generic surface is the whole point
- copying comments onto overrides instead of inheriting or adjusting them truthfully
- leaving package-level docs empty while over-documenting tiny private helpers
- using tags that the repository's chosen doclet or build does not render as expected

## Reference starting points

- [Javadoc tool](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/javadoc.html)
- [Documentation Comment Specification for the Standard Doclet](https://docs.oracle.com/en/java/javase/22/docs/specs/javadoc/doc-comment-spec.html)
- build-plugin configuration for Maven or Gradle in the current repository
