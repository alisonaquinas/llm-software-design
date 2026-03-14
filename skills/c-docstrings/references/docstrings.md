# C documentation convention

## Preferred convention

Doxygen comment blocks

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Doxygen-style comments for headers and public APIs because they are the most widely interoperable source-adjacent convention in C toolchains.

## Best targets

public headers, exported structs, enums, macros, functions

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
 * @brief Initialize the device context.
 * @param ctx Target context.
 * @return 0 on success, negative on failure.
 */
int device_init(device_context *ctx);
```

## External tool access

Doxygen, clang-doc, IDE indexers

```text
doxygen Doxyfile
clang-doc --public headers/*.h
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

Document declarations in headers instead of repeating comments in implementation files. Keep macro documentation adjacent to the macro definition.
