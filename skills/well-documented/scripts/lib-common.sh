#!/usr/bin/env bash
# lib-common.sh — shared utilities for well-documented helper scripts
#
# Source this file from other scripts:
#   source "$(dirname "$0")/lib-common.sh"

# ── colour support ──────────────────────────────────────────────────────────
if [[ -t 1 ]] && command -v tput &>/dev/null; then
  RED=$(tput setaf 1)
  YEL=$(tput setaf 3)
  GRN=$(tput setaf 2)
  DIM=$(tput dim)
  RST=$(tput sgr0)
else
  RED='' YEL='' GRN='' DIM='' RST=''
fi

# ── counters (caller resets before use) ────────────────────────────────────
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

# ── output helpers ──────────────────────────────────────────────────────────
log_pass() { printf "${GRN}PASS${RST}  %s\n"  "$*"; (( PASS_COUNT++ )) || true; }
log_warn() { printf "${YEL}WARN${RST}  %s\n"  "$*"; (( WARN_COUNT++ )) || true; }
log_fail() { printf "${RED}FAIL${RST}  %s\n"  "$*"; (( FAIL_COUNT++ )) || true; }
log_skip() { printf "${DIM}SKIP${RST}  %s\n"  "$*"; (( SKIP_COUNT++ )) || true; }
log_info() { printf "      %s\n"              "$*"; }

score_report() {
  local total=$(( PASS_COUNT + WARN_COUNT + FAIL_COUNT ))
  local pct=0
  (( total > 0 )) && pct=$(( PASS_COUNT * 100 / total )) || true
  printf "\nSCORE: %d / %d items pass (%d%%)" "$PASS_COUNT" "$total" "$pct"
  (( FAIL_COUNT > 0 )) && printf "  —  ${RED}%d FAIL${RST}" "$FAIL_COUNT" || true
  (( WARN_COUNT > 0 )) && printf "  —  ${YEL}%d WARN${RST}" "$WARN_COUNT" || true
  printf "\n"
}

# ── directory exclusion ─────────────────────────────────────────────────────
# Returns exit code 0 (true) if a path component matches an excluded pattern
is_excluded_dir() {
  local path="$1"
  local excluded=(
    node_modules vendor .venv venv __pycache__
    dist out build .git .cache
    ".next" ".nuxt" ".svelte-kit" ".parcel-cache"
    coverage ".nyc_output" target
  )
  for ex in "${excluded[@]}"; do
    if [[ "$path" == *"/$ex/"* || "$path" == *"/$ex" ]]; then
      return 0
    fi
  done
  return 1
}

# ── template rendering ──────────────────────────────────────────────────────
# render_template TEMPLATE_FILE OUTPUT_FILE [VAR=VALUE ...]
# Replaces {{KEY}} placeholders with values from the VAR=VALUE pairs.
render_template() {
  local tmpl="$1" out="$2"; shift 2
  local content
  content=$(cat "$tmpl")
  for pair in "$@"; do
    local key="${pair%%=*}"
    local val="${pair#*=}"
    # escape & for sed replacement
    local escaped_val
    escaped_val=$(printf '%s' "$val" | sed 's/[&/\]/\\&/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
    content=$(printf '%s' "$content" | sed "s/{{${key}}}/${escaped_val}/g")
  done
  printf '%s\n' "$content" > "$out"
}

# ── detect existing file style ──────────────────────────────────────────────
# Outputs a style tag: "atx" (# headings), "setext" (underline headings), or "unknown"
detect_heading_style() {
  local file="$1"
  if grep -qP '^#{1,6} ' "$file" 2>/dev/null; then
    echo "atx"
  elif grep -qP '^[=-]{3,}$' "$file" 2>/dev/null; then
    echo "setext"
  else
    echo "unknown"
  fi
}

# Outputs "pipe" (|---|) or "html" (<table>) or "unknown"
detect_table_style() {
  local file="$1"
  if grep -qP '^\|' "$file" 2>/dev/null; then
    echo "pipe"
  elif grep -qi '<table' "$file" 2>/dev/null; then
    echo "html"
  else
    echo "unknown"
  fi
}

# Returns 0 if file exists AND has more than N non-blank lines
file_has_content() {
  local file="$1" min_lines="${2:-3}"
  [[ -f "$file" ]] || return 1
  local count
  count=$(grep -cP '\S' "$file" 2>/dev/null || echo 0)
  (( count >= min_lines ))
}

# ── ASSETS_DIR resolution ───────────────────────────────────────────────────
# When a script is invoked, ASSETS_DIR should point to the skill's assets/
# directory. Scripts set this themselves relative to their own location:
#   ASSETS_DIR="$(dirname "$0")/../assets"
