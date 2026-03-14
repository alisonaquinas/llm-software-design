# C documentation convention

## Preferred convention

Doxygen comment blocks

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- prefer documenting declarations in public headers because that is what most external tools index

## Why this is the default

C does not have a language-native docstring facility, so the most interoperable source-adjacent convention is a structured Doxygen block. Doxygen-style comments work well for headers, macros, enums, structs, and functions, and many IDEs or AST-based tools can consume or at least preserve them.

## Best targets

- public headers
- exported functions
- public structs, enums, typedefs, and callback signatures
- macros whose semantics are part of the supported API
- configuration objects and error-code families used across modules

## What to document

At minimum, document the parts that callers cannot safely infer from the signature alone:

- ownership and lifetime expectations
- input and output buffers, including required sizes
- nullability and mutability expectations
- return value meaning, including error conventions
- thread-safety, reentrancy, or interrupt-context constraints when relevant
- preconditions, postconditions, and units for numeric parameters

## Canonical syntax

```text
/**
 * @brief Initialize the device context.
 * @param[out] ctx Target context to initialize.
 * @param[in] config Immutable configuration values.
 * @return 0 on success, negative error code on failure.
 */
int device_init(device_context *ctx, const device_config *config);
```

## Macro example

```text
/**
 * @brief Convert kibibytes to bytes.
 * @param n Value in KiB.
 * @return Number of bytes.
 */
#define KIB_TO_BYTES(n) ((n) * 1024u)
```

## Tooling notes

- Place comments on the declaration that appears in the public header rather than only on the `.c` definition.
- Use one consistent tag vocabulary across the repository, commonly `@brief`, `@param`, `@return`, `@retval`, `@note`, and `@warning`.
- Avoid repeating the exact same prose on both declaration and definition unless the generator requires it.

## External tool access

```text
doxygen Doxyfile
clang-doc --public headers/*.h
```

## Migration guidance

- convert detached block comments into declaration-adjacent documentation blocks
- document the exported header surface first, then add internal documentation only where maintenance risk justifies it
- standardize ownership and buffer wording before polishing style
- verify generated docs or indexed hover help after changes

## Review checklist

- [ ] The comment is attached to the declaration external callers inspect.
- [ ] Parameter names exactly match the declaration.
- [ ] Ownership, mutability, and size expectations are explicit.
- [ ] Error returns or output-parameter semantics are truthful and specific.
- [ ] `@warning` and `@note` are used for real hazards, not for filler text.

## Anti-patterns

- documenting only the implementation file while leaving the public header opaque
- describing a pointer parameter without saying whether it may be null or how much storage it requires
- copying stale prose across declaration and definition
- inventing thread-safety or performance guarantees the code does not actually provide
- hiding critical API behavior in ad hoc prose comments that generators ignore

## Reference starting points

- [Doxygen documentation blocks](https://www.doxygen.nl/manual/docblocks.html)
- [C reference](https://en.cppreference.com/w/c)
