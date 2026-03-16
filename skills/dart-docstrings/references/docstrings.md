# Dart documentation convention

## Preferred convention

dartdoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native triple-slash comments because dartdoc consumes them directly and the format is standard across package ecosystems.

## Best targets

public libraries, classes, methods, enums, typedefs, extensions

## Canonical syntax

```text
/// Add two integers.
int add(int a, int b) => a + b;
```

## Example

```text
/// Build the current report snapshot.
ReportSnapshot build(ReportRequest request) {
  ...
}
```


## Structural expectations

Dart doc comments are lightweight, but they still have strong conventions.

- Prefer `///` comments so `dart doc` and the linter can discover them cleanly.
- Keep the first sentence concise because package indexes and hover help often surface only that line.
- Use Markdown sparingly for examples, lists, and links that survive into generated docs.
- Document public libraries, classes, extensions, enums, and members before private helpers.
- When cross-library references matter, use the repository's chosen doc-reference pattern instead of inventing ad hoc names.

## External tool access

dartdoc, IDE hover help, package reference sites

```text
dart doc
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

Keep the first sentence concise because it becomes the summary line in generated package indexes.

## Anti-patterns

- using ordinary `//` comments for public API docs that `dart doc` should discover
- forcing `/** ... */` blocks into a codebase that already standardizes on `///`
- writing a long first paragraph that hides the useful summary line in generated docs
- documenting private implementation detail more carefully than the exported package surface
- letting intra-doc references drift when symbols or imports change

## Reference starting points

- [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
- [dart doc](https://dart.dev/tools/dart-doc)
- [Documentation comment references](https://dart.dev/tools/doc-comments/references)
