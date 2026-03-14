#!/usr/bin/env bash
# test-add-file-headers.sh — Tests for scripts/add-file-headers.sh
#
# Run: bash tests/test-add-file-headers.sh
# Exit: 0 if all pass, 1 if any fail

set -euo pipefail
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$TESTS_DIR/../../skills/well-documented/scripts"
# shellcheck source=lib-test.sh
source "$TESTS_DIR/lib-test.sh"

run_add_headers() {
  bash "$SCRIPTS_DIR/add-file-headers.sh" "$@"
}

# ─────────────────────────────────────────────────────────────────────────────
# TEST: adds Python header to a file with no header
# ─────────────────────────────────────────────────────────────────────────────
describe "adds Python docstring header to undocumented .py file"
REPO=$(make_test_repo)
printf 'def foo():\n    pass\n' > "$REPO/foo.py"
run_add_headers -t "$REPO/foo.py" -y -d "A Python module" > /dev/null
assert_file_contains "$REPO/foo.py" '"""' "Python file should have docstring header"
assert_file_contains "$REPO/foo.py" "def foo" "original code should be preserved"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: adds TypeScript JSDoc header
# ─────────────────────────────────────────────────────────────────────────────
describe "adds TypeScript JSDoc header to undocumented .ts file"
REPO=$(make_test_repo)
printf 'export function bar(): void {}\n' > "$REPO/bar.ts"
run_add_headers -t "$REPO/bar.ts" -y > /dev/null
assert_file_contains "$REPO/bar.ts" '/\*\*' "TS file should have JSDoc block"
assert_file_contains "$REPO/bar.ts" 'export function bar' "original code should be preserved"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: does NOT overwrite an existing Python docstring
# ─────────────────────────────────────────────────────────────────────────────
describe "skips Python file that already has a docstring header"
REPO=$(make_test_repo)
printf '"""This is the existing module docstring."""\n\ndef foo():\n    pass\n' > "$REPO/foo.py"
run_add_headers -t "$REPO/foo.py" -y > /dev/null
assert_file_contains "$REPO/foo.py" "This is the existing module docstring" \
  "existing docstring should be preserved"
# Verify the header wasn't doubled
local count
count=$(grep -c '"""' "$REPO/foo.py" || echo 0)
(( count == 2 )) || { printf "  FAIL  expected 2 triple-quote markers, got %d\n" "$count"; (( TESTS_FAILED++ )) || true; }
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: does NOT overwrite an existing JS block comment
# ─────────────────────────────────────────────────────────────────────────────
describe "skips JS file that already has a JSDoc header"
REPO=$(make_test_repo)
printf '/**\n * Existing doc.\n */\nfunction baz() {}\n' > "$REPO/baz.js"
run_add_headers -t "$REPO/baz.js" -y > /dev/null
assert_file_contains "$REPO/baz.js" "Existing doc" "existing JSDoc should be preserved"
local count
count=$(grep -c '/\*\*' "$REPO/baz.js" || echo 0)
(( count == 1 )) || { printf "  FAIL  expected 1 JSDoc block start, got %d\n" "$count"; (( TESTS_FAILED++ )) || true; }
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: adds bash header — includes shebang (only once)
# ─────────────────────────────────────────────────────────────────────────────
describe "adds bash header to undocumented .sh file"
REPO=$(make_test_repo)
printf 'echo hello\n' > "$REPO/hello.sh"
run_add_headers -t "$REPO/hello.sh" -y > /dev/null
assert_file_contains "$REPO/hello.sh" "#!/usr/bin/env bash" "bash header should include shebang"
assert_file_contains "$REPO/hello.sh" "echo hello" "original code should be preserved"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: --dry-run does not modify any files
# ─────────────────────────────────────────────────────────────────────────────
describe "dry-run does not modify files"
REPO=$(make_test_repo)
printf 'def foo():\n    pass\n' > "$REPO/foo.py"
BEFORE=$(cat "$REPO/foo.py")
run_add_headers -t "$REPO/foo.py" -n > /dev/null
AFTER=$(cat "$REPO/foo.py")
assert_eq "$BEFORE" "$AFTER" "file should be unchanged after dry-run"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: skips files in excluded directories
# ─────────────────────────────────────────────────────────────────────────────
describe "skips files in node_modules"
REPO=$(make_test_repo)
mkdir -p "$REPO/node_modules/pkg"
printf 'export const x = 1\n' > "$REPO/node_modules/pkg/index.js"
run_add_headers -t "$REPO" -y > /dev/null
# The file should still have no header (is_excluded_dir skips it)
assert_file_not_contains "$REPO/node_modules/pkg/index.js" '/\*\*' \
  "vendored files should not get headers"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: adds Rust inner doc comment to .rs file
# ─────────────────────────────────────────────────────────────────────────────
describe "adds Rust inner doc comment to undocumented .rs file"
REPO=$(make_test_repo)
printf 'pub fn greet() {}\n' > "$REPO/lib.rs"
run_add_headers -t "$REPO/lib.rs" -y > /dev/null
assert_file_contains "$REPO/lib.rs" '^//!' "Rust file should have inner doc comment"
assert_file_contains "$REPO/lib.rs" 'pub fn greet' "original code should be preserved"
rm -rf "$REPO"

# ─────────────────────────────────────────────────────────────────────────────
# TEST: adds Go package doc comment to .go file
# ─────────────────────────────────────────────────────────────────────────────
describe "adds Go package doc comment to undocumented .go file"
REPO=$(make_test_repo)
printf 'package main\n\nfunc main() {}\n' > "$REPO/main.go"
run_add_headers -t "$REPO/main.go" -y > /dev/null
assert_file_contains "$REPO/main.go" '// Package ' "Go file should have package doc"
assert_file_contains "$REPO/main.go" 'func main' "original code should be preserved"
rm -rf "$REPO"

test_summary
