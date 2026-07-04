#!/usr/bin/env bash
# setup.sh — one-time environment bootstrap for humans and agents.
# Safe to re-run (idempotent). Prints a capability report at the end.
set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"; ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"; cd "$ROOT"

echo "== {{PROJECT_NAME}} setup =="
chmod +x scripts/*.sh .githooks/* 2>/dev/null

if git rev-parse --git-dir >/dev/null 2>&1; then
  git config core.hooksPath .githooks
  echo "git hooks: core.hooksPath -> .githooks (protected-paths guard active)"
else
  echo "git hooks: SKIPPED (run 'git init' first, then re-run setup.sh)"
fi

# Pull the project's required-tool list from project.sh if present.
REQUIRED="git"
if [ -f scripts/project.sh ]; then
  # shellcheck disable=SC1091
  . scripts/project.sh
  REQUIRED="${PROJECT_REQUIRED_TOOLS:-git}"
fi

echo
echo "== Capability report =="
echo "OS:        $(uname -s)"
if [ ! -f scripts/project.sh ]; then
  echo "project:   scripts/project.sh NOT found — build/test will SKIP in check.sh."
  echo "           Copy scripts/project.sh.example -> scripts/project.sh and fill it in."
fi
for tool in $REQUIRED; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf "%-12s %s\n" "$tool:" "$(command -v "$tool")"
  else
    printf "%-12s MISSING\n" "$tool:"
  fi
done
echo
echo "Verify anytime with: scripts/check.sh"
