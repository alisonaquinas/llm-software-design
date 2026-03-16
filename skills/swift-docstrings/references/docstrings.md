# Swift documentation convention

## Preferred convention

Swift Markup comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native Swift Markup comments because Xcode Quick Help and DocC understand them directly and keep the documentation close to the API.

## Best targets

public types, methods, properties, protocols, extensions

## Canonical syntax

```text
/// Add two integers.
/// - Parameters:
///   - a: Left operand.
///   - b: Right operand.
/// - Returns: Sum of the operands.
func add(_ a: Int, _ b: Int) -> Int {
a + b
}
```

## Example

```text
/// Build the current report snapshot.
/// - Parameter request: Immutable report request.
/// - Returns: Generated snapshot.
func build(_ request: ReportRequest) -> ReportSnapshot {
...
}
```


## Markup patterns

Swift Markup favors readable prose with lightweight field markers.

- Start with a concise summary sentence on the declaration users see in Quick Help.
- Use `- Parameter`, `- Parameters:`, `- Returns:`, and `- Throws:` when the contract needs structure.
- Document public protocols, extensions, property wrappers, and async APIs before private helpers.
- Keep examples short and truthful; Quick Help is often the first consumer.
- Prefer comments on the symbol that Swift-DocC or Xcode will surface rather than detached narrative elsewhere.

## External tool access

DocC, Xcode Quick Help, SourceKit-based tooling

```text
swift package generate-documentation
docc convert
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

Favor the standard parameter and returns bullets so Quick Help renders consistent structured output.

## Anti-patterns

- mixing several markup idioms in one file without checking the rendered Quick Help output
- ignoring async, throwing, or actor-isolation behavior that callers need to know
- documenting extension methods without clarifying the receiver constraints that make them available
- writing examples that compile only with hidden imports or platform assumptions
- overusing long narrative where a clear parameter or returns section would be easier to scan

## Reference starting points

- [Markup Formatting Reference](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/)
- [Swift-DocC](https://www.swift.org/documentation/docc/)
- project conventions for Quick Help, platform availability, and sample code
