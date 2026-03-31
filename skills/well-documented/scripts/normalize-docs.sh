#!/usr/bin/env bash
# normalize-docs.sh — Non-destructively fill documentation gaps in a repository.
#
# Usage: normalize-docs.sh [-r ROOT] [-n NAME] [-d DESC] [--project-type TYPE]
#                          [--maturity LEVEL] [--include-changelog] [-y] [-q] [-h]
#   -r ROOT              Repository root (default: current directory)
#   -n NAME              Project name (default: basename of ROOT)
#   -d DESC              One-line project description for newly created README files
#   --project-type TYPE  generic, library, cli, service, web-app, monorepo-package, data-pipeline
#   --maturity LEVEL     minimal, standard, or full (default: standard)
#   --include-changelog  Create CHANGELOG.md when the audit calls for it
#   -y                   Skip confirmation prompt
#   -q                   Quiet — only show essential changes
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
YES=false
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
    -y)
      YES=true
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

AUDIT_OUT=$(mktemp)
set +e
bash "$SCRIPT_DIR/audit-docs.sh" -r "$ROOT" --maturity "$MATURITY" > "$AUDIT_OUT" 2>&1
AUDIT_EXIT=$?
set -e

cat "$AUDIT_OUT"
FAILS=$(grep -c '^FAIL' "$AUDIT_OUT" || true)
WARNS=$(grep -c '^WARN' "$AUDIT_OUT" || true)

if (( FAILS == 0 && WARNS == 0 )); then
  echo ""
  echo "No gaps detected."
  rm -f "$AUDIT_OUT"
  exit 0
fi

echo ""
printf 'Found %d FAIL(s) and %d WARN(s).\n' "$FAILS" "$WARNS"

if ! $YES; then
  printf 'Proceed with normalization? [y/N] '
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo 'Aborted.'; rm -f "$AUDIT_OUT"; exit 0; }
fi

echo ""
echo "── Creating root and baseline docs"
INIT_ARGS=(
  -r "$ROOT"
  -n "$PROJECT_NAME"
  -d "$PROJECT_DESC"
  --project-type "$PROJECT_TYPE"
  --maturity "$MATURITY"
  -q
)
$INCLUDE_CHANGELOG && INIT_ARGS+=(--include-changelog)
bash "$SCRIPT_DIR/init-docs.sh" "${INIT_ARGS[@]}"

echo ""
echo "── Filling remaining directory gaps"

create_dir_docs() {
  local dir="$1"
  local rel="${dir#"$ROOT/"}"
  local links tmp

  links=$(python3 - "$ROOT" "$dir" <<'PY'
from pathlib import Path
import os
import sys
root = Path(sys.argv[1]).resolve()
dir_path = Path(sys.argv[2]).resolve()
parent_rel = Path(os.path.relpath(dir_path.parent / 'AGENTS.md', dir_path)).as_posix()
root_rel = Path(os.path.relpath(root / 'AGENTS.md', dir_path)).as_posix()
print(f'- [Parent AGENTS.md]({parent_rel})')
print(f'- [Root AGENTS.md]({root_rel})')
PY
)

  if [[ ! -f "$dir/README.md" ]]; then
    render_template "$ASSETS_DIR/templates/README.directory.md.tmpl" "$dir/README.md" "PROJECT_NAME=$rel"
    printf '  create  %s/README.md\n' "$rel"
  fi

  if [[ ! -f "$dir/AGENTS.md" ]]; then
    tmp=$(mktemp)
    render_template "$ASSETS_DIR/templates/AGENTS.md.tmpl" "$tmp" \
      "DIR_LABEL=$rel" \
      "PARENT_AGENTS_LINK=$links" \
      "LAYOUT_TREE=$(generate_layout_tree "$dir")"
    mv "$tmp" "$dir/AGENTS.md"
    printf '  create  %s/AGENTS.md\n' "$rel"
  fi

  if [[ "$MATURITY" == "full" && ! -f "$dir/CLAUDE.md" ]]; then
    cat > "$dir/CLAUDE.md" <<'STUB'
# Claude Guidance

See [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.
STUB
    printf '  create  %s/CLAUDE.md\n' "$rel"
  fi
}

RE_DIR_DOC='^(FAIL|WARN)[[:space:]]+D0[124][[:space:]]+.*\(([^)]+)\/\)'
RE_DIR_XREF='^WARN[[:space:]]+D03[[:space:]]+AGENTS\.md[[:space:]]+\(([^)]+)\/\)'

while IFS= read -r line; do
  if [[ "$line" =~ $RE_DIR_DOC ]]; then
    rel_dir="${BASH_REMATCH[2]}"
    abs_dir="$ROOT/$rel_dir"
    [[ -d "$abs_dir" ]] || continue
    create_dir_docs "$abs_dir"
  fi

  if [[ "$line" =~ $RE_DIR_XREF ]]; then
    rel_dir="${BASH_REMATCH[1]}"
    agents_file="$ROOT/$rel_dir/AGENTS.md"
    if [[ -f "$agents_file" ]] && ! grep -qi '^## See Also' "$agents_file"; then
      links=$(python3 - "$ROOT" "$ROOT/$rel_dir" <<'PY'
from pathlib import Path
import os
import sys
root = Path(sys.argv[1]).resolve()
dir_path = Path(sys.argv[2]).resolve()
parent_rel = Path(os.path.relpath(dir_path.parent / 'AGENTS.md', dir_path)).as_posix()
root_rel = Path(os.path.relpath(root / 'AGENTS.md', dir_path)).as_posix()
print(f'- [Parent AGENTS.md]({parent_rel})')
print(f'- [Root AGENTS.md]({root_rel})')
PY
)
      printf '\n## See Also\n\n%s\n' "$links" >> "$agents_file"
      printf '  append  %s/AGENTS.md — added See Also\n' "$rel_dir"
    fi
  fi
done < "$AUDIT_OUT"

echo ""
echo "── Post-normalization audit"
bash "$SCRIPT_DIR/audit-docs.sh" -r "$ROOT" --maturity "$MATURITY" -q || true

rm -f "$AUDIT_OUT"
exit "$AUDIT_EXIT"
