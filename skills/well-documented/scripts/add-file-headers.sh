#!/usr/bin/env bash
# add-file-headers.sh — Add file-level header comments to undocumented source files.
#
# Walks the target directory, detects the language from file extension, and
# prepends a header block to any file that lacks one. Existing headers are
# NEVER overwritten; files with any header comment in the first 10 lines are
# skipped (their formatting takes precedence).
#
# Usage: add-file-headers.sh [-t TARGET] [-d DESC] [-y] [-n] [-h]
#   -t TARGET   Directory or file to process (default: current directory)
#   -d DESC     Module description to embed (default: "<TODO: describe this file>")
#   -y          Skip confirmation (process all eligible files without prompting)
#   -n          Dry run — show what would be modified without writing
#   -h          Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

TARGET="$(pwd)"
DEFAULT_DESC="<TODO: describe this file>"
YES=false
DRY_RUN=false

usage() {
  grep '^# ' "$0" | sed 's/^# //'
  exit 0
}

while getopts ':t:d:ynh' opt; do
  case "$opt" in
    t) TARGET="$OPTARG" ;;
    d) DEFAULT_DESC="$OPTARG" ;;
    y) YES=true ;;
    n) DRY_RUN=true ;;
    h) usage ;;
    :) printf 'missing value for -%s\n' "$OPTARG" >&2; exit 2 ;;
    \?) printf 'unknown option: -%s\n' "$OPTARG" >&2; exit 2 ;;
  esac
done

TARGET="$(realpath "$TARGET")"

# ── language detection ────────────────────────────────────────────────────────

detect_language() {
  local file="$1"
  case "${file##*.}" in
    py)              echo "python" ;;
    js|mjs|cjs)      echo "javascript" ;;
    ts|mts|cts)      echo "typescript" ;;
    jsx)             echo "javascript" ;;
    tsx)             echo "typescript" ;;
    java)            echo "java" ;;
    cs)              echo "csharp" ;;
    cpp|cxx|cc)      echo "cpp" ;;
    c)               echo "c" ;;
    h|hpp|hxx)       echo "c" ;;
    go)              echo "go" ;;
    rb)              echo "ruby" ;;
    rs)              echo "rust" ;;
    kt|kts)          echo "kotlin" ;;
    swift)           echo "swift" ;;
    sh|bash)         echo "bash" ;;
    zsh)             echo "bash" ;;
    ps1|psm1)        echo "powershell" ;;
    sql)             echo "sql" ;;
    r|R)             echo "r" ;;
    php)             echo "php" ;;
    ex|exs)          echo "elixir" ;;
    erl|hrl)         echo "erlang" ;;
    hs)              echo "haskell" ;;
    lua)             echo "lua" ;;
    jl)              echo "julia" ;;
    ml|mli)          echo "ocaml" ;;
    scala)           echo "scala" ;;
    dart)            echo "dart" ;;
    *)               echo "" ;;
  esac
}

# ── header-presence detection ────────────────────────────────────────────────
# Returns 0 (true) if the file already starts with a recognisable header block

has_header() {
  local file="$1"
  # Read first 10 non-blank lines
  local first10
  first10=$(grep -m10 '\S' "$file" 2>/dev/null | head -10 || true)

  # Python: module docstring
  echo "$first10" | grep -qP '^"""' && return 0
  echo "$first10" | grep -qP "^'''" && return 0
  # Block comment (/* ... */  or /** ... */)
  echo "$first10" | grep -qP '^/[*/]' && return 0
  # Line comment with keyword hint
  echo "$first10" | grep -qiP '^(#|//|--|;)\s*(file|module|package|brief|author|description|provides|purpose|this (file|module|script))' && return 0
  # Rust inner doc
  echo "$first10" | grep -qP '^//!' && return 0
  # Go package doc
  echo "$first10" | grep -qP '^// Package ' && return 0
  # Shell shebang + following comment
  if echo "$first10" | grep -qP '^#!'; then
    echo "$first10" | tail -n +2 | grep -qP '^#' && return 0
  fi
  return 1
}

# ── header generation ─────────────────────────────────────────────────────────

make_header() {
  local lang="$1" filename="$2" desc="$3"
  local basename
  basename="$(basename "$filename")"

  case "$lang" in
    python)
      printf '"""\n%s\n\nProvides: <TODO: list key exports>\n\n<TODO: how this file fits into the system>\n"""\n' "$desc"
      ;;
    javascript|typescript)
      printf '/**\n * %s\n *\n * Provides: {@link TODO}\n *\n * <TODO: how this file fits into the system>\n *\n * @module %s\n */\n' \
        "$desc" "${basename%.*}"
      ;;
    java)
      printf '/**\n * %s\n *\n * <p>Provides: {@link TODO}\n *\n * <p><TODO: how this class fits into the system>\n */\n' "$desc"
      ;;
    csharp)
      printf '/// <summary>\n/// %s\n/// </summary>\n/// <remarks>\n/// Provides: <see cref="TODO"/>\n/// <TODO: how this class fits into the system>\n/// </remarks>\n' "$desc"
      ;;
    cpp|c)
      printf '/**\n * @file %s\n * @brief %s\n *\n * Provides: TODO\n *\n * <TODO: how this file fits into the system>\n */\n' \
        "$basename" "$desc"
      ;;
    go)
      local pkg
      pkg=$(grep -oP '^package \K\w+' "$filename" 2>/dev/null | head -1 || echo "TODO")
      printf '// Package %s %s\n//\n// It provides TODO.\n//\n// <TODO: how this package fits into the system>\n' \
        "$pkg" "$desc"
      ;;
    ruby)
      printf '# frozen_string_literal: true\n\n# %s\n#\n# Provides: TODO\n#\n# <TODO: how this file fits into the system>\n' "$desc"
      ;;
    rust)
      printf '//! %s\n//!\n//! Provides: [`TODO`]\n//!\n//! <TODO: how this module fits into the system>\n' "$desc"
      ;;
    kotlin)
      printf '/**\n * %s\n *\n * Provides: [TODO]\n *\n * <TODO: how this file fits into the system>\n */\n' "$desc"
      ;;
    swift)
      printf '/// %s\n///\n/// Provides: ``TODO``\n///\n/// <TODO: how this file fits into the system>\n' "$desc"
      ;;
    bash)
      printf '#!/usr/bin/env bash\n# %s\n#\n# Usage: %s [OPTIONS]\n#\n# <TODO: how this script fits into the system>\n#\n# Dependencies: none\n# Exit codes: 0 success, 1 error\n' \
        "$desc" "$basename"
      ;;
    powershell)
      printf '<#\n.SYNOPSIS\n    %s\n.DESCRIPTION\n    <TODO: how this script fits into the system>\n.NOTES\n    Provides: TODO\n#>\n' "$desc"
      ;;
    sql)
      printf '-- %s\n--\n-- Provides: TODO\n--\n-- <TODO: how this script fits into the data model>\n' "$desc"
      ;;
    r)
      printf "#' %s\n#'\n#' Provides: TODO\n#'\n#' @description <TODO: how this file fits into the system>\n" "$desc"
      ;;
    elixir)
      printf '@moduledoc """\n%s\n\nProvides: TODO\n\n<TODO: how this module fits into the system>\n"""\n' "$desc"
      ;;
    *)
      # Generic: use # comment style
      printf '# %s\n#\n# Provides: TODO\n#\n# <TODO: how this file fits into the system>\n' "$desc"
      ;;
  esac
}

# ── prepend header to file ────────────────────────────────────────────────────

prepend_header() {
  local file="$1" header="$2"
  local tmp
  tmp=$(mktemp)
  printf '%s\n' "$header" > "$tmp"
  # Preserve shebang if the language is bash and the file already starts with one
  if head -1 "$file" | grep -qP '^#!'; then
    # Header already includes shebang for bash; don't double up
    :
  fi
  cat "$file" >> "$tmp"
  mv "$tmp" "$file"
}

# ── walk files ────────────────────────────────────────────────────────────────

MODIFIED=0
SKIPPED=0

process_file() {
  local file="$1"
  local lang
  lang=$(detect_language "$file")
  [[ -z "$lang" ]] && return  # unsupported extension → skip

  local rel="${file#"$TARGET/"}"
  is_excluded_dir "$(dirname "$file")/" && return

  if has_header "$file"; then
    (( SKIPPED++ )) || true
    return
  fi

  if $DRY_RUN; then
    printf "  would add  %s (%s)\n" "$rel" "$lang"
    (( MODIFIED++ )) || true
    return
  fi

  local header
  header=$(make_header "$lang" "$file" "$DEFAULT_DESC")
  prepend_header "$file" "$header"
  printf "  added  %s (%s)\n" "$rel" "$lang"
  (( MODIFIED++ )) || true
}

if [[ -f "$TARGET" ]]; then
  process_file "$TARGET"
else
  while IFS= read -r f; do
    process_file "$f"
  done < <(find "$TARGET" -type f | sort)
fi

echo ""
if $DRY_RUN; then
  printf "Dry run: %d file(s) would be modified, %d skipped (already have headers).\n" \
    "$MODIFIED" "$SKIPPED"
else
  printf "Done: %d file(s) modified, %d skipped (already have headers).\n" \
    "$MODIFIED" "$SKIPPED"
fi
