---
name: project-intake
description: Run ONCE on first contact with a freshly-instantiated template, when no slice arc exists yet (STATUS shows current_slice intake, or docs/slices/ still holds only the example slices, or AGENTS.md still has unfilled tokens). Turns a blank template into a filled, buildable, owner-approved plan by interviewing the owner or ingesting a provided spec, then deriving a vertical-slice arc as one file per slice in docs/slices/. Do NOT use once real slices exist — use the normal session ritual instead.
---

# Project Intake

Full ritual: `docs/PROJECT_INTAKE.md`. This skill is the short operating loop.

## Trigger check (first thing, every session)

Before normal slice work, check whether intake is still pending:
- `STATUS.md` → `current_slice: intake`, OR
- `docs/slices/` still holds only the shipped example slices, OR
- `AGENTS.md` still contains `{{TOKEN}}` or `<< … >>` blocks.

Any true → run intake now, before anything else. All false → skip; go to
`CONTRIBUTING.md` session ritual.

## Loop

1. **Orient.** Read `AGENTS.md`, `docs/PROJECT_INTAKE.md`,
   `docs/IMPLEMENTATION_PLAN.md` (Part A), `docs/ARCHITECTURE.md`. Inventory any
   owner-provided spec/design/code in the repo.
2. **Derive inputs.** Spec present → extract the Intake Checklist from it, ask
   only about gaps. No spec → walk the Interview Spine (7 questions, one bounded
   round). Never invent authoritative constants; mark unknowns `ASSUMPTION:`.
3. **Choose the plan shape, then plan.** *Building a new thing* → **slice plan**:
   write the slice files in `docs/slices/` (one per slice, numbered like ADRs).
   *Changing an existing system* (upgrade/migration/refactor/maintenance) →
   **phased plan**: delete `docs/slices/`, remove its `.protected-paths` line,
   swap slice wording for phases in `AGENTS.md`/`CONTRIBUTING.md`, and write a
   phased checklist in `IMPLEMENTATION_PLAN.md` Part B (Phase 0 = baseline +
   safety net). Either way use the *principles* (walking skeleton / baseline
   first; front-load risk; thin independently-green steps; ⚑ for owner-only
   verification; order by dependency then value). No canned presets.
4. **Fill artifacts** in order: `AGENTS.md` (description, stack, constitution,
   escalation) → plan Part A Context Card → the plan (slice files + index, **or**
   phased Part B) → `ARCHITECTURE.md` §1/§2/§4 → `.protected-paths` → `STATUS.md`
   (`current_slice: 0` or `current_phase: 0`) → ADRs for any significant
   decision.
5. **Stop for approval.** Post the intake summary (identity, stack,
   constitution, numbered slice arc with ⚑, every `ASSUMPTION:`) and ask the
   owner to approve. **Do not start Slice 0 until approved** — this is the first
   checkpoint.

## Quality bar

- Verify: no tokens/example blocks left; **slice plan** → example slices
  replaced and Slice 0 is a true walking skeleton; **phased plan** →
  `docs/slices/` deleted and de-referenced and Part B holds the phased checklist;
  `scripts/kb.sh verify` OK; `scripts/check.sh` ALL GREEN (build/test SKIP until
  Slice 0 / Phase 0 wires project.sh; slice hygiene SKIPs in phased mode).
- Under-interview, don't over-interview: stop asking the moment the checklist is
  fillable.
- The plan is a proposal until the owner signs off. Intake never writes app code.
