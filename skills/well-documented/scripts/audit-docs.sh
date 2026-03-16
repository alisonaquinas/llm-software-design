#!/usr/bin/env bash
# audit-docs.sh — Audit a repository against the well-documented standard.
#
# Walks the repository tree and reports PASS / WARN / FAIL / SKIP for each
# required documentation element. Exits 0 if no FAILs, 1 otherwise.
#
# Usage: audit-docs.sh [-r ROOT] [-q]
#   -r ROOT   Repository root to audit (default: current directory)
#   -q        Quiet — only print FAILs and WARNs; suppress PASSes
#   -h        Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

ROOT="$(pwd)"
QUIET=false

usage() {
  grep '^# ' "$0" | sed 's/^# //'
  exit 0
}

while getopts ':r:qh' opt; do
  case "$opt" in
    r) ROOT="$OPTARG" ;;
    q) QUIET=true ;;
    h) usage ;;
    :) printf 'missing value for -%s\n' "$OPTARG" >&2; exit 2 ;;
    \?) printf 'unknown option: -%s\n' "$OPTARG" >&2; exit 2 ;;
  esac
done

ROOT="$(realpath "$ROOT")"

# ── helpers ─────────────────────────────────────────────────────────────────

emit_pass() { $QUIET || log_pass "$@"; }
emit_warn() { log_warn "$@"; }
emit_fail() { log_fail "$@"; }
emit_skip() { $QUIET || log_skip "$@"; }

# ── R-series: root-level checks ─────────────────────────────────────────────

check_root() {
  echo "── Root: $ROOT"

  # R01 README.md
  if [[ ! -f "$ROOT/README.md" ]]; then
    emit_fail "R01  README.md (root) — missing"
  elif ! file_has_content "$ROOT/README.md" 4; then
    emit_warn "R01  README.md (root) — fewer than 4 non-blank lines"
  else
    emit_pass "R01  README.md (root)"
  fi

  # R02 README has title
  if [[ -f "$ROOT/README.md" ]] && ! grep -qP '^# \S' "$ROOT/README.md"; then
    emit_warn "R02  README.md (root) — no top-level heading found"
  elif [[ -f "$ROOT/README.md" ]]; then
    emit_pass "R02  README.md title heading"
  fi

  # R03 README has installation section
  if [[ -f "$ROOT/README.md" ]] && ! grep -qiP '^#+ .*(install|setup|getting started|quick start)' "$ROOT/README.md"; then
    emit_warn "R03  README.md (root) — no Installation/Setup/Getting Started section"
  elif [[ -f "$ROOT/README.md" ]]; then
    emit_pass "R03  README.md installation section"
  fi

  # R04 README has usage section
  if [[ -f "$ROOT/README.md" ]] && ! grep -qiP '^#+ .*(usage|example|quick start|tutorial)' "$ROOT/README.md"; then
    emit_warn "R04  README.md (root) — no Usage/Examples section"
  elif [[ -f "$ROOT/README.md" ]]; then
    emit_pass "R04  README.md usage section"
  fi

  # R05 AGENTS.md
  if [[ ! -f "$ROOT/AGENTS.md" ]]; then
    emit_fail "R05  AGENTS.md (root) — missing"
  elif ! grep -qiP '^## (layout|structure|directory|files)' "$ROOT/AGENTS.md"; then
    emit_warn "R05  AGENTS.md (root) — no Layout section"
  else
    emit_pass "R05  AGENTS.md (root)"
  fi

  # R06 AGENTS.md layout is current
  if [[ -f "$ROOT/AGENTS.md" ]]; then
    local dead=0
    while IFS= read -r line; do
      local fname
      fname=$(echo "$line" | grep -oP '`[^`]+\.(md|json|yaml|sh|py|js|ts)`' | tr -d '`' | head -1) || true
      if [[ -n "$fname" ]] && [[ ! -e "$ROOT/$fname" ]]; then
        (( dead++ )) || true
      fi
    done < "$ROOT/AGENTS.md"
    if (( dead > 0 )); then
      emit_warn "R06  AGENTS.md (root) — layout references $dead file(s) that do not exist"
    else
      emit_pass "R06  AGENTS.md layout"
    fi
  fi

  # R07 AGENTS.md invariants section
  if [[ -f "$ROOT/AGENTS.md" ]] && ! grep -qiP '^## (invariant|do not violate|rules|constraints)' "$ROOT/AGENTS.md"; then
    emit_warn "R07  AGENTS.md (root) — no Invariants section"
  elif [[ -f "$ROOT/AGENTS.md" ]]; then
    emit_pass "R07  AGENTS.md invariants section"
  fi

  # R08 CLAUDE.md
  if [[ ! -f "$ROOT/CLAUDE.md" ]]; then
    emit_fail "R08  CLAUDE.md (root) — missing"
  else
    local lines
    lines=$(wc -l < "$ROOT/CLAUDE.md")
    if (( lines > 30 )); then
      emit_warn "R08  CLAUDE.md (root) — $lines lines; should be a short stub pointing to AGENTS.md"
    else
      emit_pass "R08  CLAUDE.md (root)"
    fi
  fi

  # R09 CONCEPTS.md
  if [[ ! -f "$ROOT/CONCEPTS.md" ]]; then
    emit_fail "R09  CONCEPTS.md (root) — missing"
  else
    local entries
    entries=$(grep -cP '^## ' "$ROOT/CONCEPTS.md" || echo 0)
    if (( entries < 3 )); then
      emit_warn "R09  CONCEPTS.md (root) — only $entries concept entries (need ≥ 3)"
    else
      emit_pass "R09  CONCEPTS.md ($entries entries)"
    fi
  fi

  # R10 CONCEPTS.md cross-references
  if [[ -f "$ROOT/CONCEPTS.md" ]]; then
    local missing_refs
    missing_refs=$(grep -cP '^## ' "$ROOT/CONCEPTS.md" || echo 0)
    local with_refs
    with_refs=$(grep -B5 -A10 '^## ' "$ROOT/CONCEPTS.md" | grep -cP '\*\*See also' || echo 0)
    if (( with_refs < missing_refs )); then
      emit_warn "R10  CONCEPTS.md — $(( missing_refs - with_refs )) concept(s) lack a 'See also' line"
    else
      emit_pass "R10  CONCEPTS.md cross-references"
    fi
  fi

  # R11 CONCEPTS.md links resolve
  if [[ -f "$ROOT/CONCEPTS.md" ]]; then
    local broken=0
    while IFS= read -r link; do
      link="${link#(}"; link="${link%)}"
      # Skip anchors, skill refs, and external URLs
      [[ "$link" == \#* || "$link" == \$* || "$link" == http* ]] && continue
      [[ ! -e "$ROOT/$link" ]] && (( broken++ )) || true
    done < <(grep -oP '\[.*?\]\(\K[^)]+' "$ROOT/CONCEPTS.md" || true)
    if (( broken > 0 )); then
      emit_fail "R11  CONCEPTS.md — $broken broken link(s)"
    else
      emit_pass "R11  CONCEPTS.md links"
    fi
  fi

  # R12 CHANGELOG.md
  if [[ ! -f "$ROOT/CHANGELOG.md" ]]; then
    emit_fail "R12  CHANGELOG.md (root) — missing"
  elif ! grep -qP '^\## \[' "$ROOT/CHANGELOG.md"; then
    emit_warn "R12  CHANGELOG.md — no version entries found"
  else
    emit_pass "R12  CHANGELOG.md"
  fi

  # M01 .markdownlint config exists
  if [[ ! -f "$ROOT/.markdownlint.yaml" && ! -f "$ROOT/.markdownlint.json" && \
        ! -f "$ROOT/.markdownlint-cli2.jsonc" && ! -f "$ROOT/markdownlint-cli2.jsonc" ]]; then
    emit_fail "M01  markdownlint config — none found (.markdownlint.yaml / .markdownlint-cli2.jsonc)"
  else
    emit_pass "M01  markdownlint config"
  fi

  # M02 all .md files pass markdownlint
  if command -v markdownlint-cli2 &>/dev/null || command -v markdownlint &>/dev/null; then
    check_markdownlint_all "$ROOT"
  else
    emit_skip "M02  markdownlint run — markdownlint-cli2 not installed"
  fi
}

check_markdownlint_all() {
  local root="$1"
  # Build exclusion args for markdownlint-cli2
  local config_arg=()
  for cfg in "$root/.markdownlint.yaml" "$root/.markdownlint.json" \
             "$root/.markdownlint-cli2.jsonc" "$root/markdownlint-cli2.jsonc"; do
    if [[ -f "$cfg" ]]; then
      config_arg=(--config "$cfg")
      break
    fi
  done

  local runner=(markdownlint-cli2)
  command -v markdownlint-cli2 &>/dev/null || runner=(markdownlint)

  local tmpout
  tmpout=$(mktemp)
  if "${runner[@]}" "${config_arg[@]}" \
      --ignore node_modules --ignore vendor --ignore .venv \
      --ignore dist --ignore out --ignore build \
      "$root/**/*.md" "$root/**/*.markdown" \
      >"$tmpout" 2>&1; then
    emit_pass "M02  markdownlint — all .md files pass"
  else
    # Distinguish a tool crash (SyntaxError / incompatible runtime) from real violations
    if grep -qP '^(SyntaxError|TypeError|Error:|node:)' "$tmpout" 2>/dev/null; then
      emit_warn "M02  markdownlint — tool exited with an error (check Node.js version ≥ 20 and markdownlint-cli2 install); run check-markdownlint.sh for details"
    else
      local count
      count=$(grep -cP '\S' "$tmpout" || echo 0)
      emit_fail "M02  markdownlint — $count violation(s); run check-markdownlint.sh for details"
    fi
  fi
  rm -f "$tmpout"
}

# ── D-series: per-directory checks ──────────────────────────────────────────

check_directory() {
  local dir="$1"
  local rel="${dir#"$ROOT/"}"
  [[ "$dir" == "$ROOT" ]] && rel="."

  # D01 README.md
  if [[ ! -f "$dir/README.md" ]]; then
    emit_fail "D01  README.md ($rel/) — missing"
  elif ! file_has_content "$dir/README.md" 2; then
    emit_warn "D01  README.md ($rel/) — no description of what lives here"
  else
    emit_pass "D01  README.md ($rel/)"
  fi

  # D02 AGENTS.md
  if [[ ! -f "$dir/AGENTS.md" ]]; then
    emit_fail "D02  AGENTS.md ($rel/) — missing"
  elif ! grep -qiP '^## (layout|structure|directory|files|workflows|invariant)' "$dir/AGENTS.md"; then
    emit_warn "D02  AGENTS.md ($rel/) — missing layout or invariants section"
  else
    emit_pass "D02  AGENTS.md ($rel/)"
  fi

  # D03 AGENTS.md cross-references parent (only for non-root dirs)
  if [[ "$dir" != "$ROOT" ]] && [[ -f "$dir/AGENTS.md" ]]; then
    if ! grep -qP '\.\./.*AGENTS\.md' "$dir/AGENTS.md"; then
      emit_warn "D03  AGENTS.md ($rel/) — no cross-reference to parent AGENTS.md"
    else
      emit_pass "D03  AGENTS.md ($rel/) cross-reference"
    fi
  fi

  # D04 CLAUDE.md
  if [[ ! -f "$dir/CLAUDE.md" ]]; then
    emit_fail "D04  CLAUDE.md ($rel/) — missing"
  else
    local lines
    lines=$(wc -l < "$dir/CLAUDE.md")
    if (( lines > 20 )); then
      emit_warn "D04  CLAUDE.md ($rel/) — $lines lines; should be a short stub or symlink"
    else
      emit_pass "D04  CLAUDE.md ($rel/)"
    fi
  fi
}

# ── Walk all non-excluded source directories ─────────────────────────────────

walk_directories() {
  local dir="$1"
  is_excluded_dir "$dir/" && { emit_skip "D--  $dir (excluded)"; return; }

  # Only audit directories that contain at least one file (not pure parents)
  local has_files
  has_files=$(find "$dir" -maxdepth 1 -type f | wc -l)
  if (( has_files > 0 )) && [[ "$dir" != "$ROOT" ]]; then
    check_directory "$dir"
  fi

  while IFS= read -r subdir; do
    [[ "$subdir" == "$dir" ]] && continue
    is_excluded_dir "$subdir/" || walk_directories "$subdir"
  done < <(find "$dir" -maxdepth 1 -mindepth 1 -type d | sort)
}

# ── main ─────────────────────────────────────────────────────────────────────

check_root
echo ""
echo "── Directories"
walk_directories "$ROOT"
score_report

(( FAIL_COUNT == 0 ))
