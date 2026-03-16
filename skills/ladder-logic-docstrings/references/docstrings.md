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


## What to document

Ladder logic comments are most valuable when they explain operator-visible and safety-relevant intent.

- routine purpose and plant-area context
- rung intent, permissives, interlocks, and fail-safe behavior
- tag meaning, engineering units, scaling assumptions, and alarm semantics
- start-up, shutdown, manual-mode, and fault-recovery behavior when it affects operators or technicians
- historian or HMI side effects when the logic feeds downstream reporting

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

## Anti-patterns

- commenting only that a rung "turns output on" without naming the permissive or interlock logic
- omitting fail-safe or manual-mode behavior that maintenance staff rely on
- using generic tag descriptions that do not explain engineering units or equipment mapping
- leaving alarm and acknowledgment semantics implicit
- mixing controller, HMI, and electrical drawing terminology without clarifying the intended operator view

## Reference starting points

- controller vendor export documentation and comment fields for the active platform
- plant alarm philosophy, interlock matrix, and tag naming standards
- integrator or maintenance documentation for the controlled equipment
