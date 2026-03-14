# Git Tagging for Releases

This reference covers the git tag operations used by the `set-version` and
`bump-version` commands and the conventions that keep tags consistent with
SemVer version files.

---

## Tag Name Convention

| Version type | Tag name | Example |
| --- | --- | --- |
| Stable release | `v<MAJOR>.<MINOR>.<PATCH>` | `v1.4.0` |
| Pre-release | `v<MAJOR>.<MINOR>.<PATCH>-<PRE>` | `v2.0.0-rc.1` |
| Initial release | `v1.0.0` | `v1.0.0` |

The `v` prefix is conventional (not part of the SemVer string). Always use it
so that `git tag --sort=-version:refname` and tools like GitHub Releases resolve
tags correctly.

---

## Creating Tags

### Annotated tag (required for releases)

```bash
git tag -a v1.4.0 -m "Release 1.4.0"
```

Annotated tags store the tagger, date, and message. They are first-class objects
in git and are shown by `git describe`. Always use annotated tags for releases.

### Lightweight tag (for local bookmarks only)

```bash
git tag v1.4.0-wip
```

Lightweight tags are just pointers. Do not use them for public releases.

### Tag at a specific commit

```bash
git tag -a v1.4.0 <commit-sha> -m "Release 1.4.0"
```

---

## Pushing Tags

Tags are not pushed by `git push` alone. Push them explicitly:

```bash
# Push a single tag
git push origin v1.4.0

# Push all local tags not yet on the remote (use with care)
git push --tags

# Push commits AND any tags that point to pushed commits (preferred)
git push --follow-tags
```

> Prefer `--follow-tags` over `--tags` to avoid accidentally pushing
> temporary or work-in-progress lightweight tags.

---

## Verifying Tags

```bash
# List all tags sorted by version descending
git tag --sort=-version:refname

# Show tag details (annotated)
git show v1.4.0

# Verify a signed tag (GPG)
git tag -v v1.4.0

# Check whether a tag exists on the remote
git ls-remote --tags origin v1.4.0

# Find the most recent reachable tag from HEAD
git describe --tags --abbrev=0
```

---

## Deleting Tags

Only delete a tag that has not yet been seen by downstream consumers. A
published tag that others depend on MUST NOT be deleted or moved — release
a corrective version instead.

```bash
# Delete local tag
git tag -d v1.4.0

# Delete remote tag (force-push the deletion)
git push origin --delete v1.4.0

# Or using the refspec form
git push origin :refs/tags/v1.4.0
```

---

## Moving a Tag (retag)

Do not retag a published release. If the release commit was wrong, release a
new patch version. If the tag was local-only:

```bash
git tag -d v1.4.0
git tag -a v1.4.0 <correct-sha> -m "Release 1.4.0"
```

---

## Checking Out a Tagged Version

```bash
git checkout v1.4.0        # detached HEAD at that commit
git checkout -b hotfix/1.4.1 v1.4.0   # branch from a tag
```

---

## GitHub / GitLab Release Integration

CI/CD release workflows (`.github/workflows/release.yml`) are typically
triggered by a tag push matching `v*.*.*`:

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
      - 'v[0-9]+.[0-9]+.[0-9]+-*'   # also trigger on pre-releases
```

The release workflow then attaches build artifacts and creates a GitHub/GitLab
Release entry. Do not push the tag until the local build passes.

---

## Consistency Checklist

Before pushing a version tag, verify:

- [ ] All version files agree on the same version string.
- [ ] `CHANGELOG.md` has a dated release entry for this version (not Unreleased).
- [ ] The commit is on the default branch (or a dedicated release branch).
- [ ] The working tree is clean (`git status` shows nothing uncommitted).
- [ ] Local tests pass.
- [ ] The tag name starts with `v` and matches the version in the files exactly.
