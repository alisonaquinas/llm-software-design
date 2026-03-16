# Zig documentation convention

## Preferred convention

Zig doc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native triple-slash doc comments because Zig tooling can emit documentation directly from them and present them in generated reference output.

## Best targets

public declarations, structs, enums, unions, functions, tests where useful

## Canonical syntax

```text
/// Add two integers and return the sum.
pub fn add(a: i32, b: i32) i32 {
return a + b;
}
```

## Example

```text
/// Build the current report snapshot.
pub fn build(request: ReportRequest) ReportSnapshot {
...
}
```


## Structural expectations

Zig doc comments are emitted from the public declaration surface.

- Put `///` comments directly on `pub` declarations that should appear in generated docs.
- Keep the first sentence concise because generated HTML and editor hovers often surface only that line.
- Prefer documenting public structs, enums, unions, functions, and error sets before tests or private helpers.
- Use examples and safety notes when ownership, allocation, error unions, or comptime behavior matter to callers.
- Re-check emitted docs after refactors because declaration order and visibility shape the public narrative.

## External tool access

zig build docs, emitted HTML docs, editor help

```text
zig build docs
zig test -femit-docs
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

Write comments on the public declaration that gets emitted into docs. Keep examples correct because they often become part of the generated narrative.

## Anti-patterns

- documenting private helpers more carefully than the exported `pub` surface
- writing comments that contradict error unions, allocator requirements, or ownership behavior
- relying on detached comments that do not attach to the actual public declaration
- shipping examples that ignore comptime requirements or allocator setup
- letting generated docs drift after visibility or declaration-order changes

## Reference starting points

- [Zig language documentation](https://ziglang.org/documentation/master/)
- `zig build docs` or `zig test -femit-docs` output in the current repository
- project conventions for allocator, error-set, and `pub` surface documentation
