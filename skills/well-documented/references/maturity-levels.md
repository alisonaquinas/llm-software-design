# Documentation Maturity Levels

Use maturity levels to scale the documentation footprint to the repository instead of forcing the same file set everywhere.

## Minimal

Choose `minimal` when the repository is small, early-stage, experimental, or obviously maintained by a tight team that mainly needs safe entry points.

Expected baseline:

- root `README.md`
- root `AGENTS.md`
- root `CLAUDE.md` stub or symlink
- optional `CONCEPTS.md` when the domain language is non-obvious
- optional `CHANGELOG.md` when the project is versioned or published

Default behavior:

- no recursive folder-doc requirement
- prefer fixing broken links, stale commands, and misleading prose over adding new files
- add subtree docs only if a directory is a clear public or high-risk boundary

## Standard

Choose `standard` for most real repositories.

Expected baseline:

- everything from `minimal`
- `CONCEPTS.md` when shared vocabulary appears across code and docs
- folder-level docs only for doc-worthy directories
- architecture docs when the structure is non-trivial

A directory is usually doc-worthy when one or more of these are true:

- it is a public API or integration boundary
- it is an entrypoint such as `src/`, `app/`, `packages/`, `services/`, `cmd/`, `api/`, or `scripts/`
- it contains multiple submodules that a new maintainer must navigate
- it is a high-change area where agents or humans routinely make edits
- it has local invariants that are not obvious from filenames alone

This is the best default for audits and normalization passes.

## Full

Choose `full` only when the user explicitly wants exhaustive coverage or the repository's governance model requires it.

Expected baseline:

- everything from `standard`
- recursive folder docs for every meaningful source directory
- stricter expectations for `CONCEPTS.md`, cross-references, and local stubs
- broader header and docstring coverage

Use `full` for mature frameworks, large monorepos, regulated systems, or repositories intended as long-lived shared infrastructure.

## How to choose quickly

| Situation | Recommended maturity |
| --- | --- |
| prototype, script bundle, internal experiment | `minimal` |
| normal application, package, service, or tool | `standard` |
| monorepo, public platform, highly regulated system, or explicit request for exhaustive coverage | `full` |

## Practical rule

Start one level lower than your first instinct unless the user explicitly wants exhaustive structure. It is easier to grow from `minimal` or `standard` than to unwind documentation sprawl later.
