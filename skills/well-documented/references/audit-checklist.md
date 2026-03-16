# Documentation Audit Checklist and Scoring Rubric

## How to use this checklist

Run `audit-docs` to evaluate a repository against this rubric. Each item is scored as:

- **PASS** — requirement is fully met
- **WARN** — requirement is partially met or likely needs review
- **FAIL** — requirement is absent or critically broken
- **SKIP** — item does not apply for the chosen maturity level or repository shape

A repository earns a percentage score:

`PASS items / (PASS + WARN + FAIL items) × 100`

Target guidance:

- **90% or higher** — trustworthy and low-drift
- **75% to 89%** — usable with a few important gaps
- **60% to 74%** — meaningful documentation debt
- **below 60%** — documentation is not reliably guiding change

## Maturity-aware interpretation

Before scoring subdirectories, decide whether the repository is being audited at `minimal`, `standard`, or `full`.

- `minimal` skips most recursive folder-doc checks
- `standard` audits only doc-worthy directories
- `full` audits every meaningful source directory

## Root-level checklist

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| R01 | `README.md` exists | absent | — |
| R02 | `README.md` has title and description | absent | heading exists but overview is thin |
| R03 | `README.md` has installation or setup guidance | absent | steps are too vague to follow |
| R04 | `README.md` has usage guidance | absent | example is clearly placeholder-only |
| R05 | `AGENTS.md` exists | absent | present but missing layout, workflows, or invariants |
| R06 | `AGENTS.md` layout references current paths | broken or missing high-value paths | layout is stale in small ways |
| R07 | `AGENTS.md` has invariants section | absent | invariants are too vague |
| R08 | root `CLAUDE.md` exists | absent | present but duplicates `AGENTS.md` instead of pointing to it |
| R09 | `CONCEPTS.md` baseline matches maturity | absent at `full` | absent or thin at `standard`; optional at `minimal` |
| R10 | `CONCEPTS.md` entries have cross-references | every entry lacks them | some entries lack them |
| R11 | `CHANGELOG.md` matches release reality | versioned or published project has none | file exists but release entries are thin or missing |
| M01 | markdownlint config exists | — | none found |
| M02 | markdownlint passes or cleanly explains failure | violations remain | tool unavailable or runtime mismatch prevents a clean result |

## Per-directory checklist

Apply this only where the chosen maturity says local docs belong.

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| D01 | local `README.md` exists | absent at `full` | absent or thin at `standard` |
| D02 | local `AGENTS.md` exists | absent at `full` | absent or thin at `standard` |
| D03 | local `AGENTS.md` cross-references the parent when helpful | broken link | no parent link |
| D04 | local `CLAUDE.md` is a stub or symlink | absent at `full` | absent or overly long at `standard` |

## Evidence-first checklist

These items measure usefulness and truth, not just presence.

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| E01 | markdown links resolve across live docs | broken relative link exists | — |
| E02 | local path references in docs still exist | missing referenced file or directory | ambiguous path reference that likely drifted |
| E03 | local command snippets resolve to real local assets | referenced script or Make target is missing | command shape is ambiguous so it cannot be verified |
| E04 | bootstrap markers are absent from finished docs and headers | — | `BOOTSTRAP` or strong placeholder text remains in live content |
| F01 | current code changes are accompanied by docs changes when git context is available | — | working tree has code changes but no doc changes |

## Prioritization order

When fixing gaps, address items in this order:

1. `FAIL` items in the evidence-first checklist
2. `FAIL` items in the root checklist
3. `WARN` items in the evidence-first checklist
4. `FAIL` items in doc-worthy directories
5. root and directory `WARN` items
6. optional nice-to-have docs

## Reporting format

The audit should make the problem type obvious:

```text
PASS  R01  README.md (root)
WARN  R09  CONCEPTS.md (root) — optional at standard maturity but recommended for shared vocabulary
FAIL  E01  docs/architecture.md — broken link to ../diagrams/context.svg
FAIL  E03  README.md — references make target 'verify-api' but Makefile has no such target
WARN  F01  git working tree — code changed without any documentation changes
SCORE: 18 / 24 items pass (75%)
```

Label the gap when helpful:

- **coverage gap** — useful doc is missing
- **truth gap** — doc points to something wrong or gone
- **freshness gap** — code changed without doc changes
- **bootstrap gap** — generated text still needs review
