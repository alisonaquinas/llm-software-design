---
name: well-documented
description: >
  audit, initialize, normalize, and extend repository documentation so humans
  and ai agents can navigate and change the codebase safely. use when the user
  asks to review or improve README files, AGENTS.md files, CLAUDE.md stubs,
  CONCEPTS.md glossaries, folder-level documentation, file headers, or
  language-specific docstrings across an existing or new repository.
---

# Well-Documented

Use this skill to raise a repository's documentation quality without inventing behavior, duplicating guidance, or overwriting documentation that is already doing its job.

## Intent Router

| Need | Load |
| --- | --- |
| repository-wide structure rules, required files, and documentation scope | `references/structure-standard.md` |
| file-header and docstring conventions across languages | `references/file-headers.md` |
| subtree-level `AGENTS.md` guidance and cross-reference rules | `references/agents-md-guide.md` |
| scored audit criteria and gap taxonomy | `references/audit-checklist.md` |

## Quick Start

1. run an audit first and report the gaps before writing anything
2. choose the smallest command that fits the situation: `audit-docs`, `normalize-docs`, `init-docs`, `add-file-headers`, `add-docstrings`, or `check-concepts`
3. preserve accurate existing documentation and extend only the missing or weak parts
4. delegate language-specific source comments to the matching `$[language]-docstrings` skill when that adds precision
5. verify links, markdown, and generated text against the real repository before finishing

## Scripts and Assets

### Scripts

| Script | Purpose |
| --- | --- |
| `scripts/audit-docs.sh` | scan a repository and emit PASS/WARN/FAIL/SKIP findings with a score |
| `scripts/init-docs.sh` | bootstrap root and subtree documentation for a sparse repository |
| `scripts/normalize-docs.sh` | fill documentation gaps without replacing sound existing content |
| `scripts/add-file-headers.sh` | add or extend file headers on supported source files |
| `scripts/check-markdownlint.sh` | run markdownlint against the repository, with optional auto-fix |

### Assets

| Asset | Purpose |
| --- | --- |
| `assets/templates/README.md.tmpl` | baseline template for human-facing project overviews |
| `assets/templates/AGENTS.md.tmpl` | baseline template for ai-agent guidance |
| `assets/templates/CONCEPTS.md.tmpl` | baseline template for concept glossary entries |
| `assets/config/.markdownlint.yaml` | starter markdownlint configuration for repos that lack one |

## Command Selection

| Situation | Preferred command | Why |
| --- | --- | --- |
| documentation quality is unknown | `audit-docs` | establish scope before editing |
| docs exist but are incomplete | `normalize-docs` | preserve good content and fill only the gaps |
| repo is new or nearly empty | `init-docs` | create the full baseline structure quickly |
| code files lack top-of-file orientation | `add-file-headers` | improve local navigability without rewriting logic |
| public symbols are undocumented | `add-docstrings` | improve source-adjacent API guidance |
| concepts drifted from the codebase | `check-concepts` | reconcile glossary coverage and links |

## Core Standard

A well-documented repository should make these things easy to find and trust:

- what the project is for
- how it is structured
- how to change it safely
- what the important domain concepts mean
- what each public file or symbol is responsible for

### Root-Level Expectations

- `README.md` explains purpose, setup, usage, and contribution flow for humans
- `AGENTS.md` explains layout, workflows, invariants, and safe-editing rules for agents
- `CLAUDE.md` is a stub or symlink that points back to `AGENTS.md`
- `CONCEPTS.md` captures domain terms that appear across code and docs
- `CHANGELOG.md` exists when the repository publishes versions or notable releases

### Subtree Expectations

Any subtree with meaningful source or nested folders should usually contain:

- a local `README.md` for humans
- a local `AGENTS.md` for subtree-specific rules and cross-references
- a `CLAUDE.md` stub or symlink when the workflow expects it

### Code-Level Expectations

- files that support header comments should explain what the file owns and how it fits into the system
- public modules, classes, functions, methods, and other externally consumed symbols should use the dominant machine-readable documentation convention for that language
- generated code, vendored code, minified code, and fixtures should usually be excluded

## Commands

### `audit-docs`

Use first in almost every workflow.

1. inspect the repository layout and locate existing docs
2. score gaps against `references/audit-checklist.md`
3. report findings as PASS/WARN/FAIL/SKIP with a final score
4. group failures by the smallest fixing command
5. stop and show the scope before proposing large write operations

Example output shape:

```text
PASS  README.md (root)
WARN  src/api/AGENTS.md — missing cross-reference to parent AGENTS.md
FAIL  src/auth/README.md — missing
FAIL  src/auth/user.py — public function `authenticate` has no docstring
SCORE: 14 / 21 items pass (67%)
```

### `normalize-docs`

Use when the repository already has some usable documentation.

1. run `audit-docs` internally
2. create missing required files with the smallest accurate baseline content
3. extend thin or incomplete docs without rewriting correct sections wholesale
4. add file headers or docstrings only where they are missing or clearly insufficient
5. report every file created or modified

### `init-docs`

Use when the repository is effectively undocumented.

1. inspect the repository shape first
2. create `README.md`, `AGENTS.md`, `CLAUDE.md`, and `CONCEPTS.md` at the root when absent
3. create subtree documentation only where the folder structure justifies it
4. use templates as a starting point, then replace placeholder assumptions with repository-specific facts
5. report the created files and any follow-up areas that still need real domain knowledge

### `add-file-headers`

Use when source files need top-of-file orientation.

1. walk supported source files while honoring exclusions
2. detect whether a header already exists
3. add or extend only the minimal header needed to explain purpose, exports, and system role
4. keep the header aligned with the language's dominant comment style
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

1. collect domain terms from `README.md`, `AGENTS.md`, and stable source names
2. compare them against `CONCEPTS.md`
3. suggest missing entries and broken cross-references
4. keep each concept entry to one focused paragraph plus `See also` links

## Working Rules

- audit first unless the user explicitly asks for one narrow command on a known target
- prefer `normalize-docs` over `init-docs` once a repository has meaningful documentation
- generate documentation from observed code and repository structure, not from guesswork
- keep local folder docs aligned with the folder's actual responsibilities
- use PlantUML in human-facing design docs by default, but do not place PlantUML diagrams inside `AGENTS.md`
- use relative links that resolve from the file where they appear
- omit filler sections rather than writing placeholders such as `TODO: describe this`

## Verification and Next Steps

- re-run the relevant audit after edits and confirm the targeted FAIL or WARN items are gone
- verify that markdown links resolve and markdownlint still passes or improves
- spot-check a few changed files against the code to confirm the prose still matches reality
- call out any remaining gaps that need human domain knowledge rather than guessing

## Common Requests

```text
audit-docs
```

```text
normalize-docs for this existing repository and report every file that changed
```

```text
add-file-headers src/
```

```text
add-docstrings src/api/
```

```text
check-concepts
```

## Safety Notes

- do not delete or replace accurate documentation just to force a template
- do not invent APIs, workflows, invariants, or domain meaning that the code does not support
- do not duplicate `AGENTS.md` into `CLAUDE.md`; use a stub or symlink instead
- do not run tree-wide header or docstring generation blindly on large repos without first reporting scope and exclusions
- do not add headers or docstrings to generated, minified, vendored, or fixture content
- treat broad write operations as reversible batches and report exactly what changed

## See Also

- `$[language]-docstrings` for language-specific source documentation rules
- `$[language]-best-practice` for broader maintainability guidance alongside documentation work
- `$code-smells` when missing docs are masking structural problems rather than only communication gaps
- `$semantic-versioning` when documentation updates are part of a coordinated release
