# PROJECT_INTAKE.md — first-run onboarding

> This is the ritual an agent runs **once**, the first time a project is
> instantiated from this template and it hasn't been scoped yet. Its job is to
> turn a blank template into a filled, buildable plan — *without* shipping
> canned project-type presets. It first decides the plan **shape** (incremental
> vertical *slices* for a build, or a *phased* checklist for an upgrade /
> migration / refactor / maintenance job), then derives the plan for THIS
> project and stops for owner approval before writing any code.
>
> After intake completes and work begins, this file is inert history.

## When to run intake

Run intake if **any** of these is true:
- `STATUS.md` has `current_slice: intake`, or
- `docs/slices/` still contains the shipped example slices
  (`0000-walking-skeleton.md`, `0001-example-vertical-slice.md`) and no real
  ones (i.e. no slices have been written for this project), or
- `AGENTS.md` still contains unfilled `{{TOKEN}}` / `<< … >>` blocks.

If none are true, intake is done — proceed to the normal session ritual in
`CONTRIBUTING.md`.

## Phase A — Orient (read before asking anything)

1. Read `AGENTS.md`, this file, `docs/IMPLEMENTATION_PLAN.md` (Part A), and
   `docs/ARCHITECTURE.md` so you know the shape you're filling in.
2. Check the repo for any owner-provided material: a spec, design doc, PRD,
   README draft, wireframes, an issue describing the goal, or existing code.
   List what you found.
3. Choose your path:
   - **Spec path** — an owner-provided document describes the project. Extract
     as much of the Intake Checklist (below) as you can from it, then ask the
     owner *only* about the gaps.
   - **Interview path** — no usable spec. Walk the Interview Spine (below).
   In both paths you converge on the same filled Intake Checklist.
4. **Decide the plan shape** (state it; confirm with the owner):
   - **Slice plan** — you're *building* something incrementally (a new app,
     library, service, game, tool). Work decomposes into thin end-to-end
     vertical slices. Uses `docs/slices/`. **This is the default.**
   - **Phased plan** — you're making *bounded changes to a system that already
     exists*: a version upgrade (e.g. Odoo 16→19), a framework/dependency
     migration, a large refactor, a maintenance/bug-fix batch, or a research
     spike. There is no walking skeleton to build; the work is a sequence of
     phases. Uses an inline phased checklist in `IMPLEMENTATION_PLAN.md`, and
     **`docs/slices/` is removed** (Phase C spells out how).
   The test: *is a new thing being built, or an existing thing being changed?*
   Built → slices. Changed → phased.

## The Interview Spine (bounded — do not exceed this)

Ask these in order. Keep it to one focused round; batch sub-questions. Stop
asking once you can fill the checklist — over-interviewing is a failure mode.

1. **Identity.** What is this project in one or two sentences? Who is it for?
   And — importantly — what is it explicitly *not* (no server? not commercial?
   single-user?)?
2. **Stack (fixed).** Language/runtime, framework/UI, persistence, how it's
   built, how tests run. What's the dependency policy (none / approved list /
   open)?
3. **Constitution.** What must always be true — the rules that would make you
   reject an otherwise-working change? Is there a single source of truth for
   any critical constants (rates, thresholds, legal values), and where should
   it live? Is there an AI/authority boundary?
4. **Definition of v1.** What does "done" look like for the first shippable
   version? What's deliberately out of scope for now?
5. **Verification boundaries.** What can an automated test in a normal
   environment *not* prove for this project (device-only behavior, external
   integrations, real-money actions, production deploys)? These become manual
   checkpoints (⚑).
6. **The spine of the work.** *Slice plan:* what is the thinnest path that
   exercises the whole system end to end — the "walking skeleton" (becomes Slice
   0)? *Phased plan:* what's the current baseline (does it build/test as-is?) and
   what are the natural phases from there to done?
7. **Risk.** Which parts are most uncertain, most likely to be wrong, or most
   expensive to get wrong? (These get pulled early and tested hardest.)

If the owner is unavailable and a spec is thin, fill what you can, mark the
rest **`ASSUMPTION:`** inline, and flag every assumption in your handoff for
later confirmation — never invent authoritative constants.

## Deriving the plan (principles, not presets)

Use the branch that matches the plan shape you chose.

### Slice plan

You are writing the slice files in `docs/slices/` (one file each, numbered like
ADRs — see that folder's README). There is no canned arc per
project type — derive it from these reasoning patterns:

- **Slice 0 is always a walking skeleton:** the thinnest end-to-end thing that
  builds, runs, and passes one trivial test. Not a layer — a slice through
  every layer, however shallow. Everything else hangs off this.
- **Front-load risk and authority.** The pure, deterministic, high-consequence
  logic (the "core") comes early and carries the highest test bar. If getting a
  calculation wrong is the worst outcome, that calculation is Slice 1–2, fully
  tested, before any presentation.
- **Each slice is a thin vertical, independently green.** A slice touches
  whatever layers it must to deliver one demonstrable capability and leaves the
  repo building. Avoid horizontal "do all the models, then all the logic"
  phases.
- **Defer the un-testable.** Anything needing owner-only verification is a ⚑
  slice, placed as late as its dependencies allow, so the automatable mass is
  proven first.
- **Sequence by dependency, then by value.** Among slices you *could* do next,
  prefer the one that retires the most risk or unlocks the most downstream
  work.

How this cashes out differs by shape (reason about your case; don't copy):
a **library** slices by public-API capability behind a walking-skeleton call
site; an **app** builds the skeleton then feature verticals, device features
last (⚑); a **game/sim** proves a deterministic simulation core before any
rendering; a **content artifact/mod** starts with the smallest loadable unit
then adds content verticals; a **service** builds one end-to-end request path
then widens endpoint by endpoint. In every case the *principles* above hold —
only the concrete slices change.

### Phased plan (upgrades, migrations, refactors, maintenance)

There is no walking skeleton — the system already exists. You'll replace Part B
of `IMPLEMENTATION_PLAN.md` with a **phased checklist** derived from these
patterns (don't copy a canned upgrade recipe):

- **Phase 0 is a baseline + safety net.** Get the current version building and
  its existing tests running as-is in the dev environment, and capture a
  regression baseline (characterization tests, a golden output, a smoke pass).
  You cannot safely change what you cannot first verify.
- **Change behind the safety net, in independently-verifiable phases.** Each
  phase is a bounded, coherent step (a dependency bump, an API-compatibility
  pass, one module ported, a deprecation removed) that leaves the system
  building and its tests green. Order by dependency, then by risk retired.
- **Isolate the risky and the irreversible.** Data migrations, breaking changes,
  and anything touching production go late and get the most verification.
- **Owner/environment verification is a ⚑ phase.** Staging validation, a manual
  smoke of the upgraded instance, or a production cutover can't be proven by
  local tests — mark it ⚑ and stop for owner sign-off.

Write each phase into Part B in this shape:

```
## Phase N — <name>  [⚑ owner/staging verification — delete if not]
**Goal:** the bounded change this phase delivers.
**Preconditions:** the phase(s)/state that must be green first.
**Tasks:** the concrete changes, at their paths.
**Verification:** the tests/commands that prove this phase (green check.sh, a
regression pass, a diff against the Phase 0 baseline).
**Done:** the checkable bar for this phase.
```

## Phase C — Produce, then STOP

Fill these, then halt for owner sign-off **before writing code**.

**Common to both plan shapes:**

1. **`AGENTS.md`** — `{{PROJECT_DESCRIPTION}}`, the stack table, the Constitution
   (non-negotiables), and the escalation list. Delete every `<< … >>` you've
   resolved.
2. **`docs/IMPLEMENTATION_PLAN.md` Part A** — the Context Card (§A.1) and §A.2–A.6
   as they apply.
3. **`docs/ARCHITECTURE.md`** — at minimum §1 (goals), §2 (layer sketch), and §4
   (the boundary that must not be crossed). The rest fills in as work lands.
4. **`.protected-paths`** — add the authoritative-constants file and any
   golden-value test file, if the project has them.
5. **ADRs** — record any significant, contested, or expensive-to-reverse decision
   (stack, persistence model, the upgrade's target version, the AI boundary) in
   `docs/adr/`. Routine choices don't need one.

**Then, for a slice plan:**

6. **`docs/slices/`** — write the derived slices, one file each from
   `_TEMPLATE.md` (`0000-walking-skeleton.md`, then vertical slices, ⚑ where
   owner-verified), plus a row per slice in `docs/slices/README.md`.
   Delete/overwrite the shipped examples.
7. **`STATUS.md`** — board = the real slices; `current_slice: 0`,
   `current_slice_state: not-started`.

**Or, for a phased plan (no slices):**

6. **Remove the slice apparatus:**
   - delete the `docs/slices/` folder,
   - remove the `docs/slices/*` line from `.protected-paths`,
   - in `AGENTS.md` (How-to-work step 2 + doc map) and `CONTRIBUTING.md` (session
     ritual step 3 + slice lifecycle), swap the "current slice / `docs/slices/`"
     wording for "current phase / `IMPLEMENTATION_PLAN.md` Part B".
   The `check.sh` slice-hygiene stage then SKIPs on its own — no edit needed.
7. **`docs/IMPLEMENTATION_PLAN.md` Part B** — the phased checklist (Phase 0 =
   baseline + safety net, then the phases; ⚑ for owner/staging verification).
8. **`STATUS.md`** — relabel the board to phases: `current_phase: 0`,
   `current_phase_state: not-started`, one row per phase.

Then post an **intake summary** for the owner: identity + stack + constitution,
the proposed plan (slices *or* phases — numbered, ⚑ marked), every `ASSUMPTION:`
you made, and *"Approve this plan and I'll begin."* Do not start work until the
owner approves — this is the first checkpoint.

## Definition of done for intake

- [ ] No `{{TOKEN}}` or example `<< … >>` blocks remain in `AGENTS.md` or the
      plan's Part A.
- [ ] `ARCHITECTURE.md` §1/§2/§4 are filled.
- [ ] **Slice plan:** `docs/slices/` holds real, dependency-ordered slices
      (Slice 0 = walking skeleton; ⚑ marks owner-verified ones); the shipped
      examples are gone; the index matches; `STATUS.md` board matches;
      `current_slice: 0`.
- [ ] **Phased plan:** `docs/slices/` is deleted and fully de-referenced (its
      `.protected-paths` line removed; slice wording in `AGENTS.md` /
      `CONTRIBUTING.md` updated to phases); `IMPLEMENTATION_PLAN.md` Part B holds
      the phased checklist; `STATUS.md` tracks `current_phase: 0`.
- [ ] `scripts/kb.sh verify` passes and `scripts/check.sh` is ALL GREEN (build/
      test SKIP until Phase 0 / Slice 0 wires `scripts/project.sh`; slice hygiene
      SKIPs in phased mode).
- [ ] Intake summary posted; owner approval recorded before any code.
