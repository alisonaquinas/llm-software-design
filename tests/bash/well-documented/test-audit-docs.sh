#!/usr/bin/env bash
# test-audit-docs.sh — Tests for scripts/audit-docs.sh
#
# Run: bash tests/test-audit-docs.sh
# Exit: 0 if all pass, 1 if any fail

set -euo pipefail
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$TESTS_DIR/../../skills/well-documented/scripts"
ASSETS_DIR="$TESTS_DIR/../../skills/well-documented/assets"
# shellcheck source=lib-test.sh
source "$TESTS_DIR/lib-test.sh"

run_audit() {
  local repo="$1"; shift
  # Capture output; don't abort on non-zero exit (audit exits 1 when FAILs exist)
  local out
  out=$(bash "$SCRIPTS_DIR/audit-docs.sh" -r "$repo" "$@" 2>&1) || true
  printf '%s' "$out"
}

# ── helpers to make a minimal passing repo ───────────────────────────────────

make_passing_repo() {
  local repo
  repo=$(make_test_repo)

  # Root files
  printf '# MyProject\n\n## Installation\n\nbash here\n\n## Usage\n\nexample\n' > "$repo/README.md"
  printf '# AGENTS.md\n\nThis repo does X.\n\n## Layout\n\nfiles here\n\n## Invariants — Do Not Violate\n\n- rule 1\n' \
    > "$repo/AGENTS.md"
  printf '# Claude Guidance\n\nSee AGENTS.md\n' > "$repo/CLAUDE.md"
  printf '# Concepts\n\n## Foo\n\nFoo does things.\n\n**See also:** [README.md](./README.md)\n\n## Bar\n\nBar does other things.\n\n**See also:** [README.md](./README.md)\n\n## Baz\n\nBaz rounds it out.\n\n**See also:** [README.md](./README.md)\n' \
    > "$repo/CONCEPTS.md"
  printf '# Changelog\n\n## [Unreleased]\n\n## [1.0.0] - 2026-01-01\n' > "$repo/CHANGELOG.md"

  # Markdownlint config
  cp "$ASSETS_DIR/config/.markdownlint.yaml" "$repo/.markdownlint.yaml"

  printf '%s' "$repo"
}

# ─────────────────────────────────────────────────────────────────────────────
# TEST: exits 0 for a repository that passes all checks
# ─────────────────────────────────────────────────────────────────────────────
describe "audit exits 0 for a fully passing repo"
REPO=$(make_passing_repo)
set +e
bash "$SCRIPTS_DIR/audit-docs.sh" -r "$REPO" -q > /dev/null 2>&1
CODE=$?
set -e
assert_exit_code 0 "$CODE"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL when README.md is missing
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs when README.md is missing"
REPO=$(make_passing_repo)
rm "$REPO/README.md"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "R01" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL when AGENTS.md is missing
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs when AGENTS.md is missing"
REPO=$(make_passing_repo)
rm "$REPO/AGENTS.md"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "R05" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL when CLAUDE.md is missing
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs when CLAUDE.md is missing"
REPO=$(make_passing_repo)
rm "$REPO/CLAUDE.md"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "R08" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL when CONCEPTS.md is missing
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs when CONCEPTS.md is missing"
REPO=$(make_passing_repo)
rm "$REPO/CONCEPTS.md"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "R09" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL when CHANGELOG.md is missing
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs when CHANGELOG.md is missing"
REPO=$(make_passing_repo)
rm "$REPO/CHANGELOG.md"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "R12" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: FAIL M01 when no markdownlint config exists
# ─────────────────────────────────────────────────────────────────────────────
describe "audit FAILs M01 when no markdownlint config exists"
REPO=$(make_passing_repo)
rm "$REPO/.markdownlint.yaml"
OUT=$(run_audit "$REPO")
assert_contains "FAIL" "$OUT"
assert_contains "M01" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: WARN when README.md has no Installation section
# ─────────────────────────────────────────────────────────────────────────────
describe "audit WARNs when README has no Installation section"
REPO=$(make_passing_repo)
printf '# MyProject\n\nSome content here.\n\n## Overview\n\nMore content.\n' > "$REPO/README.md"
OUT=$(run_audit "$REPO")
assert_contains "WARN" "$OUT"
assert_contains "R03" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: WARN when AGENTS.md has no Invariants section
# ─────────────────────────────────────────────────────────────────────────────
describe "audit WARNs when AGENTS.md has no Invariants section"
REPO=$(make_passing_repo)
printf '# AGENTS.md\n\n## Layout\n\nfiles\n\n## Workflows\n\nsteps\n' > "$REPO/AGENTS.md"
OUT=$(run_audit "$REPO")
assert_contains "WARN" "$OUT"
assert_contains "R07" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: WARN when CONCEPTS.md has fewer than 3 entries
# ─────────────────────────────────────────────────────────────────────────────
describe "audit WARNs when CONCEPTS.md has fewer than 3 entries"
REPO=$(make_passing_repo)
printf '# Concepts\n\n## Foo\n\nFoo does things.\n\n**See also:** [README.md](./README.md)\n' \
  > "$REPO/CONCEPTS.md"
OUT=$(run_audit "$REPO")
assert_contains "WARN" "$OUT"
assert_contains "R09" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: report includes SCORE line
# ─────────────────────────────────────────────────────────────────────────────
describe "audit output includes SCORE line"
REPO=$(make_passing_repo)
OUT=$(run_audit "$REPO")
assert_contains "SCORE:" "$OUT"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: subdirectory with files gets D-series checks
# ─────────────────────────────────────────────────────────────────────────────
describe "audit checks subdirectory that contains files"
REPO=$(make_passing_repo)
mkdir -p "$REPO/src"
touch "$REPO/src/main.py"
OUT=$(run_audit "$REPO")
assert_contains "src/" "$OUT" "should report on src/ directory"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: excluded directories are not audited
# ─────────────────────────────────────────────────────────────────────────────
describe "audit skips excluded directories"
REPO=$(make_passing_repo)
mkdir -p "$REPO/node_modules/pkg"
touch "$REPO/node_modules/pkg/index.js"
OUT=$(run_audit "$REPO")
assert_not_contains "node_modules" "$OUT" "node_modules should be excluded"
rm -rf "$REPO"

test_summary
