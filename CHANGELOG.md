# Changelog

All notable changes to the llm-software-design collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
