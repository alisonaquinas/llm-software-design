#!/usr/bin/env bash
# lib-common.sh — shared utilities for well-documented helper scripts

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
log_pass() { printf "${GRN}PASS${RST}  %s\n" "$*"; (( PASS_COUNT++ )) || true; }
log_warn() { printf "${YEL}WARN${RST}  %s\n" "$*"; (( WARN_COUNT++ )) || true; }
log_fail() { printf "${RED}FAIL${RST}  %s\n" "$*"; (( FAIL_COUNT++ )) || true; }
log_skip() { printf "${DIM}SKIP${RST}  %s\n" "$*"; (( SKIP_COUNT++ )) || true; }
log_info() { printf "      %s\n" "$*"; }

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
is_excluded_dir() {
  local path="$1"
  local excluded=(
    node_modules vendor .venv venv __pycache__
    dist out build .git .cache
    .next .nuxt .svelte-kit .parcel-cache
    coverage .nyc_output target
  )
  for ex in "${excluded[@]}"; do
    if [[ "$path" == *"/$ex/"* || "$path" == *"/$ex" ]]; then
      return 0
    fi
  done
  return 1
}

# ── source file helpers ─────────────────────────────────────────────────────
is_source_file() {
  local file="$1"
  case "${file##*.}" in
    py|js|mjs|cjs|ts|mts|cts|jsx|tsx|java|cs|cpp|cxx|cc|c|h|hpp|hxx|go|rb|rs|kt|kts|swift|sh|bash|zsh|ps1|psm1|sql|r|R|php|ex|exs|erl|hrl|hs|lua|jl|ml|mli|scala|dart)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

count_source_files() {
  local dir="$1"
  local mode="${2:-recursive}"
  if [[ "$mode" == "immediate" ]]; then
    find "$dir" -maxdepth 1 -type f 2>/dev/null | while IFS= read -r file; do
      is_source_file "$file" && echo "$file"
    done | wc -l
  else
    find "$dir" -type f 2>/dev/null | while IFS= read -r file; do
      is_excluded_dir "$(dirname "$file")/" && continue
      is_source_file "$file" && echo "$file"
    done | wc -l
  fi
}

count_child_dirs() {
  local dir="$1"
  find "$dir" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | while IFS= read -r child; do
    is_excluded_dir "$child/" || echo "$child"
  done | wc -l
}

doc_worthy_dir() {
  local dir="$1" root="$2" maturity="${3:-standard}"
  [[ "$dir" == "$root" ]] && return 1
  is_excluded_dir "$dir/" && return 1

  local recursive_sources immediate_sources child_dirs base
  recursive_sources=$(count_source_files "$dir" recursive)
  immediate_sources=$(count_source_files "$dir" immediate)
  child_dirs=$(count_child_dirs "$dir")
  base=$(basename "$dir")

  case "$maturity" in
    minimal)
      return 1
      ;;
    full)
      (( recursive_sources > 0 ))
      ;;
    standard|*)
      (( recursive_sources > 0 )) || return 1
      case "$base" in
        src|source|sources|app|apps|packages|package|pkg|services|service|cmd|bin|api|server|client|lib|libs|core|modules|module|scripts|tools|workers|jobs|pipelines|pipeline)
          return 0
          ;;
      esac
      (( immediate_sources >= 3 || child_dirs >= 2 ))
      ;;
  esac
}

# ── template rendering ──────────────────────────────────────────────────────
render_template() {
  local tmpl="$1" out="$2"; shift 2
  local content
  content=$(cat "$tmpl")
  for pair in "$@"; do
    local key="${pair%%=*}"
    local val="${pair#*=}"
    local escaped_val
    escaped_val=$(printf '%s' "$val" | sed 's/[&/\\]/\\&/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
    content=$(printf '%s' "$content" | sed "s/{{${key}}}/${escaped_val}/g")
  done
  printf '%s\n' "$content" > "$out"
}

file_has_content() {
  local file="$1" min_lines="${2:-3}"
  [[ -f "$file" ]] || return 1
  local count
  count=$(grep -cP '\S' "$file" 2>/dev/null || echo 0)
  (( count >= min_lines ))
}

generate_layout_tree() {
  local dir="$1"
  python3 - "$dir" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
items = sorted(root.iterdir(), key=lambda p: (not p.is_dir(), p.name.lower()))
lines = [f"{root.name}/"]
max_items = 12
for index, item in enumerate(items[:max_items]):
    prefix = "└── " if index == min(len(items), max_items) - 1 else "├── "
    suffix = "/" if item.is_dir() else ""
    lines.append(f"{prefix}{item.name}{suffix}")
if len(items) > max_items:
    lines.append("└── …")
print("\n".join(lines))
PY
}
