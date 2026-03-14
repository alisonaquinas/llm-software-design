#!/usr/bin/env bash
# init-docs.sh — Bootstrap documentation for a new or minimally documented repository.
#
# Creates README.md, AGENTS.md, CLAUDE.md, CONCEPTS.md, and CHANGELOG.md at the
# repository root using the well-documented templates. Recursively creates README.md,
# AGENTS.md, and CLAUDE.md in each non-excluded source directory.
#
# EXISTING FILES ARE NEVER OVERWRITTEN. Their existing formatting takes precedence
# unless --force-template is passed.
#
# Usage: init-docs.sh [-r ROOT] [-n NAME] [-d DESC] [--force-template] [-q] [-h]
#   -r ROOT            Repository root (default: current directory)
#   -n NAME            Project name (default: basename of ROOT)
#   -d DESC            One-line project description (default: "<TODO: describe this project>")
#   --force-template   Overwrite existing files with template content
#   -q                 Quiet — suppress "skipped existing" messages
#   -h                 Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

ROOT="$(pwd)"
PROJECT_NAME=""
PROJECT_DESC="<TODO: describe this project>"
FORCE=false
QUIET=false
TODAY=$(date +%Y-%m-%d)

usage() {
  grep '^# ' "$0" | sed 's/^# //'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r) ROOT="$2"; shift 2 ;;
    -n) PROJECT_NAME="$2"; shift 2 ;;
    -d) PROJECT_DESC="$2"; shift 2 ;;
    --force-template) FORCE=true; shift ;;
    -q) QUIET=true; shift ;;
    -h|--help) usage ;;
    --) shift; break ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

ROOT="$(realpath "$ROOT")"
[[ -z "$PROJECT_NAME" ]] && PROJECT_NAME="$(basename "$ROOT")"

CREATED=0
SKIPPED=0

# ── write helper: respects FORCE and logs output ─────────────────────────────

write_file() {
  local dest="$1" src="$2"
  if [[ -f "$dest" ]] && ! $FORCE; then
    $QUIET || printf "  skip  %s (exists; use --force-template to overwrite)\n" "${dest#"$ROOT/"}"
    (( SKIPPED++ )) || true
    return
  fi
  cp "$src" "$dest"
  printf "  create  %s\n" "${dest#"$ROOT/"}"
  (( CREATED++ )) || true
}

render_and_write() {
  local dest="$1" tmpl="$2"; shift 2
  if [[ -f "$dest" ]] && ! $FORCE; then
    $QUIET || printf "  skip  %s (exists; use --force-template to overwrite)\n" "${dest#"$ROOT/"}"
    (( SKIPPED++ )) || true
    return
  fi
  local tmp
  tmp=$(mktemp)
  render_template "$tmpl" "$tmp" "$@"
  mv "$tmp" "$dest"
  printf "  create  %s\n" "${dest#"$ROOT/"}"
  (( CREATED++ )) || true
}

# ── root-level files ─────────────────────────────────────────────────────────

echo "── Initialising root: $ROOT"

render_and_write \
  "$ROOT/README.md" \
  "$ASSETS_DIR/templates/README.md.tmpl" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "PROJECT_DESC=$PROJECT_DESC" \
  "TODAY=$TODAY"

render_and_write \
  "$ROOT/AGENTS.md" \
  "$ASSETS_DIR/templates/AGENTS.md.tmpl" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "DIR_LABEL=root" \
  "PARENT_AGENTS_LINK=" \
  "TODAY=$TODAY"

# CLAUDE.md — always a one-line stub pointing to AGENTS.md
if [[ ! -f "$ROOT/CLAUDE.md" ]] || $FORCE; then
  printf '# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md) for the authoritative repository instructions.\n' \
    > "$ROOT/CLAUDE.md"
  printf "  create  CLAUDE.md\n"
  (( CREATED++ )) || true
else
  $QUIET || printf "  skip  CLAUDE.md (exists)\n"
  (( SKIPPED++ )) || true
fi

render_and_write \
  "$ROOT/CONCEPTS.md" \
  "$ASSETS_DIR/templates/CONCEPTS.md.tmpl" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "TODAY=$TODAY"

# CHANGELOG.md — minimal if absent
if [[ ! -f "$ROOT/CHANGELOG.md" ]] || $FORCE; then
  cat > "$ROOT/CHANGELOG.md" <<EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
EOF
  printf "  create  CHANGELOG.md\n"
  (( CREATED++ )) || true
else
  $QUIET || printf "  skip  CHANGELOG.md (exists)\n"
  (( SKIPPED++ )) || true
fi

# .markdownlint.yaml — copy base config if absent
if [[ ! -f "$ROOT/.markdownlint.yaml" && ! -f "$ROOT/.markdownlint.json" && \
      ! -f "$ROOT/.markdownlint-cli2.jsonc" && ! -f "$ROOT/markdownlint-cli2.jsonc" ]]; then
  cp "$ASSETS_DIR/config/.markdownlint.yaml" "$ROOT/.markdownlint.yaml"
  printf "  create  .markdownlint.yaml\n"
  (( CREATED++ )) || true
else
  $QUIET || printf "  skip  .markdownlint.yaml (config already present)\n"
  (( SKIPPED++ )) || true
fi

# ── per-directory files ───────────────────────────────────────────────────────

init_directory() {
  local dir="$1"
  local rel="${dir#"$ROOT/"}"

  # Skip excluded directories
  is_excluded_dir "$dir/" && return

  # Determine relative depth for parent AGENTS link
  local depth=0
  local tmp="$dir"
  while [[ "$tmp" != "$ROOT" ]]; do
    tmp="$(dirname "$tmp")"
    (( depth++ )) || true
  done

  local parent_link="../AGENTS.md"
  if (( depth > 1 )); then
    parent_link="$(printf '../%.0s' $(seq 1 $depth))AGENTS.md"
  fi

  echo ""
  echo "── Directory: $rel/"

  render_and_write \
    "$dir/README.md" \
    "$ASSETS_DIR/templates/README.md.tmpl" \
    "PROJECT_NAME=$rel" \
    "PROJECT_DESC=<TODO: describe what lives in this directory>" \
    "TODAY=$TODAY"

  render_and_write \
    "$dir/AGENTS.md" \
    "$ASSETS_DIR/templates/AGENTS.md.tmpl" \
    "PROJECT_NAME=$rel" \
    "DIR_LABEL=$rel" \
    "PARENT_AGENTS_LINK=$parent_link" \
    "TODAY=$TODAY"

  # CLAUDE.md stub
  if [[ ! -f "$dir/CLAUDE.md" ]] || $FORCE; then
    printf '# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.\n' \
      > "$dir/CLAUDE.md"
    printf "  create  %s/CLAUDE.md\n" "$rel"
    (( CREATED++ )) || true
  else
    $QUIET || printf "  skip  %s/CLAUDE.md (exists)\n" "$rel"
    (( SKIPPED++ )) || true
  fi
}

walk_and_init() {
  local dir="$1"
  is_excluded_dir "$dir/" && return

  local has_files
  has_files=$(find "$dir" -maxdepth 1 -type f | wc -l)
  if (( has_files > 0 )) && [[ "$dir" != "$ROOT" ]]; then
    init_directory "$dir"
  fi

  while IFS= read -r subdir; do
    [[ "$subdir" == "$dir" ]] && continue
    is_excluded_dir "$subdir/" || walk_and_init "$subdir"
  done < <(find "$dir" -maxdepth 1 -mindepth 1 -type d | sort)
}

walk_and_init "$ROOT"

echo ""
printf "Done: %d file(s) created, %d skipped.\n" "$CREATED" "$SKIPPED"
