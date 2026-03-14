#!/usr/bin/env bash
# test-init-docs.sh — Tests for scripts/init-docs.sh
#
# Run: bash tests/test-init-docs.sh
# Exit: 0 if all pass, 1 if any fail

set -euo pipefail
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$TESTS_DIR/../../skills/well-documented/scripts"
ASSETS_DIR="$TESTS_DIR/../../skills/well-documented/assets"
# shellcheck source=lib-test.sh
source "$TESTS_DIR/lib-test.sh"

# ── helper: run init-docs in a fresh temp repo ────────────────────────────────

run_init() {
  local repo="$1"; shift
  bash "$SCRIPTS_DIR/init-docs.sh" -r "$repo" -q "$@"
}

# ─────────────────────────────────────────────────────────────────────────────
# TEST: creates all root-level files in an empty directory
# ─────────────────────────────────────────────────────────────────────────────
describe "init creates root files in empty repo"
REPO=$(make_test_repo)
run_init "$REPO" -n "my-project" -d "A test project"

assert_file_exists "$REPO/README.md"
assert_file_exists "$REPO/AGENTS.md"
assert_file_exists "$REPO/CLAUDE.md"
assert_file_exists "$REPO/CONCEPTS.md"
assert_file_exists "$REPO/CHANGELOG.md"
assert_file_exists "$REPO/.markdownlint.yaml"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: README contains the project name
# ─────────────────────────────────────────────────────────────────────────────
describe "init README contains project name"
REPO=$(make_test_repo)
run_init "$REPO" -n "myproject" -d "A test project"
assert_file_contains "$REPO/README.md" "myproject"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: does NOT overwrite an existing README
# ─────────────────────────────────────────────────────────────────────────────
describe "init does not overwrite existing README"
REPO=$(make_test_repo)
echo "# Custom README" > "$REPO/README.md"
run_init "$REPO" -n "myproject"
assert_file_contains "$REPO/README.md" "# Custom README" "existing content should be preserved"
assert_file_not_contains "$REPO/README.md" "{{PROJECT_NAME}}" "template placeholder should not be present"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: --force-template overwrites existing README
# ─────────────────────────────────────────────────────────────────────────────
describe "init --force-template overwrites existing README"
REPO=$(make_test_repo)
echo "# Custom README" > "$REPO/README.md"
run_init "$REPO" -n "myproject" --force-template
# After force, the file should contain the template's h1 with the project name
assert_file_contains "$REPO/README.md" "# myproject"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: CLAUDE.md is a short stub pointing to AGENTS.md
# ─────────────────────────────────────────────────────────────────────────────
describe "init CLAUDE.md is a stub pointing to AGENTS.md"
REPO=$(make_test_repo)
run_init "$REPO" -n "myproject"
assert_file_contains "$REPO/CLAUDE.md" "AGENTS\.md"
local lines
lines=$(wc -l < "$REPO/CLAUDE.md")
(( lines <= 10 )) || { printf "  FAIL  CLAUDE.md should be short, got %d lines\n" "$lines"; (( TESTS_FAILED++ )) || true; }
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: does not copy .markdownlint.yaml if one already exists
# ─────────────────────────────────────────────────────────────────────────────
describe "init skips markdownlint config if already present"
REPO=$(make_test_repo)
echo "default: false" > "$REPO/.markdownlint.yaml"
run_init "$REPO" -n "myproject"
assert_file_contains "$REPO/.markdownlint.yaml" "default: false" "should not overwrite existing config"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: creates per-directory files for a subdirectory with files
# ─────────────────────────────────────────────────────────────────────────────
describe "init creates per-directory docs for subdirectory"
REPO=$(make_test_repo)
mkdir -p "$REPO/src"
touch "$REPO/src/main.py"
run_init "$REPO" -n "myproject"
assert_file_exists "$REPO/src/README.md"
assert_file_exists "$REPO/src/AGENTS.md"
assert_file_exists "$REPO/src/CLAUDE.md"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: excluded directories do not get documentation
# ─────────────────────────────────────────────────────────────────────────────
describe "init skips excluded directories"
REPO=$(make_test_repo)
mkdir -p "$REPO/node_modules/some-package"
touch "$REPO/node_modules/some-package/index.js"
run_init "$REPO" -n "myproject"
assert_file_not_exists "$REPO/node_modules/some-package/README.md"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: CONCEPTS.md contains the project name
# ─────────────────────────────────────────────────────────────────────────────
describe "init CONCEPTS.md contains project name"
REPO=$(make_test_repo)
run_init "$REPO" -n "coolproject"
assert_file_contains "$REPO/CONCEPTS.md" "coolproject"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: CHANGELOG.md has Unreleased section
# ─────────────────────────────────────────────────────────────────────────────
describe "init CHANGELOG.md has Unreleased section"
REPO=$(make_test_repo)
run_init "$REPO" -n "myproject"
assert_file_contains "$REPO/CHANGELOG.md" "\[Unreleased\]"
rm -rf "$REPO"

test_summary
