# Changelog

All notable changes to the llm-software-design collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.3] - 2026-03-14

### Fixed

- corrected the AGENTS release-note spacing, promoted the reference docs to top-level headings for markdownlint, and removed the unused import from `scripts/verify_built_zips.py` so the repo passes the new CI and release lint gates on GitHub

## [0.1.2] - 2026-03-14

### Changed

- standardized the repo on a Make-first build and validation workflow: `make lint`, `make test`, `make build`, `make verify`, and `make all`
- added repo-owned Python packaging helpers and stdlib-only tests so ZIP verification and skill checks behave consistently across Windows-backed WSL and GitHub Actions
- renamed the primary GitHub Actions quality workflow to `CI` in `.github/workflows/ci.yml` and aligned release automation to run `make test`, build `built/*.zip`, attach artifacts, and skip marketplace dispatch cleanly when the token is missing
- kept `linting/` and `validation/` shell entrypoints as compatibility wrappers around the new Python baseline for one release cycle
- fully self-contained the release workflow by provisioning `jq` explicitly and updated the repo-local release guide to match the actual release automation and optional marketplace dispatch behavior

## [0.1.1] - 2026-03-14

### Added

- Initial repository scaffold for software design skills.
- Seed skills for SOLID, object-oriented design, design patterns, software architecture, and code smells.

### Fixed

- `.github/workflows/release.yml`: move marketplace token handling into job env and skip the dispatch step cleanly when `MARKETPLACE_DISPATCH_TOKEN` is not configured.
