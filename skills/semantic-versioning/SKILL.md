---
name: semantic-versioning

description: >
  apply semantic versioning (semver 2.0.0) to a project. use when the request
  involves choosing a version number, deciding what to bump, setting a specific
  version, creating git version tags, coordinating version changes with a
  changelog, or explaining semver rules, precedence, pre-release identifiers,
  or build metadata.
---


# Semantic Versioning

Use this skill to version software correctly according to the SemVer 2.0.0
specification and to operate the `set-version` and `bump-version` commands
that keep version files, CHANGELOG, and git tags in sync.

## Intent Router

| Need | Load |
| --- | --- |

| Full SemVer 2.0.0 specification, BNF grammar, precedence rules, FAQ | `references/spec.md` |
| Git tag conventions, tag creation, pushing, listing, and deleting | `references/git-tagging.md` |
| Version file formats across ecosystems and how to update them | `references/version-files.md` |

---

## Commands

### `set-version <VERSION>`

Set the project version to an explicit value.

**Accepts:** any valid SemVer 2.0.0 string, e.g. `1.4.0`, `2.0.0-rc.1`,

`1.0.0-beta.3+build.42`.

## Steps the agent executes

1. Validate `<VERSION>` against the SemVer 2.0.0 grammar; abort with an
   explanation if invalid.
2. Detect the current version by reading all version files found in the project
   (see `references/version-files.md`). Report the old value before changing it.
3. Write the new version string to every discovered version file.
4. If a `CHANGELOG.md` exists, rename the `## [Unreleased]` section to
   `## [<VERSION>] - <TODAY>` and insert a fresh empty `## [Unreleased]` section
   above it.
5. If the working directory is inside a git repository:
   a. Stage all modified version files and `CHANGELOG.md`.
   b. Commit with message: `chore: set version to <VERSION>`.
   c. Create an annotated tag `v<VERSION>` with message `Release <VERSION>`.
   d. Report the tag name and remind the user to `git push --follow-tags`.
6. Summarise every file changed and the final version in effect.

### `bump-version <LEVEL>`

Increment the current version by one level.

**Accepts:** `major`, `minor`, or `patch` (case-insensitive).

## Steps the agent executes

1. Detect the current version from version files (see `references/version-files.md`).
   If version files disagree, report the conflict and stop.
2. Parse the current version into MAJOR.MINOR.PATCH (strip any pre-release or
   build-metadata suffix before computing the bump).
3. Compute the new version:

   - `major` → (MAJOR+1).0.0

   - `minor` → MAJOR.(MINOR+1).0

   - `patch` → MAJOR.MINOR.(PATCH+1)

4. Execute all steps of `set-version <NEW_VERSION>` from step 3 onward.

---

## Quick Start

```text
bump-version patch     # 1.2.3 → 1.2.4, tag v1.2.4
bump-version minor     # 1.2.3 → 1.3.0, tag v1.3.0
bump-version major     # 1.2.3 → 2.0.0, tag v2.0.0
set-version 2.0.0-rc.1 # pin an explicit pre-release, no tag increment rules apply
```text

---


## Choosing a Bump Level

| What changed since the last release | Bump |
| --- | --- |

| Backward-incompatible API change, removed export, changed interface contract | `major` |
| New backward-compatible feature, new export, deprecation announced | `minor` |
| Backward-compatible bug fix only, internal refactor, dependency patch | `patch` |
| Pre-release iteration (alpha, beta, rc) | `set-version` with pre-release suffix |
| Documentation, CI, tooling — no shipped code change | usually none; `patch` if explicitly released |

> **Major version zero (0.y.z):** public API is unstable.

> Use `minor` for breaking changes and `patch` for non-breaking changes.
> Release `1.0.0` when the API is intentionally stable.

---


## Pre-release and Build Metadata

```text
MAJOR.MINOR.PATCH-pre.release+build.metadata
```text


- **Pre-release** identifier (after `-`): signals lower precedence than the
  release. Common patterns: `alpha`, `beta`, `rc.1`, `0.alpha.1`.

- **Build metadata** identifier (after `+`): ignored for precedence. Use for
  CI build numbers, commit SHAs, or timestamps.

Precedence (ascending): `1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-beta < 1.0.0-rc.1 < 1.0.0`

When iterating pre-releases, increment only the numeric tail of the suffix via
`set-version`; do not use `bump-version`.

---


## Workflow


- discover version files before proposing any change

- confirm the current version and the computed new version with the user before
  writing anything when uncertainty exists

- keep version files, CHANGELOG, and git tags in sync as a single atomic
  operation rather than updating them separately

- prefer annotated tags (`git tag -a`) over lightweight tags for releases

- push tags explicitly with `git push origin v<VERSION>` or
  `git push --follow-tags` rather than relying on `git push` alone

---


## Git Tag Conventions

```bash
# Create annotated release tag (done automatically by set-version / bump-version)
git tag -a v1.2.3 -m "Release 1.2.3"

# Push tag to remote
git push origin v1.2.3

# List all version tags sorted
git tag --sort=-version:refname | head -10

# Verify a tag exists on the remote
git ls-remote --tags origin v1.2.3

# Delete a tag (only before it is pushed or if retraction is intentional)
git tag -d v1.2.3
git push origin --delete v1.2.3
```text

See `references/git-tagging.md` for full tag management guidance.

---


## CHANGELOG Coordination

This skill follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
convention used by the companion `$changelog` skill:


- Unreleased work lives under `## [Unreleased]`.

- On release, `set-version` / `bump-version` promotes that block to
  `## [X.Y.Z] - YYYY-MM-DD`.

- A new empty `## [Unreleased]` is inserted immediately above the dated block.

- Do not manually edit the version header line; the commands manage it.

---


## Common Requests

```text
bump-version patch
```text

```text
bump-version minor — we just added a new public API method
```text

```text
set-version 2.0.0-rc.1
```text

```text
What version should I bump to? Here are the changes since 1.3.2: ...
```text

---


## Verification and Next Steps

- verify every discovered version file, `CHANGELOG.md`, and the planned git tag before writing changes
- stop when version files disagree or the release intent is unclear
- report the exact bump rationale so the next maintainer can audit why the version moved

## Safety Notes


- do not create a git tag if the working tree has uncommitted changes unless
  the user explicitly asks to proceed

- do not push tags automatically; always report the push command and let the
  user run it, or ask for explicit permission first

- do not increment the version when only documentation, comments, or CI
  configuration changed, unless the user has a policy that requires it

- do not silently strip a pre-release suffix; confirm before moving from
  `1.0.0-rc.2` to `1.0.0`

- do not modify files outside the version files and CHANGELOG without
  explicit instruction
