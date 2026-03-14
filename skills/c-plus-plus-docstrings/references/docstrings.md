# C++ documentation convention

## Preferred convention

Doxygen comment blocks

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Doxygen-compatible comments because they work across classic C++ documentation generators, IDEs, and many static-analysis pipelines.

## Best targets

public headers, templates, classes, methods, enums, concepts

## Canonical syntax

```text
/**
 * @brief Add two integers.
 * @param a Left operand.
 * @param b Right operand.
 * @return Sum of a and b.
 */
int add(int a, int b);
```

## Example

```text
/**
 * @brief Build the next render frame.
 * @param scene Immutable scene state.
 * @return Prepared frame packet.
 */
FramePacket build_frame(const Scene& scene);
```

## External tool access

Doxygen, clang-doc, IDE hover help

```text
doxygen Doxyfile
clang-doc --public include/**/*.hpp
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

Place comments on declarations in public headers. Avoid duplicating prose on both declaration and definition unless the generator requires it.
