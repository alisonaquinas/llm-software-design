#!/usr/bin/env bash
# init-docs.sh — Bootstrap documentation for a new or minimally documented repository.
#
# Usage: init-docs.sh [-r ROOT] [-n NAME] [-d DESC] [--project-type TYPE]
#                     [--maturity LEVEL] [--include-changelog]
#                     [--force-template] [-q] [-h]
#   -r ROOT              Repository root (default: current directory)
#   -n NAME              Project name (default: basename of ROOT)
#   -d DESC              One-line project description (default: "Describe this project")
#   --project-type TYPE  generic, library, cli, service, web-app, monorepo-package, data-pipeline
#   --maturity LEVEL     minimal, standard, or full (default: standard)
#   --include-changelog  Create CHANGELOG.md when absent
#   --force-template     Overwrite existing files with template content
#   -q                   Quiet — suppress skip messages
#   -h, --help           Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

ROOT="$(pwd)"
PROJECT_NAME=""
PROJECT_DESC="Describe this project."
PROJECT_TYPE="generic"
MATURITY="standard"
INCLUDE_CHANGELOG=false
FORCE=false
QUIET=false

usage() {
  grep '^# ' "$0" | sed 's/^# //'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r)
      ROOT="$2"
      shift 2
      ;;
    -n)
      PROJECT_NAME="$2"
      shift 2
      ;;
    -d)
      PROJECT_DESC="$2"
      shift 2
      ;;
    --project-type)
      PROJECT_TYPE="$2"
      shift 2
      ;;
    --maturity)
      MATURITY="$2"
      shift 2
      ;;
    --include-changelog)
      INCLUDE_CHANGELOG=true
      shift
      ;;
    --force-template)
      FORCE=true
      shift
      ;;
    -q)
      QUIET=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

ROOT="$(realpath "$ROOT")"
[[ -z "$PROJECT_NAME" ]] && PROJECT_NAME="$(basename "$ROOT")"
case "$PROJECT_TYPE" in
  generic|library|cli|service|web-app|monorepo-package|data-pipeline) ;;
  *) printf 'invalid project type: %s\n' "$PROJECT_TYPE" >&2; exit 2 ;;
esac
case "$MATURITY" in
  minimal|standard|full) ;;
  *) printf 'invalid maturity: %s\n' "$MATURITY" >&2; exit 2 ;;
esac

CREATED=0
SKIPPED=0

root_readme_template() {
  local candidate="$ASSETS_DIR/templates/README.${PROJECT_TYPE}.md.tmpl"
  if [[ -f "$candidate" ]]; then
    printf '%s\n' "$candidate"
  else
    printf '%s\n' "$ASSETS_DIR/templates/README.md.tmpl"
  fi
}

directory_readme_template() {
  printf '%s\n' "$ASSETS_DIR/templates/README.directory.md.tmpl"
}

write_rendered() {
  local dest="$1" tmpl="$2"; shift 2
  if [[ -f "$dest" && "$FORCE" == false ]]; then
    $QUIET || printf '  skip    %s\n' "${dest#"$ROOT/"}"
    (( SKIPPED++ )) || true
    return
  fi
  local tmp
  tmp=$(mktemp)
  render_template "$tmpl" "$tmp" "$@"
  mv "$tmp" "$dest"
  printf '  create  %s\n' "${dest#"$ROOT/"}"
  (( CREATED++ )) || true
}

write_agents() {
  local dest="$1" dir_label="$2" parent_links="$3" dir_path="$4"
  if [[ -f "$dest" && "$FORCE" == false ]]; then
    $QUIET || printf '  skip    %s\n' "${dest#"$ROOT/"}"
    (( SKIPPED++ )) || true
    return
  fi
  local tmp layout
  tmp=$(mktemp)
  layout=$(generate_layout_tree "$dir_path")
  render_template \
    "$ASSETS_DIR/templates/AGENTS.md.tmpl" \
    "$tmp" \
    "DIR_LABEL=$dir_label" \
    "PARENT_AGENTS_LINK=$parent_links" \
    "LAYOUT_TREE=$layout"
  mv "$tmp" "$dest"
  printf '  create  %s\n' "${dest#"$ROOT/"}"
  (( CREATED++ )) || true
}

write_claude_stub() {
  local dest="$1"
  if [[ -f "$dest" && "$FORCE" == false ]]; then
    $QUIET || printf '  skip    %s\n' "${dest#"$ROOT/"}"
    (( SKIPPED++ )) || true
    return
  fi
  cat > "$dest" <<'STUB'
# Claude Guidance

See [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.
STUB
  printf '  create  %s\n' "${dest#"$ROOT/"}"
  (( CREATED++ )) || true
}

parent_links_for_dir() {
  local dir="$1"
  if [[ "$dir" == "$ROOT" ]]; then
    printf '%s' ''
    return
  fi
  python3 - "$ROOT" "$dir" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1]).resolve()
dir_path = Path(sys.argv[2]).resolve()
parent = dir_path.parent
root_rel = Path(__import__('os').path.relpath(root / 'AGENTS.md', dir_path)).as_posix()
parent_rel = Path(__import__('os').path.relpath(parent / 'AGENTS.md', dir_path)).as_posix()
print(f'- [Parent AGENTS.md]({parent_rel})')
print(f'- [Root AGENTS.md]({root_rel})')
PY
}

should_create_dir_docs() {
  local dir="$1"
  doc_worthy_dir "$dir" "$ROOT" "$MATURITY"
}

echo "── Initializing documentation in $ROOT"

mkdir -p "$ROOT"
write_rendered "$ROOT/README.md" "$(root_readme_template)" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "PROJECT_DESC=$PROJECT_DESC"
write_agents "$ROOT/AGENTS.md" "$PROJECT_NAME" "" "$ROOT"
write_claude_stub "$ROOT/CLAUDE.md"

if [[ "$MATURITY" != "minimal" ]]; then
  write_rendered "$ROOT/CONCEPTS.md" "$ASSETS_DIR/templates/CONCEPTS.md.tmpl" \
    "PROJECT_NAME=$PROJECT_NAME"
  if [[ ! -f "$ROOT/.markdownlint.yaml" && ! -f "$ROOT/.markdownlint.json" && \
        ! -f "$ROOT/.markdownlint-cli2.jsonc" && ! -f "$ROOT/markdownlint-cli2.jsonc" ]]; then
    cp "$ASSETS_DIR/config/.markdownlint.yaml" "$ROOT/.markdownlint.yaml"
    printf '  create  .markdownlint.yaml\n'
    (( CREATED++ )) || true
  else
    $QUIET || printf '  skip    .markdownlint configuration\n'
    (( SKIPPED++ )) || true
  fi
fi

if $INCLUDE_CHANGELOG; then
  if [[ ! -f "$ROOT/CHANGELOG.md" || "$FORCE" == true ]]; then
    cat > "$ROOT/CHANGELOG.md" <<'CHANGELOG'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
CHANGELOG
    printf '  create  CHANGELOG.md\n'
    (( CREATED++ )) || true
  else
    $QUIET || printf '  skip    CHANGELOG.md\n'
    (( SKIPPED++ )) || true
  fi
fi

if [[ "$MATURITY" != "minimal" ]]; then
  while IFS= read -r dir; do
    [[ "$dir" == "$ROOT" ]] && continue
    should_create_dir_docs "$dir" || continue
    local_name="${dir#"$ROOT/"}"
    links=$(parent_links_for_dir "$dir")
    write_rendered "$dir/README.md" "$(directory_readme_template)" \
      "PROJECT_NAME=$local_name"
    write_agents "$dir/AGENTS.md" "$local_name" "$links" "$dir"
    if [[ "$MATURITY" == "full" ]]; then
      write_claude_stub "$dir/CLAUDE.md"
    fi
  done < <(find "$ROOT" -type d | sort)
fi

echo ""
printf 'Done: %d file(s) created, %d skipped.\n' "$CREATED" "$SKIPPED"
