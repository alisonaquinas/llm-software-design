# Objective-C documentation convention

## Preferred convention

AppleDoc or Jazzy-style comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer structured header comments in AppleDoc or Jazzy style because Objective-C tooling and IDE help expect documentation close to declarations in headers.

## Best targets

public headers, classes, protocols, properties, methods, categories

## Canonical syntax

```text
/**
 Add two integers.

 @param a Left operand.
 @param b Right operand.
 @return Sum of the operands.
 */
- (NSInteger)add:(NSInteger)a b:(NSInteger)b;
```

## Example

```text
/**
 Build the current report snapshot.

 @param request Immutable report request.
 @return Generated snapshot.
 */
- (ReportSnapshot *)build:(ReportRequest *)request;
```

## External tool access

Jazzy, Xcode Quick Help, generated Apple-style docs

```text
jazzy --objc
Xcode Quick Help from header comments
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

Document declarations in `.h` files first. Keep implementation-file comments for internal behavior rather than external API contracts.
