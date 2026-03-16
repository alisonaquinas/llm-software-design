---
name: well-documented
description: >
  audit, initialize, normalize, and extend repository documentation with an
  evidence-first, low-drift standard. use when the user asks to review or
  improve README files, AGENTS.md files, CLAUDE.md stubs, CONCEPTS.md
  glossaries, folder-level documentation, file headers, or language-specific
  docstrings across an existing or new repository, especially when the right
  answer depends on choosing a documentation maturity level, verifying that docs
  still match the code, or avoiding documentation sprawl.
---

# Well-Documented

Use this skill to raise a repository's documentation quality without inventing behavior, forcing a one-size-fits-all structure, or rewarding file-count compliance over real usefulness.

## Intent Router

| Need | Load |
| --- | --- |
| choose a minimal, standard, or full documentation baseline | `references/maturity-levels.md` |
| repository-wide structure rules and where docs add the most value | `references/structure-standard.md` |
| evidence-first audit criteria, truth checks, and freshness signals | `references/evidence-first-auditing.md` |
| scored audit criteria and gap taxonomy | `references/audit-checklist.md` |
| file-header and docstring conventions across languages | `references/file-headers.md` |
| subtree-level `AGENTS.md` guidance and cross-reference rules | `references/agents-md-guide.md` |
| choose a better starting template for a library, cli, service, web app, monorepo package, or data pipeline | `references/project-type-templates.md` |

## Quick Start

1. run an audit first and report the gaps before writing anything
2. choose the smallest maturity level that fits the repository: `minimal`, `standard`, or `full`
3. prefer evidence-first fixes: broken links, stale commands, bootstrap markers, and code-without-doc updates before adding new files
4. choose the smallest command that fits the job: `audit-docs`, `normalize-docs`, `init-docs`, `add-file-headers`, `add-docstrings`, or `check-concepts`
5. use `--project-type` when bootstrapping root docs so the first draft matches the repository shape
6. treat generated headers and template text as bootstrap drafts that must be refined before merge

## Scripts and Assets

### Scripts

| Script | Purpose |
| --- | --- |
| `scripts/audit-docs.sh` | scan a repository and emit PASS/WARN/FAIL/SKIP findings with structure, accuracy, and freshness signals |
| `scripts/init-docs.sh` | bootstrap root and selected subtree documentation for a sparse repository using maturity levels and project-type templates |
| `scripts/normalize-docs.sh` | fill documentation gaps without replacing sound existing content |
| `scripts/add-file-headers.sh` | add or extend bootstrap file headers on supported source files |
| `scripts/check-markdownlint.sh` | run markdownlint against the repository, with optional auto-fix |

### Assets

| Asset | Purpose |
| --- | --- |
| `assets/templates/README.*.md.tmpl` | project-type-aware root README templates |
| `assets/templates/README.directory.md.tmpl` | baseline template for folder-level human-facing docs |
| `assets/templates/AGENTS.md.tmpl` | baseline template for ai-agent guidance |
| `assets/templates/CONCEPTS.md.tmpl` | baseline template for a glossary with bootstrap entries |
| `assets/config/.markdownlint.yaml` | starter markdownlint configuration for repos that lack one |

## Command Selection

| Situation | Preferred command | Why |
| --- | --- | --- |
| documentation quality is unknown | `audit-docs --maturity standard` | establishes scope before editing |
| small or early-stage repo needs only safe baseline docs | `init-docs --maturity minimal` | creates only the highest-value root files |
| repo already has docs but drift is the problem | `audit-docs --check-local-commands --git-freshness` | measures truth and freshness, not just existence |
| docs exist but are incomplete | `normalize-docs --maturity standard` | preserves good content and fills only the gaps |
| repo has many public or high-risk subtrees and wants full coverage | `init-docs --maturity full` or `normalize-docs --maturity full` | expands documentation recursively on purpose |
| root docs need a better starting point | `init-docs --project-type <type>` | uses a closer template than the generic scaffold |
| code files lack top-of-file orientation | `add-file-headers` | improves local navigability without rewriting logic |
| public symbols are undocumented | `add-docstrings` | improves source-adjacent API guidance |
| concepts drifted from the codebase | `check-concepts` | reconciles glossary coverage and links |

## Core Standard

A well-documented repository should make these things easy to find and trust:

- what the project is for
- how it is structured
- how to change it safely
- what the important domain concepts mean
- what each public file or symbol is responsible for
- whether the documentation still matches the current code and workflow

The standard is deliberately adaptive:

- `minimal` favors a small, trustworthy root baseline
- `standard` adds docs around important boundaries and high-change areas
- `full` is the explicit opt-in maturity level for recursive, directory-by-directory documentation

## Commands

### `audit-docs`

Use first in almost every workflow.

1. inspect the repository layout and locate existing docs
2. score gaps against `references/audit-checklist.md`
3. choose checks that match the requested maturity level
4. report findings as PASS/WARN/FAIL/SKIP with a final score
5. group failures by the smallest fixing command
6. stop and show the scope before proposing large write operations

Prefer these flags when they help:

```text
audit-docs --maturity standard
```

```text
audit-docs --maturity full --check-local-commands --git-freshness
```

### `normalize-docs`

Use when the repository already has some usable documentation.

1. run `audit-docs` internally
2. create missing required files with the smallest accurate baseline content
3. extend thin or incomplete docs without rewriting correct sections wholesale
4. add file headers or docstrings only where they are missing or clearly insufficient
5. keep any generated bootstrap markers visible until the content is genuinely refined
6. report every file created or modified

Example:

```text
normalize-docs --maturity standard --project-type service
```

### `init-docs`

Use when the repository is effectively undocumented or the user wants a clean documentation baseline.

1. inspect the repository shape first
2. choose a maturity level instead of assuming recursive folder docs
3. create root docs first, then only the subtree docs justified by the selected maturity
4. use project-type templates for the root README when that improves the first draft
5. replace placeholder assumptions with repository-specific facts wherever the code already supports them
6. report the created files and any follow-up areas that still need domain knowledge

Example:

```text
init-docs --maturity minimal --project-type cli
```

### `add-file-headers`

Use when source files need top-of-file orientation.

1. walk supported source files while honoring exclusions
2. detect whether a header already exists
3. add only the minimal bootstrap header needed to explain purpose, exports, and system role
4. mark generated headers as bootstrap text that must be refined before merge
5. skip generated, vendored, or obviously machine-produced files

### `add-docstrings`

Use when public symbols are missing machine-readable source documentation.

1. identify the externally consumed surface first
2. delegate format choices to the matching `$[language]-docstrings` skill when needed
3. insert declaration-adjacent docstrings or documentation comments
4. keep the prose faithful to the real behavior, not the intended future design
5. report which symbols were documented and which were intentionally skipped

### `check-concepts`

Use when the glossary is missing or stale.

1. collect domain terms from `README.md`, `AGENTS.md`, stable source names, and architecture docs
2. compare them against `CONCEPTS.md`
3. suggest missing entries, weak definitions, and broken cross-references
4. keep each concept entry to one focused paragraph plus `See also` links

## Working Rules

- audit first unless the user explicitly asks for one narrow command on a known target
- choose the lowest maturity level that solves the real problem
- prefer `normalize-docs` over `init-docs` once a repository has meaningful documentation
- generate documentation from observed code and repository structure, not from guesswork
- use evidence-first fixes before adding new files: resolve broken links, missing local targets, stale layout references, and code-doc drift
- keep local folder docs aligned with the folder's actual responsibilities
- use PlantUML in human-facing design docs by default, but do not place PlantUML diagrams inside `AGENTS.md`
- use relative links that resolve from the file where they appear
- keep bootstrap markers visible until the content is genuinely reviewed; do not quietly leave `BOOTSTRAP` text behind in finished work

## Verification and Next Steps

- re-run the relevant audit after edits and confirm the targeted FAIL or WARN items are gone
- verify that markdown links resolve and markdownlint still passes or improves
- verify that local command snippets still point to real files, scripts, and Make targets
- spot-check changed docs against the code to confirm the prose still matches reality
- if git context is available, confirm code changes were paired with the docs that explain them
- call out any remaining gaps that need human domain knowledge rather than guessing

## Common Requests

```text
audit-docs --maturity standard
```

```text
normalize-docs --maturity standard --project-type library and report every file that changed
```

```text
init-docs --maturity minimal --project-type cli
```

```text
add-file-headers src/
```

```text
add-docstrings src/api/
```

## Environment Requirements

- `markdownlint-cli2` requires **Node.js ≥ 20**. On Node 18 or earlier the tool crashes on startup with a `SyntaxError` for unsupported regex flags. Install a newer Node version or use `nvm use 20` before running `check-markdownlint` or expecting markdownlint audit items to pass.
- All other scripts require only standard POSIX tools (`bash ≥ 4`, `grep`, `sed`, `find`, `awk`, and `python3` for a few convenience helpers).

## Safety Notes

- do not delete or replace accurate documentation just to force a template
- do not invent APIs, workflows, invariants, or domain meaning that the code does not support
- do not duplicate `AGENTS.md` into `CLAUDE.md`; use a stub or symlink instead
- do not assume every directory deserves its own docs; let the maturity level and repository shape decide
- do not run tree-wide header or docstring generation blindly on large repos without first reporting scope and exclusions
- do not add headers or docstrings to generated, minified, vendored, or fixture content
- do not hide bootstrap text inside finished documentation; either refine it or report that it still needs review
- treat broad write operations as reversible batches and report exactly what changed

## See Also

- `$[language]-docstrings` for language-specific source documentation conventions
- `$semantic-versioning` for release numbering
