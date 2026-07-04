# 0001 — Record architecture decisions

- **Status:** accepted
- **Date:** YYYY-MM-DD   <!-- set when the owner accepts this during intake -->
- **Deciders:** {{OWNER_NAME}}
- **Slice:** n/a

## Context

Significant decisions on this project — the stack, the load-bearing
architectural boundary, the persistence model, whether and how AI writes state —
need to be findable later with their rationale intact. `git log` records *what*
changed; it does not durably answer *why we chose this over the alternative*.
`docs/ARCHITECTURE.md` describes the system as it *is*, not the decision history
behind it.

## Options considered

- **Nothing** — rely on commit messages and memory. Cheap now, lossy later;
  the next agent re-litigates settled choices.
- **A single running decision log** — one file, one line per decision. Better,
  but conflates unrelated decisions and doesn't hold context/consequences.
- **Architecture Decision Records (ADRs)** — one short, numbered, immutable
  file per significant decision, in `docs/adr/`.

## Decision

We will record significant architectural decisions as ADRs in `docs/adr/`,
one numbered file each, using `0000-template.md` (a lightweight MADR/Nygard
format). ADRs are append-only: to change a decision, write a new ADR and mark
the old one `superseded by NNNN` rather than editing history. `docs/adr/README.md`
is the index; `ARCHITECTURE.md` §8 points here rather than duplicating.

An ADR is warranted when a decision is significant, contested, or expensive to
reverse. Routine, obvious, or easily-changed choices do not need one.

## Consequences

- The "why" behind load-bearing choices survives sessions and tool switches.
- A small per-decision cost (write one short file) — accepted deliberately, and
  scoped to *significant* decisions only so it doesn't become bureaucracy.
- Intake (`docs/PROJECT_INTAKE.md`) may produce the first few ADRs when it
  settles the stack and the core boundary.
- `check.sh` performs light ADR hygiene (numbered filename, a `Status:` line);
  the index is maintained by hand.
