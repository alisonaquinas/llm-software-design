# Documentation Audit Checklist and Scoring Rubric

## How to use this checklist

Run `audit-docs` to evaluate a repository against this rubric. Each item is scored as:

- **PASS** — requirement is fully met
- **WARN** — requirement is partially met (exists but incomplete or low quality)
- **FAIL** — requirement is absent or critically broken
- **SKIP** — item does not apply (excluded directory, language without header convention, etc.)

A repository earns a percentage score: `PASS items / (total items − SKIP items) × 100`.

Target: **90% or higher** for a well-documented repository.

---

## Root-level checklist

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| R01 | `README.md` exists | Absent | Present but fewer than 4 standard sections |
| R02 | `README.md` has title and description | Absent | First heading does not match project name |
| R03 | `README.md` has installation steps | Absent | Steps are too vague to follow |
| R04 | `README.md` has usage example | Absent | Example is a placeholder or stub |
| R05 | `AGENTS.md` exists | Absent | Present but has no layout, workflows, or invariants section |
| R06 | `AGENTS.md` has layout diagram | Absent | Layout is outdated (references files that don't exist) |
| R07 | `AGENTS.md` has invariants section | Absent | Invariants are too vague (e.g., "write good code") |
| R08 | `CLAUDE.md` exists | Absent | Present but contains content that duplicates `AGENTS.md` |
| R09 | `CONCEPTS.md` exists | Absent | Present but has fewer than 3 entries |
| R10 | `CONCEPTS.md` entries have cross-references | Absent | Some entries lack `See also` lines |
| R11 | `CONCEPTS.md` links resolve | Broken link exists | — |
| R12 | `CHANGELOG.md` exists | Absent | Present but has no version entries |

---

## Per-directory checklist (applied to every source directory)

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| D01 | `README.md` exists | Absent | Present but no description of what lives in the directory |
| D02 | `AGENTS.md` exists | Absent | Present but missing layout or invariants |
| D03 | `AGENTS.md` cross-references parent | No parent link | Parent link is broken |
| D04 | `CLAUDE.md` exists | Absent | Present but contains substantive content (not a stub/symlink) |

---

## Code file checklist (applied per source file)

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| C01 | File has a file-level header | Absent | Present but fewer than 3 content lines (name + blank = not enough) |
| C02 | File header states the file's purpose | Not mentioned | Only restates the filename |
| C03 | File header lists key exports | Not mentioned | Lists only some exports |
| C04 | File header explains role in system | Not mentioned | One-word description |
| C05 | All public functions have docstrings | Any absent | Some present, some absent |
| C06 | All public classes have docstrings | Any absent | Present but describes only one responsibility |
| C07 | Public method docstrings cover parameters | Parameters unnamed | Some parameters undocumented |
| C08 | Public method docstrings cover return value | Return value absent | Described only as "the result" |
| C09 | Public method docstrings cover exceptions raised | Exceptions absent (if non-trivial) | Some exceptions undocumented |

---

## docs/ folder checklist

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| X01 | `docs/` folder exists | Absent for non-trivial projects | — |
| X02 | `docs/README.md` is an index of all docs | Absent | Links to some but not all documents |
| X03 | Architecture overview exists | Absent | Present but has no diagram |
| X04 | PlantUML diagrams used for complex structure | No diagrams in non-trivial docs | Diagrams exist but are out of date |
| X05 | PlantUML diagrams in sync with code | Class/component names mismatch code | — |

---

## Markdownlint checklist

| # | Item | FAIL condition | WARN condition |
| --- | --- | --- | --- |
| M01 | markdownlint config file exists | None of `.markdownlint.yaml`, `.markdownlint.json`, `.markdownlint-cli2.jsonc` present | Config present but empty or default-only |
| M02 | All `.md` files pass markdownlint | Any violations | — |
| M03 | CI runs markdownlint | No CI step for markdown lint | CI step exists but is non-blocking |
| M04 | markdownlint config is customised for the project | Config is a verbatim copy with no project-specific adjustments | — |

---

## Quality scoring guidance

### Score interpretation

| Score | Interpretation |
| --- | --- |
| 95–100% | Exemplary — minor gaps only |
| 80–94% | Good — a few important gaps to address |
| 60–79% | Partial — significant documentation debt |
| 40–59% | Poor — documentation is inconsistent and unreliable |
| < 40% | Critical — effectively undocumented |

### Prioritization order

When fixing gaps, address items in this order:

1. `FAIL` items in the root checklist (R01–R12) — these affect all users and agents.
2. `FAIL` items in high-traffic directories (src/, lib/, core/).
3. `FAIL` items in per-directory checks (D01–D04) for all other directories.
4. `FAIL` items in code file checks (C01–C09) for public API files.
5. `WARN` items in root and per-directory checks.
6. `WARN` items in code file checks.
7. `docs/` checklist items (X01–X05).

---

## Reporting format

The `audit-docs` command outputs one line per evaluated item:

```
PASS  R01  README.md (root)
PASS  R05  AGENTS.md (root)
FAIL  R09  CONCEPTS.md (root) — missing
WARN  R06  AGENTS.md (root) — layout references src/legacy/ which does not exist
PASS  D01  README.md (src/)
FAIL  D02  AGENTS.md (src/) — missing
WARN  C01  src/auth/login.py — file header present but only 1 content line
FAIL  C05  src/auth/login.py — authenticate() has no docstring
SKIP  C01  src/auth/__init__.py — empty file
...
SCORE: 18 / 24 evaluated items pass (75%)
PRIORITY FAILS: R09 (CONCEPTS.md), D02 (src/ AGENTS.md), C05 (src/auth/login.py)
```
