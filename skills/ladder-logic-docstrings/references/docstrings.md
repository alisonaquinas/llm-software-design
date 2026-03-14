# Ladder Logic documentation convention

## Preferred convention

rung, routine, and tag comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer rung, routine, and tag comments because ladder environments usually expose those annotations directly in project exports and operator-facing engineering tools.

## Best targets

rungs, routines, programs, tags, add-on instructions, alarm logic

## Canonical syntax

```text
Rung comment: Reset alarm state when the operator acknowledges the fault.
Tag description: AlarmAck -- Operator acknowledgment input.
```

## Example

```text
Routine description: Build the current report snapshot and publish the result to the historian.
Instruction comment: Scale raw encoder counts to engineering units.
```

## External tool access

controller project exports, engineering reports, tag databases

```text
controller project export, engineering documentation tools, tag reports
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

Document intent, interlocks, fail-safe behavior, and operator-visible effects. Those annotations are more useful than generic prose in control logic.
