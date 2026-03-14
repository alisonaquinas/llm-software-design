#!/usr/bin/env bash
# run-all-tests.sh — Run all well-documented test suites.
#
# Usage: bash tests/run-all-tests.sh
# Exit: 0 if all suites pass, 1 if any fail

set -euo pipefail
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SUITES=(
  test-init-docs.sh
  test-audit-docs.sh
  test-add-file-headers.sh
  test-check-markdownlint.sh
)

PASSED=0
FAILED=0

for suite in "${SUITES[@]}"; do
  printf "\n══ %s ══\n" "$suite"
  set +e
  bash "$TESTS_DIR/$suite"
  code=$?
  set -e
  if (( code == 0 )); then
    (( PASSED++ )) || true
  else
    (( FAILED++ )) || true
  fi
done

printf "\n══ Suite summary: %d passed, %d failed ══\n" "$PASSED" "$FAILED"
(( FAILED == 0 ))
