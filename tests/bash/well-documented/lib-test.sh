#!/usr/bin/env bash
# lib-test.sh — Minimal test framework for well-documented helper scripts.
#
# Usage: source this file, then call assert_* functions.
# Call test_summary at the end of each test file.

TESTS_RUN=0
TESTS_FAILED=0
CURRENT_TEST=""

# Set the name of the currently running test (displayed on failure)
describe() {
  CURRENT_TEST="$*"
}

# assert_eq EXPECTED ACTUAL [MESSAGE]
assert_eq() {
  local expected="$1" actual="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if [[ "$expected" != "$actual" ]]; then
    printf "  FAIL  [%s] assert_eq\n" "$CURRENT_TEST"
    printf "        expected: %q\n" "$expected"
    printf "        actual:   %q\n" "$actual"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_contains NEEDLE HAYSTACK [MESSAGE]
assert_contains() {
  local needle="$1" haystack="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if [[ "$haystack" != *"$needle"* ]]; then
    printf "  FAIL  [%s] assert_contains\n" "$CURRENT_TEST"
    printf "        needle:   %q\n" "$needle"
    printf "        haystack: %q\n" "$haystack"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_not_contains NEEDLE HAYSTACK [MESSAGE]
assert_not_contains() {
  local needle="$1" haystack="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if [[ "$haystack" == *"$needle"* ]]; then
    printf "  FAIL  [%s] assert_not_contains\n" "$CURRENT_TEST"
    printf "        unexpected needle: %q\n" "$needle"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_file_exists PATH [MESSAGE]
assert_file_exists() {
  local path="$1" msg="${2:-}"
  (( TESTS_RUN++ )) || true
  if [[ ! -f "$path" ]]; then
    printf "  FAIL  [%s] assert_file_exists: %s\n" "$CURRENT_TEST" "$path"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_file_not_exists PATH [MESSAGE]
assert_file_not_exists() {
  local path="$1" msg="${2:-}"
  (( TESTS_RUN++ )) || true
  if [[ -f "$path" ]]; then
    printf "  FAIL  [%s] assert_file_not_exists: %s\n" "$CURRENT_TEST" "$path"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_file_contains PATH PATTERN [MESSAGE]
assert_file_contains() {
  local path="$1" pattern="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if ! grep -qP "$pattern" "$path" 2>/dev/null; then
    printf "  FAIL  [%s] assert_file_contains: %s\n" "$CURRENT_TEST" "$path"
    printf "        pattern: %s\n" "$pattern"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_file_not_contains PATH PATTERN [MESSAGE]
assert_file_not_contains() {
  local path="$1" pattern="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if grep -qP "$pattern" "$path" 2>/dev/null; then
    printf "  FAIL  [%s] assert_file_not_contains: %s\n" "$CURRENT_TEST" "$path"
    printf "        unexpected pattern: %s\n" "$pattern"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_exit_code EXPECTED ACTUAL [MESSAGE]
assert_exit_code() {
  local expected="$1" actual="$2" msg="${3:-}"
  (( TESTS_RUN++ )) || true
  if [[ "$expected" != "$actual" ]]; then
    printf "  FAIL  [%s] assert_exit_code: expected %s, got %s\n" \
      "$CURRENT_TEST" "$expected" "$actual"
    [[ -n "$msg" ]] && printf "        %s\n" "$msg"
    (( TESTS_FAILED++ )) || true
  fi
}

# assert_pass (previous command must have exited 0 — use: assert_pass $?)
assert_pass() {
  local code="${1:-$?}"
  assert_exit_code 0 "$code" "expected command to exit 0"
}

# assert_fail (previous command must have exited non-0 — use: assert_fail $?)
assert_fail() {
  local code="${1:-$?}"
  (( TESTS_RUN++ )) || true
  if [[ "$code" == "0" ]]; then
    printf "  FAIL  [%s] assert_fail: expected non-zero exit, got 0\n" "$CURRENT_TEST"
    (( TESTS_FAILED++ )) || true
  fi
}

# Print summary and exit with 1 if any tests failed
test_summary() {
  local passed=$(( TESTS_RUN - TESTS_FAILED ))
  if (( TESTS_FAILED == 0 )); then
    printf "\nOK  %d / %d tests passed\n" "$passed" "$TESTS_RUN"
    exit 0
  else
    printf "\nFAIL  %d / %d tests failed\n" "$TESTS_FAILED" "$TESTS_RUN"
    exit 1
  fi
}

# Create a temporary test repository and return the path
make_test_repo() {
  local tmp
  tmp=$(mktemp -d)
  printf '%s' "$tmp"
}
