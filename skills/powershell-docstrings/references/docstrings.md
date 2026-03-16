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


## Help section map

Comment-based help is most useful when it mirrors the way PowerShell users ask for help.

- `.SYNOPSIS` for the one-line summary
- `.DESCRIPTION` for longer behavioral context when needed
- `.PARAMETER`, `.INPUTS`, and `.OUTPUTS` for command contracts
- `.EXAMPLE` for concrete usage that can survive real testing
- `.LINK` or related sections for navigation to sibling commands or external docs
- keep help blocks adjacent to the function or script entry point that `Get-Help` resolves

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

## Anti-patterns

- writing a strong synopsis but leaving parameters undocumented or stale
- using examples that depend on hidden session state or missing module imports
- documenting wrapper functions while the public advanced function users invoke has no help block
- treating `.INPUTS` and `.OUTPUTS` as optional when pipeline semantics are part of the contract
- forgetting to re-run `Get-Help` after signature or parameter-set changes

## Reference starting points

- [about_Comment_Based_Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help)
- [Get-Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help)
- [platyPS](https://github.com/PowerShell/platyPS)
