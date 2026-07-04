#!/usr/bin/env bash
# init.sh — stamp this template with your project's identity.
# Replaces the scalar {{TOKENS}} across every text file in the repo. The larger
# << ... >> guidance blocks are left for you to fill by hand.
#
#   scripts/init.sh                       # interactive prompts
#   scripts/init.sh --name "Maple" --slug maple --owner "Mehdi" \
#                   --tagline "Tracks a Canada immigration plan"
#   scripts/init.sh --dry-run ...         # show what would change, touch nothing
#
# Safe: operates only on tracked-looking text files, skips .git/ and binaries,
# and refuses to run twice (bails if no {{TOKENS}} remain) unless --force.
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

NAME=""; SLUG=""; OWNER=""; TAGLINE=""; DRY=0; FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --name)    NAME="${2:-}"; shift 2;;
    --slug)    SLUG="${2:-}"; shift 2;;
    --owner)   OWNER="${2:-}"; shift 2;;
    --tagline) TAGLINE="${2:-}"; shift 2;;
    --dry-run) DRY=1; shift;;
    --force)   FORCE=1; shift;;
    -h|--help) sed -n '2,12p' "$0"; exit 0;;
    *) echo "init: unknown arg '$1'"; exit 1;;
  esac
done

ask() { # ask <var> <prompt> <default>
  local cur; eval "cur=\${$1}"
  [ -n "$cur" ] && return 0
  printf "%s" "$2"
  [ -n "$3" ] && printf " [%s]" "$3"
  printf ": "
  local ans; read -r ans || true
  [ -z "$ans" ] && ans="$3"
  eval "$1=\$ans"
}

ask NAME    "Project display name (PROJECT_NAME)" ""
[ -z "$NAME" ] && { echo "init: PROJECT_NAME is required"; exit 1; }
# derive a default slug from the name
def_slug="$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')"
ask SLUG    "Machine slug (PROJECT_SLUG)" "$def_slug"
ask OWNER   "Owner name (OWNER_NAME)" ""
ask TAGLINE "One-line tagline (PROJECT_TAGLINE)" ""

# Some files reference the token literals for documentation/self-reference and
# must never be rewritten: this script (its own sed patterns) and the root
# README.md (its "Using this template" section explains the tokens verbatim).
scan() {
  grep -rIl '{{' . --exclude-dir=.git 2>/dev/null \
    | grep -v -x -e './scripts/init.sh' -e './README.md' || true
}

remaining="$(scan)"
if [ -z "$remaining" ] && [ "$FORCE" -ne 1 ]; then
  echo "init: no {{TOKENS}} found — already initialized? (use --force to re-run)"
  exit 0
fi

echo
echo "Will substitute:"
printf "  {{PROJECT_NAME}}     -> %s\n" "$NAME"
printf "  {{PROJECT_SLUG}}     -> %s\n" "$SLUG"
printf "  {{OWNER_NAME}}       -> %s\n" "${OWNER:-<left blank>}"
printf "  {{PROJECT_TAGLINE}}  -> %s\n" "${TAGLINE:-<left blank>}"
echo

# Collect target files: text files only, skip .git and this script itself.
files="$(scan)"
[ -z "$files" ] && { echo "init: nothing to do."; exit 0; }

# escape for sed replacement (& and / and backslash)
esc() { printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'; }
e_name="$(esc "$NAME")"; e_slug="$(esc "$SLUG")"
e_owner="$(esc "$OWNER")"; e_tag="$(esc "$TAGLINE")"

for f in $files; do
  if [ "$DRY" -eq 1 ]; then
    n="$(grep -c '{{' "$f" 2>/dev/null || echo 0)"
    printf "  would edit %-45s (%s token lines)\n" "$f" "$n"
    continue
  fi
  sed -i \
    -e "s/{{PROJECT_NAME}}/$e_name/g" \
    -e "s/{{PROJECT_SLUG}}/$e_slug/g" \
    -e "s/{{OWNER_NAME}}/$e_owner/g" \
    -e "s/{{PROJECT_TAGLINE}}/$e_tag/g" \
    "$f"
done

if [ "$DRY" -eq 1 ]; then
  echo; echo "init: dry run — no files changed."
  exit 0
fi

# self-note: PROJECT_DESCRIPTION and << >> blocks remain for manual fill.
echo "init: done."
echo "Left for you to fill by hand:"
echo "  - {{PROJECT_DESCRIPTION}} in AGENTS.md"
echo "  - every << ... >> guidance block (AGENTS.md, docs/, .protected-paths)"
echo "  - cp scripts/project.sh.example scripts/project.sh  (define build/test)"
grep -rIl '<<' . --exclude-dir=.git 2>/dev/null | sed 's/^/  still has << >>: /' || true
