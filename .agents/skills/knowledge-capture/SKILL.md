---
name: knowledge-capture
description: Record newly discovered facts, pitfalls, workarounds, or verified external information into docs/knowledge/ so future sessions don't re-derive them. Use at the moment of discovery — after a surprising build/test failure is diagnosed, an undocumented behavior is confirmed, an approach is abandoned for cause, or an external fact is verified. Also use when promoting or superseding an existing entry.
---

# Knowledge Capture

"If it cost you more than ten minutes to learn and isn't in the repo, write it
down." Capture happens in the same work session as the discovery — never
"later".

## Capture-worthy (any one suffices)

- A platform behavior that contradicted reasonable expectations (with the
  error text as evidence).
- A workaround whose absence would send the next agent down the same hole.
- A rejected approach + WHY (negative knowledge prevents repeat spikes).
- A verified change to an external fact (`status: watch` entries especially).
- A recurring command/recipe you had to reconstruct.

NOT capture-worthy: secrets, personal data, authoritative constants (their
single-source file only), anything already in a guideline, one-off trivia.

## Procedure

```bash
scripts/kb.sh search <topic>                    # 1. avoid duplicates
scripts/kb.sh new <short-id> "Title" tag1,tag2  # 2. scaffold (origin: learned)
$EDITOR docs/knowledge/<short-id>.md            # 3. fill all four sections
```

4. Add a routing-table row in `docs/knowledge/README.md` (an unindexed entry
   fails verify by design).
5. `scripts/kb.sh verify` → must print OK.
6. Commit: `docs(knowledge): add kb-<short-id>` (COMMIT_GUIDELINES applies;
   knowledge changes ride with the slice commit only if discovered in-slice —
   otherwise standalone).

## Quality bar

- ≤ ~80 lines; conclusion first; evidence is concrete (paste the exact error
  line, name the failing test, link the doc).
- "Boundaries" section states what would invalidate the entry — that's what
  makes `status: watch` meaningful.
- Updating an existing entry beats adding a near-duplicate; superseding sets
  `status: superseded` + `supersedes:` on the OLD entry pointing forward.
