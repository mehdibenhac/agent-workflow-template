#!/usr/bin/env bash
# guard.sh — mechanical protected-paths enforcement.
# Runs as the pre-commit hook (via .githooks/) and inside scripts/check.sh.
# Provider-agnostic by design: it doesn't matter WHICH agent (or human) made
# the edit — the gate is git-level, not tool-level.
#
# Modes:
#   scripts/guard.sh staged     # check files staged for commit (hook mode)
#   scripts/guard.sh tree       # check working tree vs HEAD (check.sh mode)
#
# Owner-approved override (see COMMIT_GUIDELINES.md §4):
#   ALLOW_PROTECTED=1 git commit -m "rules(...): ..."
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LIST="$ROOT/.protected-paths"

[ -f "$LIST" ] || { echo "guard: .protected-paths missing"; exit 1; }

mode="${1:-staged}"
case "$mode" in
  staged) changed="$(git -C "$ROOT" diff --cached --name-only 2>/dev/null)";;
  tree)   changed="$(git -C "$ROOT" diff HEAD --name-only 2>/dev/null)";;
  *) echo "guard: unknown mode '$mode' (use: staged|tree)"; exit 1;;
esac

# Not a git repo yet (pre-Slice-0 scaffold) — nothing to guard.
git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1 || { echo "guard: no git repo — skipped"; exit 0; }
[ -n "$changed" ] || { echo "guard: no changes to inspect — OK"; exit 0; }

violations=""
while IFS= read -r pattern; do
  case "$pattern" in ''|\#*) continue;; esac
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    case "$file" in
      $pattern) violations="$violations  $file (matches: $pattern)\n";;
    esac
  done <<EOF_FILES
$changed
EOF_FILES
done < "$LIST"

if [ -n "$violations" ]; then
  if [ "${ALLOW_PROTECTED:-0}" = "1" ]; then
    echo "guard: protected paths modified — ALLOWED via ALLOW_PROTECTED=1:"
    printf "%b" "$violations"
    exit 0
  fi
  echo "guard: BLOCKED — protected paths modified without owner approval:"
  printf "%b" "$violations"
  echo "These files require owner sign-off (AGENTS.md escalation)."
  echo "If approved: ALLOW_PROTECTED=1 git commit ... with the proper"
  echo "commit type (see docs/COMMIT_GUIDELINES.md §4)."
  exit 2
fi
echo "guard: OK"
exit 0
