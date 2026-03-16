# Changelog

All notable changes to the llm-software-design collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- test-drove the full 114-skill catalog and added explicit verification or recovery guidance to every skill so common requests now end with a clearer follow-through path
- rewrote `well-documented` for cleaner command selection, stronger safety notes, and a proper Quick Start flow
- deepened 42 thinner `*-docstrings` skills with family-specific depth sections, anti-patterns, and reference starting points so they better match the richness of the strongest catalog anchors
- added `docs/skill-test-drive-report.md`, `docs/docstrings-depth-test-drive.md`, `scripts/skill_affordance_report.py`, `tests/test_skill_affordances.py`, and `tests/test_docstring_reference_depth.py` to preserve the new usability baseline
- updated `AGENTS.md` with `skill_affordance_report.py` usage guidance and a pointer to `docs/skill-test-drive-report.md`
- updated `README.md` to link to the new test-drive report

## [1.1.3] - 2026-03-14

### Fixed

- corrected README skill count from 107 to 114 and added Design Methodology skills section
  documenting the seven skills added in v1.1.0 (bdd, tdd, ddd, dependency-injection,
  event-sourcing, idd, pdd) that were missing from the skill families table
- escaped C# heading in `design-patterns/references/language-examples.md` to pass markdown linting

## [1.1.0] - 2026-03-14

### Added

- seven new design methodology skills:
  - `bdd` — Behavior-driven development practices and workflows
  - `tdd` — Test-driven development methodology and patterns
  - `ddd` — Domain-driven design and strategic modeling
  - `dependency-injection` — Dependency injection patterns and practices
  - `event-sourcing` — Event sourcing architecture and event stores
  - `idd` — Interface-driven development principles
  - `pdd` — Property-driven development and generative testing

### Fixed

- resolved all markdown linting violations (48 errors across code-smells, semantic-versioning, solid, well-documented skills)
- converted bold section headers to proper markdown headings in `code-smells/smell-catalog.md`
- added blank lines around headings and lists per MD022/MD032 standards
- configured markdownlint to allow intentional blank-line spacing in reference documentation

### Changed

- updated AGENTS.md with explicit release process gates: lint → test → validate → build
- all 257 markdown files now pass linting (0 errors)
- repository now contains 114 skills (up from 107)

## [1.0.0] - 2026-03-14

### Added

- expanded `design-patterns` skill with richer SKILL.md, updated `pattern-guide.md`,
  and new `references/language-examples.md` (Python, TypeScript, JavaScript, C, C++, C#, Rust)
- expanded `oop` skill with richer SKILL.md, updated `modeling.md`,
  and new `references/language-examples.md` covering the same 7 language family
- expanded `solid` skill with richer SKILL.md, updated `principles.md`,
  and new `references/language-examples.md`
- expanded `code-smells` skill with richer SKILL.md, updated `smell-catalog.md`,
  and new `references/language-examples.md`
- moved `well-documented` bash test suites to `tests/bash/well-documented/`
  so they run alongside existing Python tests under the repo test gate

### Changed

- bumped major version to 1.0.0 — public API (skill names, front matter, agents YAML
  structure) is now considered stable; future breaking changes will increment MAJOR

## [0.5.1] - 2026-03-14

### Added

- added five helper scripts to `well-documented`:
  - `scripts/audit-docs.sh` — PASS/WARN/FAIL/SKIP scan with percentage score;
    includes M01/M02 markdownlint checks
  - `scripts/init-docs.sh` — bootstrap README, AGENTS.md, CLAUDE.md, CONCEPTS.md,
    CHANGELOG.md, and `.markdownlint.yaml` from templates; never overwrites existing files
  - `scripts/normalize-docs.sh` — non-destructive gap-filling driven by audit output
  - `scripts/add-file-headers.sh` — prepend language-appropriate headers to undocumented
    code files across 18+ languages; detects existing headers and skips them
  - `scripts/check-markdownlint.sh` — runs markdownlint-cli2 with auto-resolved project
    config; falls back to bundled base config
- added `scripts/lib-common.sh` — shared utilities (colour output, counters, exclusion
  detection, template rendering, header detection)
- added four test suites in `tests/`:
  - `tests/test-init-docs.sh` — 9 tests covering creation, idempotency, force-template,
    per-directory bootstrapping, and excluded-directory skipping
  - `tests/test-audit-docs.sh` — 12 tests covering FAIL/WARN detection, SCORE line,
    excluded-directory handling, and markdownlint config check
  - `tests/test-add-file-headers.sh` — 8 tests covering header generation per language,
    idempotency for existing headers, and dry-run mode
  - `tests/test-check-markdownlint.sh` — 6 tests (auto-skipped when tool absent)
    covering pass/fail detection, auto-fix, bundled config fallback
- added `tests/lib-test.sh` — minimal test framework with `assert_eq`, `assert_contains`,
  `assert_file_exists`, `assert_exit_code`, and `test_summary`
- added `tests/run-all-tests.sh` — runs all four suites and reports a pass/fail summary
- added three document templates in `assets/templates/`:
  `README.md.tmpl`, `AGENTS.md.tmpl`, `CONCEPTS.md.tmpl`
- added `assets/config/.markdownlint.yaml` — commented base markdownlint config with
  sensible defaults (MD013 line-length disabled, MD026/MD033 disabled, MD040 enabled)

### Changed

- updated `SKILL.md` with Scripts table, Assets table, Markdownlint Requirement section
  (all Markdown must pass; project root must have a config), and Existing File Formatting
  Takes Precedence section (heading style, table style, list style, fence style)
- updated `references/audit-checklist.md` with M-series markdownlint checklist (M01–M04)

## [0.5.0] - 2026-03-14

### Added

- added `well-documented` skill with six commands (`init-docs`, `audit-docs`, `normalize-docs`,
  `add-file-headers`, `add-docstrings`, `check-concepts`) that audit, initialize, and normalize
  repository documentation to a consistent standard
- added `references/structure-standard.md` defining required files at every level (README.md,
  AGENTS.md, CLAUDE.md, CONCEPTS.md, docs/), PlantUML as the preferred diagramming tool for
  human-centered documents, and the full AGENTS.md and CONCEPTS.md structural standards
- added `references/file-headers.md` with file-level header templates for 12 languages
  (Python, TypeScript/JavaScript, Java, C/C++, C#, Go, Ruby, Rust, Kotlin, Swift, Bash, SQL)
  and docstring depth guidance by symbol type
- added `references/agents-md-guide.md` with authoring rules for AI-navigable AGENTS.md files
  including required sections, anti-patterns, formatting rules, and sync obligations
- added `references/audit-checklist.md` with a scored rubric (PASS/WARN/FAIL/SKIP) across
  root-level, per-directory, code-file, and docs-folder criteria

### Changed

- updated `README.md` to list `semantic-versioning` and `well-documented` in the design and
  review skills table; updated total skill count from 105 to 107

## [0.4.0] - 2026-03-14

### Added

- added `semantic-versioning` skill with `set-version` and `bump-version` commands
  that validate SemVer 2.0.0 strings, update all version files, promote the
  CHANGELOG Unreleased block, commit, and create an annotated git tag
- added `references/spec.md` with the complete SemVer 2.0.0 specification
  (all 12 clauses, BNF grammar, precedence rules, and FAQ)
- added `references/git-tagging.md` covering annotated vs lightweight tags,
  push strategy, retag policy, release CI hooks, and a consistency checklist
- added `references/version-files.md` with version file discovery and update
  patterns for Node.js, Python, Rust, Java, .NET, Go, Ruby, PHP, and
  plain-text VERSION files

## [0.3.1] - 2026-03-14

### Fixed

- renamed three docstring skill directories to match their best-practice counterparts:
  `c-plus-plus-docstrings` → `cpp-docstrings`,
  `pl-sql-docstrings` → `plsql-docstrings`,
  `x-plus-plus-docstrings` → `xpp-docstrings`
- updated `SKILL.md` name fields, agent YAML `default_prompt` references, and catalog
  docs (`docs/docstring-skills.md`, `docs/language-skill-matrix.md`) to reflect the new names

## [0.3.0] - 2026-03-14

### Added

- merged the language-specific `[language]-best-practice` and `[language]-docstrings` branches into one combined repository
- added `docs/language-skill-matrix.md` to align each ranked language across the two generated skill families

### Changed

- normalized the generated language skills to a common structure and higher-detail reference depth across best-practice and docstring families
- expanded the five core design-review skills so they match the richer structure used by the generated language skills
- updated `README.md`, `INSTALL.md`, and `AGENTS.md` to describe the combined 105-skill catalog and maintenance expectations
- updated `.claude-plugin/plugin.json` for the merged catalog release

### Removed

- removed cached and built artifacts from the tracked source tree so packaging starts from clean source content

## [0.2.0] - 2026-03-14

### Added

- added 50 language-specific `[language]-docstrings` skills covering the supplied top-50 programming-language list, with references to the dominant machine-readable source documentation convention for each language
- added `docs/docstring-skills.md` as a catalog of the new language skills

### Changed

- updated `README.md` to summarize the expanded catalog and point at the docstring-skill index
- updated `INSTALL.md` to keep the installation steps aligned with the larger generated catalog

## [0.1.3] - 2026-03-14

### Fixed

- corrected the AGENTS release-note spacing, promoted the reference docs to top-level headings for markdownlint, and removed the unused import from `scripts/verify_built_zips.py` so the repo passes the new CI and release lint gates on GitHub

## [0.1.2] - 2026-03-14

### Changed

- standardized the repo on a Make-first build and validation workflow: `make lint`, `make test`, `make build`, `make verify`, and `make all`

## [0.1.1] - 2026-03-14

### Fixed

- aligned build artifacts with the repository root so packaged ZIPs preserve `llm-software-design/skills/<skill>/...`

## [0.1.0] - 2026-03-14

### Added

- initial cross-compatible software design skill repository with core design-review skills and packaging automation
