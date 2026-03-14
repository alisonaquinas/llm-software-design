#!/usr/bin/env bash
# normalize-docs.sh — Non-destructively fill documentation gaps in a repository.
#
# Runs audit-docs.sh to find all FAILs and WARNs, then:
#   - Creates missing required files using init-docs.sh (FAIL items only)
#   - Extends thin AGENTS.md files with missing sections (WARN items)
#   - Appends missing cross-references to AGENTS.md files
#
# Existing file content is ALWAYS preserved. This script only adds — it never
# removes or rewrites content that is already present.
#
# Usage: normalize-docs.sh [-r ROOT] [-n NAME] [-y] [-q] [-h]
#   -r ROOT   Repository root (default: current directory)
#   -n NAME   Project name (default: basename of ROOT)
#   -y        Skip confirmation prompt
#   -q        Quiet — only show changes made
#   -h        Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

ROOT="$(pwd)"
PROJECT_NAME=""
YES=false
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
    -y) YES=true; shift ;;
    -q) QUIET=true; shift ;;
    -h|--help) usage ;;
    --) shift; break ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

ROOT="$(realpath "$ROOT")"
[[ -z "$PROJECT_NAME" ]] && PROJECT_NAME="$(basename "$ROOT")"

# ── dry-run audit to find gaps ───────────────────────────────────────────────

echo "── Auditing $ROOT ..."
AUDIT_OUT=$(mktemp)
set +e
bash "$SCRIPT_DIR/audit-docs.sh" -r "$ROOT" > "$AUDIT_OUT" 2>&1
AUDIT_EXIT=$?
set -e

# Show the audit summary
cat "$AUDIT_OUT"

if (( AUDIT_EXIT == 0 )); then
  echo ""
  echo "No FAILs found — nothing to do."
  rm -f "$AUDIT_OUT"
  exit 0
fi

# Count items to fix
FAILS=$(grep -c '^FAIL' "$AUDIT_OUT" || true)
WARNS=$(grep -c '^WARN' "$AUDIT_OUT" || true)
echo ""
printf "Found %d FAIL(s) and %d WARN(s) to address.\n" "$FAILS" "$WARNS"

# ── confirmation ─────────────────────────────────────────────────────────────

if ! $YES; then
  printf "Proceed with normalization? [y/N] "
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── fix missing root files (R-series FAILs) ──────────────────────────────────

echo ""
echo "── Fixing root-level gaps ..."
bash "$SCRIPT_DIR/init-docs.sh" -r "$ROOT" -n "$PROJECT_NAME" -q

# ── fix missing directory files (D-series FAILs) ─────────────────────────────

echo ""
echo "── Fixing per-directory gaps ..."

fix_missing_dir_file() {
  local dir="$1" filename="$2"

  case "$filename" in
    README.md)
      if [[ ! -f "$dir/README.md" ]]; then
        local rel="${dir#"$ROOT/"}"
        render_template \
          "$ASSETS_DIR/templates/README.md.tmpl" \
          "$dir/README.md" \
          "PROJECT_NAME=$rel" \
          "PROJECT_DESC=<TODO: describe what lives in this directory>" \
          "TODAY=$TODAY"
        printf "  create  %s/README.md\n" "$rel"
      fi
      ;;
    AGENTS.md)
      if [[ ! -f "$dir/AGENTS.md" ]]; then
        local rel="${dir#"$ROOT/"}"
        # Compute relative depth for parent link
        local depth=0 tmp="$dir"
        while [[ "$tmp" != "$ROOT" ]]; do tmp="$(dirname "$tmp")"; (( depth++ )) || true; done
        local parent_link="../AGENTS.md"
        render_template \
          "$ASSETS_DIR/templates/AGENTS.md.tmpl" \
          "$dir/AGENTS.md" \
          "PROJECT_NAME=$rel" \
          "DIR_LABEL=$rel" \
          "PARENT_AGENTS_LINK=$parent_link" \
          "TODAY=$TODAY"
        printf "  create  %s/AGENTS.md\n" "$rel"
      fi
      ;;
    CLAUDE.md)
      if [[ ! -f "$dir/CLAUDE.md" ]]; then
        local rel="${dir#"$ROOT/"}"
        printf '# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.\n' \
          > "$dir/CLAUDE.md"
        printf "  create  %s/CLAUDE.md\n" "$rel"
      fi
      ;;
  esac
}

# Parse FAIL lines for D-series to find which dirs need which files
# Regex stored in a variable to avoid shell parsing issues with nested parens
RE_DFAIL='^FAIL[[:space:]]+D0[124][[:space:]]+([A-Z.]+)[[:space:]]+\(([^/]+)/'
while IFS= read -r line; do
  if [[ "$line" =~ $RE_DFAIL ]]; then
    local_file="${BASH_REMATCH[1]}"
    rel_dir="${BASH_REMATCH[2]}"
    abs_dir="$ROOT/$rel_dir"
    [[ "$rel_dir" == "." ]] && abs_dir="$ROOT"
    fix_missing_dir_file "$abs_dir" "$local_file"
  fi
done < "$AUDIT_OUT"

# ── fix AGENTS.md WARNs: missing cross-references ────────────────────────────

echo ""
echo "── Appending missing cross-references ..."
RE_D03WARN='^WARN[[:space:]]+D03[[:space:]]+AGENTS\.md[[:space:]]+\(([^/]+)/'
while IFS= read -r line; do
  if [[ "$line" =~ $RE_D03WARN ]]; then
    rel_dir="${BASH_REMATCH[1]}"
    agents_file="$ROOT/$rel_dir/AGENTS.md"
    [[ ! -f "$agents_file" ]] && continue

    # Don't add if a See Also section already exists
    if grep -qiP '^## see also' "$agents_file"; then
      $QUIET || printf "  skip  %s/AGENTS.md (See Also already present)\n" "$rel_dir"
      continue
    fi

    printf "\n## See Also\n\n- [Parent AGENTS.md](../AGENTS.md)\n- [Root AGENTS.md](%s/AGENTS.md)\n" \
      "$(python3 -c "import os; print(os.path.relpath('$ROOT', '$ROOT/$rel_dir'))" 2>/dev/null || echo "../..")" \
      >> "$agents_file"
    printf "  append  %s/AGENTS.md — added See Also cross-references\n" "$rel_dir"
  fi
done < "$AUDIT_OUT"

# ── re-run audit for final score ─────────────────────────────────────────────

echo ""
echo "── Post-normalization audit ..."
bash "$SCRIPT_DIR/audit-docs.sh" -r "$ROOT" -q || true

rm -f "$AUDIT_OUT"
