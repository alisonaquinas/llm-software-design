# Wolfram documentation convention

## Preferred convention

usage messages on public symbols

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer usage messages on public symbols because they are the primary source-adjacent documentation surface exposed by the Wolfram Language help system.

## Best targets

public symbols, package exports, options, message groups

## Canonical syntax

```text
AddTotal::usage = "AddTotal[a, b] returns the sum of a and b.";
```

## Example

```text
BuildReport::usage = "BuildReport[request] returns the current report snapshot.";
```


## Package structure expectations

In Wolfram packages, usage messages are part of the exported symbol contract.

- Put usage messages for public symbols between `BeginPackage[...]` and `Begin["`Private`"]`.
- Keep the usage string concise and signature-shaped so `?symbol` output stays readable.
- Document public options, symbols, and major message groups before private helper definitions.
- Use richer notebook, paclet, or guide documentation only when the project already ships that layer.
- Keep usage messages aligned with actual argument structure, option names, and package context.

## External tool access

question-mark help queries, notebook help integration, paclet documentation workflows

```text
?AddTotal
DocumentationTools or paclet workflows when the codebase uses them
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

Keep the usage string concise and signature-shaped. Add richer notebook or paclet docs only when the project already invests in that packaging layer.

## Anti-patterns

- defining public functions without usage messages in the exported package section
- writing long narrative usage strings that obscure the signature and main contract
- describing option defaults or argument patterns that no longer match the real definition
- documenting private symbols as if they were public package surface
- splitting the authoritative contract between usage messages and notebook prose without checking consistency

## Reference starting points

- [Create a Package File](https://reference.wolfram.com/language/workflow/CreateAPackageFile.html)
- [Messages guide](https://reference.wolfram.com/language/guide/Messages.html.en)
- project conventions for paclets, guide pages, and public symbol usage messages
