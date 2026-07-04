#!/usr/bin/env bash
# kb.sh — browse and maintain the project's docs & knowledge base.
# Portable bash 3.2 compatible (no associative arrays, no mapfile).
#
# Usage:
#   scripts/kb.sh list                      # index of knowledge entries (front matter)
#   scripts/kb.sh search <terms...>         # case-insensitive search across docs/ + knowledge/
#   scripts/kb.sh show <id>                 # print the entry whose front-matter id matches
#   scripts/kb.sh new <id> "Title" [tags]   # scaffold a learned entry from _TEMPLATE.md
#   scripts/kb.sh verify                    # lint: front matter, index rows, link targets
#
# Exit codes: 0 ok · 1 usage · 2 not found · 3 verify failed

set -u

# Resolve repo root: the directory containing this script's parent.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS="$ROOT/docs"
KB="$DOCS/knowledge"

die() { echo "kb: $*" >&2; exit 1; }
[ -d "$KB" ] || die "knowledge folder not found at $KB"

# fm <file> <key> — extract a scalar from the YAML front matter block.
fm() {
  awk -v key="$2" '
    NR==1 && $0!="---" { exit }        # no front matter
    NR>1 && $0=="---" { exit }         # end of front matter
    NR>1 {
      split($0, kv, ": ")
      if (kv[1]==key) {
        sub("^" key ": *", "", $0)
        sub(/ *#.*$/, "", $0)          # strip inline comments
        sub(/ *$/, "", $0)             # trim trailing spaces
        gsub(/^"|"$/, "", $0)
        print $0; exit
      }
    }' "$1"
}

kb_files() { find "$KB" -maxdepth 1 -name '*.md' ! -name 'README.md' ! -name '_TEMPLATE.md' | sort; }

cmd_list() {
  printf "%-26s %-8s %-7s %-11s %s\n" "ID" "ORIGIN" "STATUS" "VERIFIED" "TITLE"
  printf "%-26s %-8s %-7s %-11s %s\n" "--" "------" "------" "--------" "-----"
  local f id
  for f in $(kb_files); do
    id="$(fm "$f" id)"; [ -n "$id" ] || id="(missing-id)"
    printf "%-26s %-8s %-7s %-11s %s\n" \
      "$id" "$(fm "$f" origin)" "$(fm "$f" status)" "$(fm "$f" verified)" "$(fm "$f" title)"
  done
  echo
  echo "Guideline docs (search these too):"
  find "$DOCS" -maxdepth 1 -name '*.md' | sort | sed "s|$ROOT/|  |"
}

cmd_search() {
  [ $# -ge 1 ] || die "usage: kb.sh search <terms...>"
  local pattern="$*"
  echo "== knowledge/ =="
  grep -RIni --include='*.md' -C 1 -- "$pattern" "$KB" 2>/dev/null | sed "s|$ROOT/||"
  echo
  echo "== docs/ (guidelines & plan) =="
  grep -Ini --include='*.md' -C 1 -- "$pattern" "$DOCS"/*.md 2>/dev/null | sed "s|$ROOT/||"
  echo
  echo "== docs/slices/ + docs/adr/ =="
  grep -RIni --include='*.md' -C 1 -- "$pattern" "$DOCS/slices" "$DOCS/adr" 2>/dev/null | sed "s|$ROOT/||"
  echo
  echo "== root (AGENTS.md, README.md) =="
  grep -Ini -C 1 -- "$pattern" "$ROOT"/AGENTS.md "$ROOT"/README.md 2>/dev/null | sed "s|$ROOT/||"
  return 0
}

cmd_show() {
  [ $# -eq 1 ] || die "usage: kb.sh show <id>"
  local f
  for f in $(kb_files); do
    if [ "$(fm "$f" id)" = "$1" ]; then cat "$f"; return 0; fi
  done
  echo "kb: no entry with id '$1' — try: kb.sh list" >&2
  exit 2
}

cmd_new() {
  [ $# -ge 2 ] || die 'usage: kb.sh new <short-id> "Title" [tag1,tag2]'
  local short="$1" title="$2" tags="${3:-untagged}"
  case "$short" in kb-*) : ;; *) short="kb-$short" ;; esac
  local slug file
  slug="$(echo "$short" | sed 's/^kb-//')"
  file="$KB/$slug.md"
  [ -e "$file" ] && die "$file already exists"
  local today; today="$(date +%Y-%m-%d)"
  local tag_yaml; tag_yaml="$(echo "$tags" | sed 's/,/, /g')"
  sed \
    -e "s/^id: kb-CHANGE-ME/id: $short/" \
    -e "s/^title: .*/title: $title/" \
    -e "s/^tags: .*/tags: [$tag_yaml]/" \
    -e "s/^verified: .*/verified: $today/" \
    "$KB/_TEMPLATE.md" > "$file"
  echo "created $file"
  echo "NEXT: fill it in, add a routing-table row to docs/knowledge/README.md, run kb.sh verify"
}

cmd_verify() {
  local fail=0 f id
  # 1) every entry has complete front matter
  for f in $(kb_files); do
    for key in id title tags origin status verified; do
      if [ -z "$(fm "$f" "$key")" ]; then
        echo "FAIL front-matter: $(basename "$f") missing '$key'"; fail=1
      fi
    done
    id="$(fm "$f" id)"
    # 2) every entry id appears in the README index
    if [ -n "$id" ] && ! grep -q "$id" "$KB/README.md"; then
      echo "FAIL index: $id ($(basename "$f")) not referenced in knowledge/README.md"; fail=1
    fi
    # 3) status sanity
    case "$(fm "$f" status)" in active|watch|superseded) : ;; *)
      echo "FAIL status: $(basename "$f") has invalid status '$(fm "$f" status)'"; fail=1 ;;
    esac
  done
  # 4) every file referenced in the README routing table exists
  grep -o '`[a-z0-9_-]*\.md`' "$KB/README.md" | tr -d '\`' | sort -u | while read -r ref; do
    [ -e "$KB/$ref" ] || { echo "FAIL link: README references missing file $ref"; echo BROKEN > "$KB/.verify_fail"; }
  done
  if [ -e "$KB/.verify_fail" ]; then rm -f "$KB/.verify_fail"; fail=1; fi
  # 5) duplicate ids
  for f in $(kb_files); do fm "$f" id; done | sort | uniq -d | while read -r dup; do
    [ -n "$dup" ] && { echo "FAIL duplicate id: $dup"; echo BROKEN > "$KB/.verify_fail"; }
  done
  if [ -e "$KB/.verify_fail" ]; then rm -f "$KB/.verify_fail"; fail=1; fi
  if [ "$fail" -eq 0 ]; then echo "kb verify: OK ($(kb_files | wc -l | tr -d ' ') entries)"; return 0
  else echo "kb verify: FAILED"; return 3; fi
}

case "${1:-}" in
  list)   shift; cmd_list "$@";;
  search) shift; cmd_search "$@";;
  show)   shift; cmd_show "$@";;
  new)    shift; cmd_new "$@";;
  verify) shift; cmd_verify "$@";;
  *) sed -n '2,12p' "$0"; exit 1;;
esac
