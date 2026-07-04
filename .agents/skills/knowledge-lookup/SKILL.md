---
name: knowledge-lookup
description: Find authoritative answers inside this repo before writing code or searching the web. Use whenever you need a platform fact, a domain fact, or a project rule — and ALWAYS before re-deriving something that smells previously solved.
---

# Knowledge Lookup

This repo has three tiers of written truth. Consult them in this order:

1. **Rules** — `AGENTS.md` + `docs/*.md` guidelines (what you MUST do).
2. **Knowledge** — `docs/knowledge/*.md` (what is TRUE and HOW to do it well).
3. **Constants** — the project's single-source-of-truth file, if any (the ONLY
   source of authoritative numbers; knowledge explains, never defines).

## Fast path

```bash
scripts/kb.sh list                 # scan the index (id, status, title)
scripts/kb.sh search <terms>       # grep docs/ + knowledge/ + AGENTS.md
scripts/kb.sh show <id>            # print one entry, e.g. kb-agent-portability
```

Or read `docs/knowledge/README.md` — its routing table maps
"I need to know about X" → file. If the routing table doesn't have it,
`kb.sh search` across everything before concluding it's unknown.

## Interpretation rules

- `status: watch` → true at `verified` date but volatile; re-verify against
  the primary source before building on it, and bump `verified` if confirmed.
- `status: superseded` → follow the `supersedes` pointer; do not apply.
- Knowledge vs authoritative-constants conflict → the constants file wins;
  fixing the entry is part of your current task.
- Found nothing anywhere → the answer may genuinely be new; solve it, then
  invoke the `knowledge-capture` skill so the next agent doesn't repeat the
  work.

## When NOT to use

Don't consult knowledge for things the compiler/toolchain answers faster
(syntax, signatures) or that the implementation plan states explicitly for your
current slice — the plan is the task list, knowledge is the background.
