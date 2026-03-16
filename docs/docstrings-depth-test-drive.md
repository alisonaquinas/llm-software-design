# Docstrings depth test-drive report

This pass focused on the thinner docstring skills rather than the already-rich anchors such as `csharp-docstrings`, `python-docstrings`, `javascript-docstrings`, `typescript-docstrings`, `rust-docstrings`, and `sql-docstrings`.

## Scope of the pass

- enriched 42 thinner `*-docstrings` reference guides with an additional depth section tailored to the convention family
- added explicit `Anti-patterns` and `Reference starting points` sections to those thinner skills
- kept the stronger existing skills intact so the catalog now feels more even across language families
- added a regression test to keep the richer structure from collapsing back to skeleton references

## Scenario matrix

| ID | Bucket | Skill | Live goal | Success signal | Outcome |
| --- | --- | --- | --- | --- | --- |
| S01 | happy-path | dart-docstrings | document a public Dart class and member with concise `///` comments | `///` comments attach directly to exported declarations and summarize the public surface | PASS |
| S02 | variant | java-docstrings | document a generic Java method with type-parameter and exception tags | Javadoc block includes `@param <T>` and `@throws` guidance that matches the declaration | PASS |
| S03 | verification | ocaml-docstrings | prefer the interface boundary when both `.mli` and `.ml` exist | doc comment lands on the exported signature, not only on the implementation | PASS |
| S04 | recovery | awk-docstrings | recover from vague Awk comments by applying a stable header field schema | header now names purpose, inputs, outputs, and globals instead of a one-line vague comment | PASS |
| S05 | setup | powershell-docstrings | shape a comment-based help block so `Get-Help` users see the right sections | help block carries synopsis, parameter, outputs, and example sections adjacent to the function | PASS |
| S06 | safety | wolfram-docstrings | document only exported Wolfram symbols in the package section | usage message lives in the exported package area before the private implementation block | PASS |
| S07 | variant | ada-docstrings | keep GNATdoc comments on the specification boundary callers consume | tagged comment stays in the `.ads` spec while the body remains implementation-focused | PASS |

## Outcome summary

- PASS: 7
- PARTIAL: 0
- FAIL: 0
- BLOCKED: 0

## Strongest patterns

- Comment-only and legacy-language skills improved the most once they gained explicit field vocabularies.
- Interface-centric languages benefited from making the real contract boundary explicit, especially `.mli` and `.ads` surfaces.
- Tool-facing help systems such as PowerShell and Wolfram became easier to use once the extractor-facing section boundaries were spelled out.

## Highest-leverage improvements applied

1. Added family-specific depth sections such as `Structural expectations`, `Core tag set`, `Recommended header fields`, `Metadata boundaries`, and `Package structure expectations`.
2. Added `Anti-patterns` sections so the skills now warn against the failure modes most likely to produce misleading machine-readable docs.
3. Added `Reference starting points` sections so an agent has a next place to look when the repository already uses a concrete toolchain.
4. Added `tests/test_docstring_reference_depth.py` so future edits preserve the richer shape.

## Per-scenario notes

### S01 — Dart public API doc comment
- Target promise: the strengthened `dart-docstrings` guide now calls out `///`, summary-line discipline, and public-surface targeting.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/dart/lib/mathx.dart` with package-facing docs on a class and exported method.
- Verification: `grep -n '^///' /tmp/docstrings-drive-2to_ljmc/dart/lib/mathx.dart` would return two adjacent doc comment lines; both summaries are concise and declaration-adjacent.
- Outcome: PASS
- Friction: low. The new structural expectations make the common path obvious.
- Improvement signal: keep the new `Structural expectations`, anti-patterns, and reference links.

### S02 — Java generic API variant
- Target promise: the richer `java-docstrings` guide now names the tag set, including type parameters and `{@inheritDoc}`/exception handling.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/java/src/Api.java` for a small generic API contract.
- Verification: checked that `@param <T>` and `@throws IllegalArgumentException` appear in the Javadoc block next to the declaration.
- Outcome: PASS
- Friction: low. The new core-tag guidance closes a common gap in thinner docstring skills.
- Improvement signal: the explicit tag inventory is high leverage and worth preserving across other tagged languages.

### S03 — OCaml interface-first placement
- Target promise: the improved `ocaml-docstrings` guide now explicitly prefers `.mli` comments and public module interfaces.
- Live action: created paired interface and implementation files at `/tmp/docstrings-drive-2to_ljmc/ocaml/src/report.mli` and `/tmp/docstrings-drive-2to_ljmc/ocaml/src/report.ml`.
- Verification: the `(** ... *)` comment appears in the `.mli` export surface, while the implementation stays free of redundant contract prose.
- Outcome: PASS
- Friction: low. The new interface-first section removes the old ambiguity.
- Improvement signal: signature-boundary guidance is essential for interface-centric languages.

### S04 — Awk recovery from thin comments
- Target promise: `awk-docstrings` now recommends a reusable header field schema instead of only a bare summary.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/awk/report.awk` with `Name`, `Purpose`, `Inputs`, `Outputs`, and `Globals` fields.
- Verification: confirmed the structured field labels are present and adjacent to the documented function.
- Outcome: PASS
- Friction: moderate before the improvement; low after the new header-field section landed.
- Improvement signal: comment-only languages benefit most from explicit field vocabularies.

### S05 — PowerShell help-block setup
- Target promise: `powershell-docstrings` now includes an explicit help-section map, making setup for `Get-Help` and platyPS more direct.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/powershell/New-ReportSnapshot.ps1` with a compact help block.
- Verification: checked for `.SYNOPSIS`, `.PARAMETER Request`, `.OUTPUTS`, and `.EXAMPLE` markers in the block.
- Outcome: PASS
- Friction: low. The section map makes the expected structure easy to reproduce.
- Improvement signal: setup-oriented docstring skills should name the extraction-facing sections explicitly.

### S06 — Wolfram exported-symbol boundary
- Target promise: `wolfram-docstrings` now explains that usage messages belong in the exported package section between `BeginPackage` and the private block.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/wolfram/ReportPackage.wl` with one exported symbol and a private implementation region.
- Verification: checked that the `::usage` assignment appears before `Begin["`Private`"]`.
- Outcome: PASS
- Friction: low. The new package-structure section resolves where the authoritative doc belongs.
- Improvement signal: exported-surface boundaries matter as much as syntax in symbol-based systems.

### S07 — Ada specification boundary
- Target promise: the improved `ada-docstrings` guide now calls out the package specification as the right contract boundary.
- Live action: created `/tmp/docstrings-drive-2to_ljmc/ada/report.ads` and `/tmp/docstrings-drive-2to_ljmc/ada/report.adb` for a small package.
- Verification: confirmed `@summary` and `@param` appear in the specification file and not only in the body.
- Outcome: PASS
- Friction: low. The new core-tag and spec-first guidance makes the right placement explicit.
- Improvement signal: spec-versus-body guidance is especially valuable in interface-heavy languages.


## Verdict

revise-complete — the thinner docstring skills were updated and now merit re-test only if a future pass changes their structure again.
