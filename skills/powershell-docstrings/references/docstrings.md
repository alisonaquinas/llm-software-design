# PowerShell documentation convention

## Preferred convention

comment-based help blocks

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer comment-based help because it is native to PowerShell, directly queryable with `Get-Help`, and convertible into external help formats.

## Best targets

functions, scripts, advanced functions, modules, cmdlets

## Canonical syntax

```text
<#
.SYNOPSIS
Add two integers.
.PARAMETER A
Left operand.
.PARAMETER B
Right operand.
.OUTPUTS
System.Int32
#>
function Add-Numbers {
param([int]$A, [int]$B)
$A + $B
}
```

## Example

```text
<#
.SYNOPSIS
Build the current report snapshot.
.PARAMETER Request
Immutable report request.
#>
function New-ReportSnapshot {
param($Request)
...
}
```

## External tool access

Get-Help, platyPS, MAML-based help generation

```text
Get-Help Add-Numbers -Full
platyPS for external markdown help
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

Keep parameter names and examples current. Operators often experience the documentation first through `Get-Help`, not through the source file.
