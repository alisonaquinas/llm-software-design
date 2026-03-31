#!/usr/bin/env bash
# check-markdownlint.sh — Run markdownlint-cli2 on all Markdown files in a repository.
#
# Resolves the project's markdownlint config automatically. Falls back to the
# well-documented base config at assets/config/.markdownlint.yaml if no project
# config is found. Exits 0 if all files pass, 1 if any violations remain.
#
# Usage: check-markdownlint.sh [-r ROOT] [-c CONFIG] [--fix] [-q] [-h]
#   -r ROOT     Repository root to check (default: current directory)
#   -c CONFIG   Explicit config file path (overrides auto-resolution)
#   --fix       Apply auto-fixable corrections
#   -q          Quiet — only show violations
#   -h          Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"

ROOT="$(pwd)"
CONFIG=""
FIX=false
QUIET=false

usage() {
  grep '^# ' "$0" | sed 's/^# //'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r) ROOT="$2"; shift 2 ;;
    -c) CONFIG="$2"; shift 2 ;;
    --fix) FIX=true; shift ;;
    -q) QUIET=true; shift ;;
    -h|--help) usage ;;
    --) shift; break ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

ROOT="$(realpath "$ROOT")"

# ── resolve config ────────────────────────────────────────────────────────────

if [[ -z "$CONFIG" ]]; then
  for candidate in \
      "$ROOT/.markdownlint.yaml" \
      "$ROOT/.markdownlint.json" \
      "$ROOT/.markdownlint-cli2.jsonc" \
      "$ROOT/markdownlint-cli2.jsonc"; do
    if [[ -f "$candidate" ]]; then
      CONFIG="$candidate"
      break
    fi
  done
  # Fall back to the bundled base config
  if [[ -z "$CONFIG" ]]; then
    CONFIG="$ASSETS_DIR/config/.markdownlint.yaml"
    $QUIET || printf "No project markdownlint config found; using bundled base config.\n"
    $QUIET || printf "Run 'init-docs.sh' to add .markdownlint.yaml to your project.\n"
  fi
fi

$QUIET || printf "Config : %s\n" "$CONFIG"
$QUIET || printf "Root   : %s\n" "$ROOT"
$QUIET || printf "Fix    : %s\n" "$FIX"
$QUIET || printf "\n"

# ── resolve runner ────────────────────────────────────────────────────────────

if command -v markdownlint-cli2 &>/dev/null; then
  RUNNER=(markdownlint-cli2)
elif [[ -x "$ROOT/node_modules/.bin/markdownlint-cli2" ]]; then
  RUNNER=("$ROOT/node_modules/.bin/markdownlint-cli2")
elif command -v npx &>/dev/null; then
  RUNNER=(npx --yes markdownlint-cli2)
else
  printf 'ERROR: markdownlint-cli2 is not installed.\n' >&2
  printf 'Install with: npm install -g markdownlint-cli2\n' >&2
  exit 127
fi

# ── build command ─────────────────────────────────────────────────────────────

CMD=("${RUNNER[@]}" --config "$CONFIG")
$FIX && CMD+=(--fix)

# Exclusion globs  (markdownlint-cli2 uses !-prefixed patterns in the config,
# but we also pass them as ignore arguments where supported)
TARGETS=(
  "$ROOT/**/*.md"
  "$ROOT/**/*.markdown"
  "!$ROOT/node_modules/**"
  "!$ROOT/vendor/**"
  "!$ROOT/.venv/**"
  "!$ROOT/venv/**"
  "!$ROOT/dist/**"
  "!$ROOT/out/**"
  "!$ROOT/build/**"
  "!$ROOT/.git/**"
)

CMD+=("${TARGETS[@]}")

# ── run ───────────────────────────────────────────────────────────────────────

set +e
"${CMD[@]}"
EXIT=$?
set -e

if (( EXIT == 0 )); then
  printf "\nAll Markdown files pass.\n"
else
  printf "\nMarkdown violations found. "
  if $FIX; then
    printf "Some may have been auto-fixed; re-run without --fix to confirm.\n"
  else
    printf "Run with --fix to apply auto-corrections.\n"
  fi
fi

exit $EXIT
