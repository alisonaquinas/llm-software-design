#!/usr/bin/env bash
# audit-docs.sh — Audit a repository against the well-documented standard.
#
# Usage: audit-docs.sh [-r ROOT] [--maturity LEVEL] [--check-local-commands]
#                      [--no-check-local-commands] [--git-freshness]
#                      [--no-git-freshness] [-q] [-h]
#   -r ROOT                   Repository root (default: current directory)
#   --maturity LEVEL          minimal, standard, or full (default: standard)
#   --check-local-commands    Verify local script and Make target references (default: on)
#   --no-check-local-commands Skip local command verification
#   --git-freshness           Warn when code changed without docs changes if git is available (default: on)
#   --no-git-freshness        Skip git freshness checks
#   -q                        Quiet — only print FAILs and WARNs; suppress PASSes and SKIPs
#   -h, --help                Show this help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-common.sh
source "$SCRIPT_DIR/lib-common.sh"

ROOT="$(pwd)"
QUIET=false
MATURITY="standard"
CHECK_LOCAL_COMMANDS=true
CHECK_GIT_FRESHNESS=true

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
    --maturity)
      MATURITY="$2"
      shift 2
      ;;
    --check-local-commands)
      CHECK_LOCAL_COMMANDS=true
      shift
      ;;
    --no-check-local-commands)
      CHECK_LOCAL_COMMANDS=false
      shift
      ;;
    --git-freshness)
      CHECK_GIT_FRESHNESS=true
      shift
      ;;
    --no-git-freshness)
      CHECK_GIT_FRESHNESS=false
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
case "$MATURITY" in
  minimal|standard|full) ;;
  *) printf 'invalid maturity: %s\n' "$MATURITY" >&2; exit 2 ;;
esac

emit_pass() { $QUIET || log_pass "$@"; }
emit_warn() { log_warn "$@"; }
emit_fail() { log_fail "$@"; }
emit_skip() { $QUIET || log_skip "$@"; }

markdown_docs() {
  find "$ROOT" -type f \( -name '*.md' -o -name '*.markdown' \) 2>/dev/null | while IFS= read -r file; do
    is_excluded_dir "$(dirname "$file")/" && continue
    echo "$file"
  done | sort
}

check_root() {
  echo "── Root: $ROOT"

  if [[ ! -f "$ROOT/README.md" ]]; then
    emit_fail "R01  README.md (root) — missing"
  else
    emit_pass "R01  README.md (root)"
    if grep -qP '^#\s+\S' "$ROOT/README.md"; then
      emit_pass "R02  README.md title heading"
    else
      emit_warn "R02  README.md (root) — no top-level heading found"
    fi
    if grep -qiP '^#+ .*(install|setup|get started|getting started|quick start)' "$ROOT/README.md"; then
      emit_pass "R03  README.md installation section"
    else
      emit_warn "R03  README.md (root) — no Installation or Setup section"
    fi
    if grep -qiP '^#+ .*(usage|example|examples|quick start|tutorial)' "$ROOT/README.md"; then
      emit_pass "R04  README.md usage section"
    else
      emit_warn "R04  README.md (root) — no Usage or Examples section"
    fi
  fi

  if [[ ! -f "$ROOT/AGENTS.md" ]]; then
    emit_fail "R05  AGENTS.md (root) — missing"
  else
    if grep -qiP '^## (layout|structure|directory|files)' "$ROOT/AGENTS.md" \
      && grep -qiP '^## (common workflows|workflows)' "$ROOT/AGENTS.md" \
      && grep -qiP '^## (invariants|do not violate|rules|constraints)' "$ROOT/AGENTS.md"; then
      emit_pass "R05  AGENTS.md (root)"
    else
      emit_warn "R05  AGENTS.md (root) — missing layout, workflows, or invariants section"
    fi

    local stale_layout=0
    while IFS= read -r token; do
      [[ -z "$token" ]] && continue
      [[ -e "$ROOT/$token" ]] || (( stale_layout++ )) || true
    done < <(grep -oP '`[^`]+`' "$ROOT/AGENTS.md" 2>/dev/null | tr -d '`' | grep -E '(/|\.[A-Za-z0-9]+$)' || true)
    if (( stale_layout > 0 )); then
      emit_warn "R06  AGENTS.md (root) — references $stale_layout path(s) that do not exist"
    else
      emit_pass "R06  AGENTS.md layout references"
    fi

    if grep -qiP '^## (invariants|do not violate|rules|constraints)' "$ROOT/AGENTS.md"; then
      emit_pass "R07  AGENTS.md invariants section"
    else
      emit_warn "R07  AGENTS.md (root) — no Invariants section"
    fi
  fi

  if [[ ! -f "$ROOT/CLAUDE.md" ]]; then
    emit_fail "R08  CLAUDE.md (root) — missing"
  else
    local lines
    lines=$(wc -l < "$ROOT/CLAUDE.md")
    if (( lines > 30 )); then
      emit_warn "R08  CLAUDE.md (root) — too long; should be a short stub or symlink"
    else
      emit_pass "R08  CLAUDE.md (root)"
    fi
  fi

  case "$MATURITY" in
    minimal)
      if [[ -f "$ROOT/CONCEPTS.md" ]]; then
        emit_pass "R09  CONCEPTS.md (root)"
      else
        emit_skip "R09  CONCEPTS.md (root) — optional at minimal maturity"
      fi
      ;;
    standard)
      if [[ -f "$ROOT/CONCEPTS.md" ]]; then
        emit_pass "R09  CONCEPTS.md (root)"
      else
        emit_warn "R09  CONCEPTS.md (root) — recommended at standard maturity when vocabulary is non-obvious"
      fi
      ;;
    full)
      if [[ -f "$ROOT/CONCEPTS.md" ]]; then
        emit_pass "R09  CONCEPTS.md (root)"
      else
        emit_fail "R09  CONCEPTS.md (root) — missing at full maturity"
      fi
      ;;
  esac

  if [[ -f "$ROOT/CONCEPTS.md" ]]; then
    local entries with_refs
    entries=$(grep -cP '^## ' "$ROOT/CONCEPTS.md" || echo 0)
    with_refs=$(grep -cP '^\*\*See also:\*\*' "$ROOT/CONCEPTS.md" || echo 0)
    if (( with_refs >= entries && entries > 0 )); then
      emit_pass "R10  CONCEPTS.md cross-references"
    else
      emit_warn "R10  CONCEPTS.md — some concept entries lack a 'See also' line"
    fi
  else
    emit_skip "R10  CONCEPTS.md cross-references — file absent"
  fi

  if [[ -f "$ROOT/CHANGELOG.md" ]]; then
    if grep -qP '^## \[' "$ROOT/CHANGELOG.md"; then
      emit_pass "R11  CHANGELOG.md"
    else
      emit_warn "R11  CHANGELOG.md — no version entries found"
    fi
  else
    emit_warn "R11  CHANGELOG.md — absent; add it when the project tracks notable releases"
  fi

  if [[ -f "$ROOT/.markdownlint.yaml" || -f "$ROOT/.markdownlint.json" || \
        -f "$ROOT/.markdownlint-cli2.jsonc" || -f "$ROOT/markdownlint-cli2.jsonc" ]]; then
    emit_pass "M01  markdownlint config"
  else
    emit_warn "M01  markdownlint config — none found"
  fi

  check_markdownlint_all
}

check_markdownlint_all() {
  local config_arg=()
  local cfg
  for cfg in "$ROOT/.markdownlint.yaml" "$ROOT/.markdownlint.json" \
             "$ROOT/.markdownlint-cli2.jsonc" "$ROOT/markdownlint-cli2.jsonc"; do
    if [[ -f "$cfg" ]]; then
      config_arg=(--config "$cfg")
      break
    fi
  done

  local tmpout
  tmpout=$(mktemp)

  if command -v markdownlint-cli2 &>/dev/null; then
    if markdownlint-cli2 "${config_arg[@]}" "$ROOT/**/*.md" "$ROOT/**/*.markdown" >"$tmpout" 2>&1; then
      emit_pass "M02  markdownlint — all .md files pass"
    else
      local count
      count=$(grep -cP '\S' "$tmpout" || echo 0)
      emit_fail "M02  markdownlint — $count issue(s); run check-markdownlint.sh for details"
    fi
  else
    emit_skip "M02  markdownlint run — markdownlint-cli2 not installed"
  fi
  rm -f "$tmpout"
}

check_directory() {
  local dir="$1"
  local rel="${dir#"$ROOT/"}"

  if [[ -f "$dir/README.md" ]]; then
    if file_has_content "$dir/README.md" 2; then
      emit_pass "D01  README.md ($rel/)"
    else
      emit_warn "D01  README.md ($rel/) — thin or placeholder-heavy"
    fi
  else
    if [[ "$MATURITY" == "full" ]]; then
      emit_fail "D01  README.md ($rel/) — missing"
    else
      emit_warn "D01  README.md ($rel/) — missing for a doc-worthy directory"
    fi
  fi

  if [[ -f "$dir/AGENTS.md" ]]; then
    if grep -qiP '^## (layout|structure|directory|files)' "$dir/AGENTS.md" \
      && grep -qiP '^## (common workflows|workflows)' "$dir/AGENTS.md" \
      && grep -qiP '^## (invariants|do not violate|rules|constraints)' "$dir/AGENTS.md"; then
      emit_pass "D02  AGENTS.md ($rel/)"
    else
      emit_warn "D02  AGENTS.md ($rel/) — missing layout, workflows, or invariants section"
    fi
    if grep -qP '\.\./.*AGENTS\.md' "$dir/AGENTS.md"; then
      emit_pass "D03  AGENTS.md ($rel/) cross-reference"
    else
      emit_warn "D03  AGENTS.md ($rel/) — no cross-reference to parent AGENTS.md"
    fi
  else
    if [[ "$MATURITY" == "full" ]]; then
      emit_fail "D02  AGENTS.md ($rel/) — missing"
    else
      emit_warn "D02  AGENTS.md ($rel/) — missing for a doc-worthy directory"
    fi
    emit_skip "D03  AGENTS.md ($rel/) cross-reference — file absent"
  fi

  if [[ -f "$dir/CLAUDE.md" ]]; then
    local lines
    lines=$(wc -l < "$dir/CLAUDE.md")
    if (( lines > 20 )); then
      emit_warn "D04  CLAUDE.md ($rel/) — too long; should be a short stub or symlink"
    else
      emit_pass "D04  CLAUDE.md ($rel/)"
    fi
  else
    if [[ "$MATURITY" == "full" ]]; then
      emit_fail "D04  CLAUDE.md ($rel/) — missing"
    else
      emit_warn "D04  CLAUDE.md ($rel/) — optional at standard maturity but useful when Claude reads subdirectory docs"
    fi
  fi
}

walk_directories() {
  while IFS= read -r dir; do
    [[ "$dir" == "$ROOT" ]] && continue
    doc_worthy_dir "$dir" "$ROOT" "$MATURITY" || continue
    check_directory "$dir"
  done < <(find "$ROOT" -type d | sort)
}

check_markdown_links() {
  local out
  out=$(python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1]).resolve()
link_re = re.compile(r'\[[^\]]+\]\(([^)]+)\)')
for doc in sorted(root.rglob('*')):
    if not doc.is_file() or doc.suffix.lower() not in {'.md', '.markdown'}:
        continue
    if any(part in {'node_modules', 'vendor', '.venv', 'venv', '__pycache__', 'dist', 'out', 'build', '.git', '.cache'} for part in doc.parts):
        continue
    text = doc.read_text(encoding='utf-8', errors='ignore')
    for raw_target in link_re.findall(text):
        target = raw_target.strip().split()[0]
        if target.startswith(('#', 'http://', 'https://', 'mailto:', '$')):
            continue
        resolved = (doc.parent / target).resolve()
        if not resolved.exists():
            print(f"{doc.relative_to(root)}::{target}")
PY
)
  if [[ -n "$out" ]]; then
    local first count
    first=$(printf '%s\n' "$out" | head -1)
    count=$(printf '%s\n' "$out" | grep -c . || echo 0)
    emit_fail "E01  markdown links — $count broken link(s); first: $first"
  else
    emit_pass "E01  markdown links resolve"
  fi
}

check_backticked_paths() {
  local out
  out=$(python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1]).resolve()
pattern = re.compile(r'`([^`\n]+)`')
interesting = re.compile(r'(/|\.[A-Za-z0-9]+$)')
for doc in sorted(root.rglob('*')):
    if not doc.is_file() or doc.suffix.lower() not in {'.md', '.markdown'}:
        continue
    if any(part in {'node_modules', 'vendor', '.venv', 'venv', '__pycache__', 'dist', 'out', 'build', '.git', '.cache'} for part in doc.parts):
        continue
    text = doc.read_text(encoding='utf-8', errors='ignore')
    for token in pattern.findall(text):
        token = token.strip()
        if not interesting.search(token):
          continue
        if token.startswith(('$', 'http://', 'https://')):
          continue
        candidates = [(doc.parent / token).resolve(), (root / token).resolve()]
        if not any(candidate.exists() for candidate in candidates):
            print(f"{doc.relative_to(root)}::{token}")
PY
)
  if [[ -n "$out" ]]; then
    local first count
    first=$(printf '%s\n' "$out" | head -1)
    count=$(printf '%s\n' "$out" | grep -c . || echo 0)
    emit_warn "E02  backticked path references — $count unresolved reference(s); first: $first"
  else
    emit_pass "E02  backticked path references"
  fi
}

check_local_commands() {
  local out
  out=$(python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1]).resolve()
make_targets = set()
makefile = root / 'Makefile'
if makefile.exists():
    text = makefile.read_text(encoding='utf-8', errors='ignore')
    for line in text.splitlines():
        m = re.match(r'^([A-Za-z0-9_.-]+):', line)
        if m and not m.group(1).startswith('.'):
            make_targets.add(m.group(1))

fence_re = re.compile(r'```(?:bash|sh|shell|text)?\n(.*?)```', re.DOTALL)
for doc in sorted(root.rglob('*')):
    if not doc.is_file() or doc.suffix.lower() not in {'.md', '.markdown'}:
        continue
    if any(part in {'node_modules', 'vendor', '.venv', 'venv', '__pycache__', 'dist', 'out', 'build', '.git', '.cache'} for part in doc.parts):
        continue
    text = doc.read_text(encoding='utf-8', errors='ignore')
    blocks = fence_re.findall(text)
    for block in blocks:
        for raw in block.splitlines():
            line = raw.strip()
            if not line or line.startswith('#'):
                continue
            if line.startswith('$ '):
                line = line[2:].strip()
            if line.startswith('make '):
                target = line.split()[1]
                if target.startswith('-'):
                    continue
                if target not in make_targets:
                    print(f"{doc.relative_to(root)}::make target '{target}'")
            elif re.match(r'^(python|python3|bash|sh|node)\s+', line):
                parts = line.split()
                if len(parts) < 2:
                    continue
                candidate = parts[1]
                if candidate.startswith('-'):
                    continue
                resolved_doc = (doc.parent / candidate).resolve()
                resolved_root = (root / candidate).resolve()
                if '/' in candidate or candidate.endswith(('.py', '.sh', '.js', '.ts')):
                    if not (resolved_doc.exists() or resolved_root.exists()):
                        print(f"{doc.relative_to(root)}::{parts[0]} {candidate}")
            elif line.startswith('./'):
                candidate = line.split()[0]
                resolved_doc = (doc.parent / candidate).resolve()
                resolved_root = (root / candidate).resolve()
                if not (resolved_doc.exists() or resolved_root.exists()):
                    print(f"{doc.relative_to(root)}::{candidate}")
PY
)
  if [[ -n "$out" ]]; then
    local first count
    first=$(printf '%s\n' "$out" | head -1)
    count=$(printf '%s\n' "$out" | grep -c . || echo 0)
    emit_fail "E03  local command references — $count unresolved command asset(s); first: $first"
  else
    emit_pass "E03  local command references"
  fi
}

check_bootstrap_markers() {
  local count
  count=$( (find "$ROOT" -type f \( -name '*.md' -o -name '*.py' -o -name '*.ts' -o -name '*.js' -o -name '*.sh' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.cs' \) \
    ! -path '*/node_modules/*' ! -path '*/vendor/*' ! -path '*/dist/*' ! -path '*/build/*' ! -path '*/out/*' ! -path '*/.git/*' \
    ! -path '*/assets/templates/*' \
    -exec grep -lE 'BOOTSTRAP HEADER|BOOTSTRAP NOTE|<TODO:' {} + 2>/dev/null || true) | wc -l)
  if (( count > 0 )); then
    emit_warn "E04  bootstrap markers — $count live file(s) still contain bootstrap or strong placeholder text"
  else
    emit_pass "E04  bootstrap markers"
  fi
}

check_git_freshness() {
  if ! $CHECK_GIT_FRESHNESS; then
    emit_skip "F01  git freshness — disabled"
    return
  fi
  if ! git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    emit_skip "F01  git freshness — no git metadata available"
    return
  fi

  local status source_changes doc_changes
  status=$(git -C "$ROOT" status --porcelain)
  if [[ -z "$status" ]]; then
    emit_pass "F01  git freshness"
    return
  fi

  source_changes=$(printf '%s\n' "$status" | awk '{print $2}' | grep -vE '(^|/)(node_modules|vendor|dist|build|out|\.git)/' | grep -vE '\.(md|markdown)$' | grep -c . || true)
  doc_changes=$(printf '%s\n' "$status" | awk '{print $2}' | grep -cE '\.(md|markdown)$' || true)

  if (( source_changes > 0 && doc_changes == 0 )); then
    emit_warn "F01  git freshness — working tree has code changes but no documentation changes"
  else
    emit_pass "F01  git freshness"
  fi
}

check_root
echo ""
echo "── Directories ($MATURITY)"
walk_directories

echo ""
echo "── Evidence"
check_markdown_links
check_backticked_paths
if $CHECK_LOCAL_COMMANDS; then
  check_local_commands
else
  emit_skip "E03  local command references — disabled"
fi
check_bootstrap_markers
check_git_freshness

score_report
(( FAIL_COUNT == 0 ))
