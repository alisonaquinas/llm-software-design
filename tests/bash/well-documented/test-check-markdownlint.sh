#!/usr/bin/env bash
# test-check-markdownlint.sh — Tests for scripts/check-markdownlint.sh
#
# Run: bash tests/test-check-markdownlint.sh
# Exit: 0 if all pass, 1 if any fail
#
# These tests are skipped automatically if markdownlint-cli2 is not installed.

set -euo pipefail
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$TESTS_DIR/../../skills/well-documented/scripts"
ASSETS_DIR="$TESTS_DIR/../../skills/well-documented/assets"
# shellcheck source=lib-test.sh
source "$TESTS_DIR/lib-test.sh"

# ── skip if markdownlint-cli2 unavailable ─────────────────────────────────────
if ! command -v markdownlint-cli2 &>/dev/null && ! command -v npx &>/dev/null; then
  printf "SKIP  markdownlint-cli2 and npx are not installed — skipping all tests\n"
  exit 0
fi

run_check() {
  local repo="$1"; shift
  set +e
  bash "$SCRIPTS_DIR/check-markdownlint.sh" -r "$repo" -q "$@" > /dev/null 2>&1
  local code=$?
  set -e
  echo "$code"
}

# ─────────────────────────────────────────────────────────────────────────────
# TEST: exits 0 for valid Markdown
# ─────────────────────────────────────────────────────────────────────────────
describe "check exits 0 for valid markdown"
REPO=$(make_test_repo)
cp "$ASSETS_DIR/config/.markdownlint.yaml" "$REPO/.markdownlint.yaml"
printf '# My Doc\n\nSome content here.\n\n## Section\n\nMore content.\n' > "$REPO/doc.md"
CODE=$(run_check "$REPO")
assert_exit_code 0 "$CODE" "clean markdown should pass"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: exits 1 for markdown with hard tabs (MD010)
# ─────────────────────────────────────────────────────────────────────────────
describe "check exits 1 for markdown with hard tabs"
REPO=$(make_test_repo)
cp "$ASSETS_DIR/config/.markdownlint.yaml" "$REPO/.markdownlint.yaml"
printf '# Doc\n\n\tThis line has a hard tab.\n' > "$REPO/bad.md"
CODE=$(run_check "$REPO")
assert_exit_code 1 "$CODE" "hard tab violation should cause failure"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: exits 1 for fenced block missing language (MD040)
# ─────────────────────────────────────────────────────────────────────────────
describe "check exits 1 for fenced code block without language"
REPO=$(make_test_repo)
cp "$ASSETS_DIR/config/.markdownlint.yaml" "$REPO/.markdownlint.yaml"
printf '# Doc\n\n```\nsome code\n```\n' > "$REPO/bad.md"
CODE=$(run_check "$REPO")
assert_exit_code 1 "$CODE" "fenced block with no language should fail"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: uses bundled config when no project config exists
# ─────────────────────────────────────────────────────────────────────────────
describe "check uses bundled config when no project config present"
REPO=$(make_test_repo)
# No .markdownlint.yaml in this repo
printf '# Valid Doc\n\nContent here.\n\n## Section Two\n\nMore content.\n' > "$REPO/ok.md"
CODE=$(run_check "$REPO")
assert_exit_code 0 "$CODE" "should use bundled config and pass on valid markdown"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: --fix auto-corrects a fixable violation
# ─────────────────────────────────────────────────────────────────────────────
describe "check --fix corrects trailing whitespace"
REPO=$(make_test_repo)
cp "$ASSETS_DIR/config/.markdownlint.yaml" "$REPO/.markdownlint.yaml"
# MD009 trailing spaces (not br_spaces=2, so 3+ trailing spaces is a violation)
printf '# Doc\n\nLine with three trailing spaces.   \n' > "$REPO/fix.md"
set +e
bash "$SCRIPTS_DIR/check-markdownlint.sh" -r "$REPO" --fix -q > /dev/null 2>&1 || true
set -e
# Re-run and expect it to pass now
CODE=$(run_check "$REPO")
assert_exit_code 0 "$CODE" "after --fix, file should pass"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: skips node_modules
# ─────────────────────────────────────────────────────────────────────────────
describe "check skips node_modules directory"
REPO=$(make_test_repo)
cp "$ASSETS_DIR/config/.markdownlint.yaml" "$REPO/.markdownlint.yaml"
printf '# Clean\n\nContent.\n\n## Section\n\nMore.\n' > "$REPO/ok.md"
mkdir -p "$REPO/node_modules/pkg"
# Deliberately bad markdown in node_modules — should not be flagged
printf '# Bad\n\n\thard tab\n' > "$REPO/node_modules/pkg/BAD.md"
CODE=$(run_check "$REPO")
assert_exit_code 0 "$CODE" "violations in node_modules should be ignored"
rm -rf "$REPO"

test_summary
