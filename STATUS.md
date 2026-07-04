# STATUS.md — machine-readable project state

> Any agent, any vendor: read this after AGENTS.md; update it before ending a
> session. One line per field; keep the table exactly in this shape.

current_slice: intake                 # intake until scoped; then 0,1,2,… (a phased plan uses current_phase instead)
current_slice_state: not-started      # not-started | in-progress | awaiting-checkpoint | done
last_session: —
last_agent: —
blockers: none
next_action: Run intake (docs/PROJECT_INTAKE.md) to derive the slice arc, get owner approval, then Slice 0

## Slice board

<< Intake produces this board from the derived slice files in `docs/slices/`.
It's the *state* mirror: one row per slice file, with status + tag. Replace the
example rows with your real slices; mark ⚑ checkpoints; keep the columns as
shown. (The slice files are the plan; this board is the state; git tags are the
proof.) >>

| Slice | Name | State | Tagged |
|---|---|---|---|
| 0 | Repo & project scaffolding | pending | — |
| 1 | << first vertical slice >> | pending | — |
| 2 | << … >> | pending | — |
| 3 | << … ⚑ example manual checkpoint >> | pending | — |

Flow: `intake` (one-time) → then per slice: pending → in-progress →
awaiting-checkpoint (⚑ slices) → done.
Git tags (`slice-N-complete`) remain the cryptographic truth; this file is the
fast-read mirror. If they disagree, tags win — fix this file.
