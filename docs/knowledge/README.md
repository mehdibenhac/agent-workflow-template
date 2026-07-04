# Knowledge Base — Index

This folder is the project's long-term memory. It holds two kinds of entries in
one flat structure:

- **Seeded knowledge** (`origin: seeded`) — pre-researched facts, patterns, and
  pitfalls baked in before development started.
- **Learned knowledge** (`origin: learned`) — anything discovered *during*
  development worth keeping: a workaround, a surprising API behavior, a
  performance fix, a decision rationale that doesn't fit anywhere else.

**Rules vs. knowledge:** the `docs/*.md` guidelines say what you *must* do;
knowledge entries say what is *true* and *how* to do things well. When a
knowledge entry hardens into a rule, promote it to the relevant guideline and
leave the entry in place with a pointer.

## How to find things

1. Scan the **routing table** below — it maps questions to files.
2. Or run the helper: `scripts/kb.sh search <terms>` (searches docs/ and
   knowledge/), `scripts/kb.sh list` (index from front matter),
   `scripts/kb.sh show <id>`.
3. Every file starts with YAML front matter (`id`, `title`, `tags`, `origin`,
   `status`, `verified`) — scripts and agents key off it.

## Routing table — "I need to know…"

<< This starts nearly empty by design. Add one row per knowledge file. The only
seeded entry shipped with the template is agent-portability. Delete this note
once you have a few real rows. >>

| …about | Read | id |
|---|---|---|
| Which agent tools read which files; mechanical guardrails; the check.sh gate | `agent-portability.md` | `kb-agent-portability` |
| How to add a new knowledge entry | `_TEMPLATE.md` | — |
| << e.g. your persistence/sync rules >> | << your-file.md >> | << kb-... >> |

## Statuses

| status | meaning |
|---|---|
| `active` | Current and trusted. |
| `watch` | True today, likely to change (beta, announced deprecation). Re-verify before relying. |
| `superseded` | Kept for history; front matter names the replacement. |

## Adding knowledge (agents: this is part of your job)

When you discover something non-obvious during a slice — a platform quirk, a
failed approach worth not repeating, a verified external fact — capture it:

1. `scripts/kb.sh new <short-id> "Title" tag1,tag2` (scaffolds from
   `_TEMPLATE.md` with `origin: learned`).
2. Fill in: the fact, the evidence (error message, doc link, test), and what to
   do about it. Keep it under ~80 lines; link out rather than paste walls.
3. Add one row to the **routing table** above (a knowledge file not in the
   index doesn't exist).
4. Commit as `docs(knowledge): add <id>` (see COMMIT_GUIDELINES).
5. `scripts/kb.sh verify` must pass (front matter present, index row present,
   links resolve).

Do **not** put into knowledge: secrets, personal data, authoritative constants
that live in a single-source-of-truth file (knowledge may *explain* them, never
*define* them), or anything already stated in a guideline.
