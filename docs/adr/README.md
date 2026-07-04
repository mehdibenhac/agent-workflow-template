# Architecture Decision Records

Significant, contested, or expensive-to-reverse decisions live here — one
numbered, immutable file each. This folder is the *why*; `ARCHITECTURE.md` is
the *what* (the current system). See `0001-record-architecture-decisions.md`
for the practice itself.

## How to add one

1. Copy `0000-template.md` to `NNNN-short-title.md` (next number, zero-padded).
2. Fill Context → Options → Decision → Consequences. Keep it to one screen.
3. Set `Status: proposed`; the owner moves it to `accepted`.
4. Add a row to the index below.
5. Commit as `docs(adr): NNNN <title>`.

To **change** a past decision, don't edit it — write a new ADR and set the old
one's status to `superseded by NNNN`, with a pointer in the new one's Context.

When is an ADR warranted? Significant / contested / hard-to-reverse choices:
the stack, the core architectural boundary, the persistence model, the AI
authority line, a dependency exception. Routine choices are not.

## Index

| # | Title | Status | Date |
|---|---|---|---|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | accepted | — |
| | << next ADR — e.g. 0002 Choose persistence model >> | | |
