# Visual FoxPro documentation convention

## Preferred convention

structured header comments for documenting wizard tools

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer repeatable structured comment headers because Visual FoxPro documentation tooling historically relies on comment parsing rather than a language-native docstring feature.

## Best targets

functions, procedures, classes, forms, major business rules

## Canonical syntax

```text
* Name: AddTotal
* Purpose: Add two amounts and return the total.
FUNCTION AddTotal(a, b)
RETURN a + b
ENDFUNC
```

## Example

```text
* Name: BuildReport
* Purpose: Build the current report snapshot.
FUNCTION BuildReport(request)
...
ENDFUNC
```


## Recommended header fields

Keep Visual FoxPro headers stable so the wizard or scanner can stay predictable.

- Name
- Purpose
- Inputs or Parameters
- Returns or produced state
- Side effects such as table updates, cursor changes, or UI behavior
- Dependencies on forms, classes, environment settings, or work areas

## External tool access

Documenting Wizard, code analysis tooling, generated text docs

```text
Visual FoxPro Documenting Wizard and code analysis tools
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

Keep header field names stable when the legacy tooling already expects a specific template. Migration-friendly consistency matters most.

## Anti-patterns

- documenting a function name but not the cursor, table, or UI state it mutates
- using slightly different field labels across forms and program files so extraction becomes inconsistent
- leaving wizard-visible headers stale after refactors or renamed procedures
- scattering related comments across methods when a single entry summary should define the contract
- hiding environment assumptions such as work area or SET command requirements

## Reference starting points

- Visual FoxPro Documenting Wizard or equivalent legacy extraction settings
- form, cursor, and data-environment standards already used by the codebase
- migration notes for FoxPro code that feeds reports, COM objects, or external automation
