#!/usr/bin/env bash
# check.sh — THE verification gate. One command any agent (or human) runs to
# prove the repo is healthy. Degrades gracefully by project stage: sections
# that can't run yet (no git repo, no project config, tool missing) are SKIPPED
# loudly, never silently.
#
#   scripts/check.sh          # everything available
#   scripts/check.sh --fast   # skip slow / UI tests (inner loop)
#
# The knowledge-base, protected-paths, and ADR-hygiene sections are project-
# agnostic and always run. The lint / build / test sections are defined by your project in
# scripts/project.sh (copy scripts/project.sh.example). If that file is absent,
# those sections SKIP loudly — so a fresh template is green but honest.
#
# Exit non-zero on ANY failure. Green here == "done" per CONTRIBUTING.md.
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

FAST=0; [ "${1:-}" = "--fast" ] && FAST=1
fail=0
section() { printf '\n== %s ==\n' "$1"; }
result()  { if [ "$1" -eq 0 ]; then echo "-- OK"; else echo "-- FAIL"; fail=1; fi }
skip()    { echo "-- SKIPPED ($1)"; }

# Load project hooks if present. project.sh may define any of:
#   project_lint  project_generate  project_build  project_test
# Each returns 0 on success, non-zero on failure. Undefined = SKIP.
HAVE_PROJECT=0
if [ -f scripts/project.sh ]; then
  # shellcheck disable=SC1091
  . scripts/project.sh
  HAVE_PROJECT=1
fi
defined() { command -v "$1" >/dev/null 2>&1 || type "$1" >/dev/null 2>&1; }

# Light ADR hygiene: numbered filename, a Status: line, and an index reference.
check_adrs() {
  local dir="docs/adr" idx="docs/adr/README.md" f base n bad=0
  [ -d "$dir" ] || { echo "-- SKIPPED (no docs/adr)"; return 0; }
  for f in "$dir"/*.md; do
    base="$(basename "$f")"
    case "$base" in README.md|0000-template.md) continue;; esac
    case "$base" in
      [0-9][0-9][0-9][0-9]-*.md) : ;;
      *) echo "   bad name: $base (want NNNN-title.md)"; bad=1; continue;;
    esac
    grep -Eqi '^(- \*\*status:\*\*|status:)' "$f" || { echo "   $base: missing Status line"; bad=1; }
    n="${base%%-*}"
    [ -f "$idx" ] && ! grep -q "$n" "$idx" && { echo "   $base: not in adr/README.md index"; bad=1; }
  done
  return $bad
}

# Light slice hygiene: numbered filename, a slice: front-matter field, and an
# index reference. Slices live one-per-file in docs/slices/ (like docs/adr/).
check_slices() {
  local dir="docs/slices" idx="docs/slices/README.md" f base n bad=0
  [ -d "$dir" ] || { echo "-- SKIPPED (no docs/slices — phased plan, or not yet created)"; return 0; }
  for f in "$dir"/*.md; do
    base="$(basename "$f")"
    case "$base" in README.md|_TEMPLATE.md) continue;; esac
    case "$base" in
      [0-9][0-9][0-9][0-9]-*.md) : ;;
      *) echo "   bad name: $base (want NNNN-slug.md)"; bad=1; continue;;
    esac
    grep -Eq '^slice:[[:space:]]*[0-9]+' "$f" || { echo "   $base: missing 'slice:' front matter"; bad=1; }
    n="${base%%-*}"
    [ -f "$idx" ] && ! grep -q "$n" "$idx" && { echo "   $base: not in slices/README.md index"; bad=1; }
  done
  return $bad
}

section "1/7 Knowledge base (kb.sh verify)"
bash scripts/kb.sh verify; result $?

section "2/7 Protected paths (guard.sh tree)"
bash scripts/guard.sh tree; result $?

section "3/7 ADR hygiene (numbered, Status:, indexed)"
check_adrs; result $?

section "4/7 Slice hygiene (numbered, slice: front matter, indexed)"
check_slices; result $?

section "5/7 Lint (project_lint)"
if [ "$HAVE_PROJECT" -eq 1 ] && defined project_lint; then
  project_lint; result $?
else
  skip "no scripts/project.sh or project_lint not defined"
fi

section "6/7 Project generation (project_generate)"
if [ "$HAVE_PROJECT" -eq 1 ] && defined project_generate; then
  project_generate; result $?
else
  skip "no scripts/project.sh or project_generate not defined"
fi

section "7/7 Build & tests (project_build + project_test)"
if [ "$HAVE_PROJECT" -eq 1 ] && defined project_test; then
  if defined project_build; then project_build; result $?; fi
  FAST="$FAST" project_test; result $?
else
  skip "no scripts/project.sh or project_test not defined"
fi

printf '\n================================\n'
if [ "$fail" -eq 0 ]; then
  echo "check.sh: ALL GREEN"
  [ "$HAVE_PROJECT" -eq 0 ] && echo "(note: project build/test not configured — see scripts/project.sh.example)"
  exit 0
else
  echo "check.sh: FAILED — do not mark work done, do not tag slices."
  exit 1
fi
