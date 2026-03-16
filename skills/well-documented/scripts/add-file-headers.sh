#!/usr/bin/env bash
# add-file-headers.sh — Add bootstrap file-level header comments to undocumented source files.
#
# Usage: add-file-headers.sh [-t TARGET] [-d DESC] [-y] [-n] [-h]
#   -t TARGET   Directory or file to process (default: current directory)
#   -d DESC     Description to seed the header (default: "Describe this file")
#   -y          Skip confirmation prompt
#   -n          Dry run — show what would be modified without writing
#   -h          Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

TARGET="$(pwd)"
DEFAULT_DESC="Describe this file."
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

if [[ -d "$TARGET" && "$YES" == false && "$DRY_RUN" == false ]]; then
  printf 'Add bootstrap headers under %s? [y/N] ' "$TARGET"
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo 'Aborted.'; exit 0; }
fi

detect_language() {
  local file="$1"
  case "${file##*.}" in
    py) echo python ;;
    js|mjs|cjs|jsx) echo javascript ;;
    ts|mts|cts|tsx) echo typescript ;;
    java) echo java ;;
    cs) echo csharp ;;
    cpp|cxx|cc) echo cpp ;;
    c|h|hpp|hxx) echo c ;;
    go) echo go ;;
    rb) echo ruby ;;
    rs) echo rust ;;
    kt|kts) echo kotlin ;;
    swift) echo swift ;;
    sh|bash|zsh) echo bash ;;
    ps1|psm1) echo powershell ;;
    sql) echo sql ;;
    r|R) echo r ;;
    php) echo php ;;
    ex|exs) echo elixir ;;
    *) echo '' ;;
  esac
}

has_header() {
  local file="$1"
  local first_lines
  first_lines=$(grep -m20 '\S' "$file" 2>/dev/null | head -20 || true)
  echo "$first_lines" | grep -q '^"""' && return 0
  echo "$first_lines" | grep -q "^'''" && return 0
  echo "$first_lines" | grep -qP '^/[*/]|^//!|^// Package ' && return 0
  echo "$first_lines" | grep -qiP '^(#|//|--|;|///)\s*(BOOTSTRAP HEADER|purpose:|provides:|role in system:|@file|@brief|summary)' && return 0
  if echo "$first_lines" | grep -qP '^#!'; then
    echo "$first_lines" | tail -n +2 | grep -qP '^(#|//|///)' && return 0
  fi
  return 1
}

is_generated_like_file() {
  local file="$1"
  [[ "$file" == *'.min.js' || "$file" == *'.min.css' || "$file" == *'.designer.cs' || "$file" == *'/generated/'* ]]
}

make_header() {
  local lang="$1" filename="$2" desc="$3"
  local basename pkg
  basename="$(basename "$filename")"
  case "$lang" in
    python)
      cat <<PY
"""
BOOTSTRAP HEADER: refine before merge.

Purpose: $desc

Provides: <list key exports>

Role in system: <describe how this file fits into the system>
"""
PY
      ;;
    javascript|typescript)
      cat <<TS
/**
 * BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: $desc
 *
 * Provides: {@link TODO}
 *
 * Role in system: <describe how this file fits into the system>
 *
 * @module ${basename%.*}
 */
TS
      ;;
    java)
      cat <<JAVA
/**
 * BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: $desc
 *
 * <p>Provides: {@link TODO}
 *
 * <p>Role in system: <describe how this file fits into the system>
 */
JAVA
      ;;
    csharp)
      cat <<CS
/// <summary>
/// BOOTSTRAP HEADER: refine before merge.
/// </summary>
/// <remarks>
/// Purpose: $desc
/// Provides: <see cref="TODO"/>
/// Role in system: <describe how this file fits into the system>
/// </remarks>
CS
      ;;
    cpp|c)
      cat <<CXX
/**
 * @file $basename
 * @brief BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: $desc
 *
 * Provides: TODO
 *
 * Role in system: <describe how this file fits into the system>
 */
CXX
      ;;
    go)
      pkg=$(grep -oP '^package\s+\K\w+' "$filename" 2>/dev/null | head -1 || true)
      [[ -z "$pkg" ]] && pkg=TODO
      cat <<GO
// Package $pkg BOOTSTRAP HEADER: refine before merge.
//
// Purpose: $desc
//
// Provides: TODO
//
// Role in system: <describe how this file fits into the system>
GO
      ;;
    ruby)
      cat <<RUBY
# frozen_string_literal: true
#
# BOOTSTRAP HEADER: refine before merge.
#
# Purpose: $desc
#
# Provides: TODO
#
# Role in system: <describe how this file fits into the system>
RUBY
      ;;
    rust)
      cat <<RUST
//! BOOTSTRAP HEADER: refine before merge.
//!
//! Purpose: $desc
//!
//! Provides: [TODO]
//!
//! Role in system: <describe how this file fits into the system>
RUST
      ;;
    kotlin)
      cat <<KOTLIN
/**
 * BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: $desc
 *
 * Provides: [TODO]
 *
 * Role in system: <describe how this file fits into the system>
 */
KOTLIN
      ;;
    swift)
      cat <<SWIFT
/// BOOTSTRAP HEADER: refine before merge.
///
/// Purpose: $desc
///
/// Provides: TODO
///
/// Role in system: <describe how this file fits into the system>
SWIFT
      ;;
    bash)
      cat <<BASH
# BOOTSTRAP HEADER: refine before merge.
#
# Purpose: $desc
#
# Provides: TODO
#
# Role in system: <describe how this file fits into the system>
BASH
      ;;
    powershell)
      cat <<POWERSHELL
<#
.SYNOPSIS
    BOOTSTRAP HEADER: refine before merge.
.DESCRIPTION
    Purpose: $desc
.NOTES
    Provides: TODO
    Role in system: <describe how this file fits into the system>
#>
POWERSHELL
      ;;
    sql)
      cat <<SQL
-- BOOTSTRAP HEADER: refine before merge.
--
-- Purpose: $desc
--
-- Provides: TODO
--
-- Role in system: <describe how this file fits into the data model>
SQL
      ;;
    r)
      cat <<R
#' BOOTSTRAP HEADER: refine before merge.
#'
#' Purpose: $desc
#'
#' Provides: TODO
#'
#' @description <describe how this file fits into the system>
R
      ;;
    elixir)
      cat <<ELIXIR
@moduledoc """
BOOTSTRAP HEADER: refine before merge.

Purpose: $desc

Provides: TODO

Role in system: <describe how this module fits into the system>
"""
ELIXIR
      ;;
    *)
      cat <<GENERIC
# BOOTSTRAP HEADER: refine before merge.
#
# Purpose: $desc
#
# Provides: TODO
#
# Role in system: <describe how this file fits into the system>
GENERIC
      ;;
  esac
}

prepend_header() {
  local file="$1" header="$2" lang="$3"
  local tmp
  tmp=$(mktemp)
  if head -1 "$file" | grep -qP '^#!'; then
    head -1 "$file" > "$tmp"
    printf '\n%s\n' "$header" >> "$tmp"
    tail -n +2 "$file" >> "$tmp"
  else
    if [[ "$lang" == "bash" ]]; then
      printf '#!/usr/bin/env bash\n\n%s\n' "$header" > "$tmp"
      cat "$file" >> "$tmp"
    else
      printf '%s\n' "$header" > "$tmp"
      cat "$file" >> "$tmp"
    fi
  fi
  mv "$tmp" "$file"
}

MODIFIED=0
SKIPPED=0

process_file() {
  local file="$1" lang rel header
  lang=$(detect_language "$file")
  [[ -z "$lang" ]] && return
  is_excluded_dir "$(dirname "$file")/" && return
  is_generated_like_file "$file" && return

  if has_header "$file"; then
    (( SKIPPED++ )) || true
    return
  fi

  rel="${file#"$TARGET/"}"
  [[ "$file" == "$TARGET" ]] && rel="$(basename "$file")"

  if $DRY_RUN; then
    printf '  would add  %s (%s)\n' "$rel" "$lang"
    (( MODIFIED++ )) || true
    return
  fi

  header=$(make_header "$lang" "$file" "$DEFAULT_DESC")
  prepend_header "$file" "$header" "$lang"
  printf '  added  %s (%s)\n' "$rel" "$lang"
  (( MODIFIED++ )) || true
}

if [[ -f "$TARGET" ]]; then
  process_file "$TARGET"
else
  while IFS= read -r file; do
    process_file "$file"
  done < <(find "$TARGET" -type f | sort)
fi

echo ""
if $DRY_RUN; then
  printf 'Dry run: %d file(s) would be modified, %d skipped.\n' "$MODIFIED" "$SKIPPED"
else
  printf 'Done: %d file(s) modified, %d skipped.\n' "$MODIFIED" "$SKIPPED"
fi
