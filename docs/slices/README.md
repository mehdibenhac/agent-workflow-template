# Slices — index

The build order of record: test-gated **vertical slices**, one file each,
numbered and addressable (like `docs/adr/`). Each slice is a thin end-to-end
increment that leaves the repo building and adds its own tests. Work strictly in
order per `CONTRIBUTING.md`.

**Read only the current slice's file** — not the whole folder. That's the point
of splitting them: an agent loads the one slice it's working, not all of them.

Three layers, three jobs:
- **This folder = the plan** (the slice specs). It is protected
  (`.protected-paths`) — add/change/reorder slices only with owner approval.
- **`STATUS.md` board = the state** (each slice's status + tag). Freely updated
  as work proceeds; it mirrors this folder.
- **Git tags (`slice-N-complete`) = the proof.** If a mirror and the tags
  disagree, the tags win.

Global reference that applies across all slices — the Context Card, conventions,
slice methodology, and arc principles — lives in `docs/IMPLEMENTATION_PLAN.md`.
On first run, intake (`docs/PROJECT_INTAKE.md`) derives these slice files from a
spec or an owner interview.

## How to add a slice

1. Copy `_TEMPLATE.md` to `NNNN-slug.md` (next number, 4-digit zero-padded).
2. Fill the front matter (`slice`, `title`, `depends_on`, `checkpoint`) and body.
3. Add a row to the index below **and** a row to the `STATUS.md` board.
4. Commit (owner-approved — this folder is protected):
   `ALLOW_PROTECTED=1 git commit` … as `docs(slices): NNNN <title>`.

Filenames are 4-digit for stable sort order; the slice *number* and its tag stay
unpadded in prose (`Slice 5`, `slice-5-complete`).

## Index

| # | Title | ⚑ | Goal (one line) |
|---|---|---|---|
| [0000](0000-walking-skeleton.md) | Walking skeleton | | Thinnest end-to-end build + one passing test |
| [0001](0001-example-vertical-slice.md) | << first vertical slice >> | | << … >> |
| | << 0002 … >> | | |
