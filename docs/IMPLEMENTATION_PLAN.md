# IMPLEMENTATION_PLAN.md — {{PROJECT_NAME}}

The build order of record: **test-gated vertical slices**. Each slice is a thin
end-to-end increment that leaves the repo building and adds its own tests. Work
strictly in order per `CONTRIBUTING.md`.

> This file is a **template**. On first run, the intake ritual
> (`docs/PROJECT_INTAKE.md`) fills Part A and derives the slice files in
> `docs/slices/` from a spec or an owner interview — you don't hand-invent
> slices from a preset. This file and `docs/slices/` are protected
> (`.protected-paths`): changing the plan after it's set requires owner approval.

---

# PART A — GLOBAL REFERENCE

## A.1 Context Card (RE-READ AT THE START OF EVERY SLICE)

- **Purpose:** {{PROJECT_TAGLINE}}
  << one or two sentences an agent can re-read cold to reorient. >>
- **What it does:** << the 2–4 core jobs, one clause each. >>
- **Stack (fixed):** << the short version of the AGENTS.md stack table. >>
- **Non-negotiables:** see `AGENTS.md` — << name the 2–3 that bite most often,
  e.g. "core is pure; single source of truth owns constants; golden values
  immovable". >>

## A.2 Repository Structure

```
<< Sketch the target source tree here so agents create files in the right
place. Keep it shallow and honest. Example shape:

{{PROJECT_SLUG}}/
├── README.md
├── AGENTS.md
├── docs/                 # this documentation set
├── src/                  # application code
│   ├── core/             # pure logic (no I/O, no framework) — the authority
│   ├── <feature areas>/
│   └── ...
├── tests/                # test suites mirroring src/
└── scripts/              # setup.sh, check.sh, guard.sh, kb.sh, project.sh
>>
```

## A.3 Project Generation / Build Config

<< How the build is configured and (re)generated. The command of record, where
the config lives, and what is generated vs. committed. If nothing is generated,
say so. Wire the real commands into scripts/project.sh. >>

## A.4 Build / Test Commands

See `AGENTS.md` quick reference and `TESTING_GUIDELINES.md`. The gate is
`scripts/check.sh`; per-slice gate commands are named in each slice below.

## A.5 Coding & Testing Conventions

Follow `docs/CODING_GUIDELINES.md` and `docs/TESTING_GUIDELINES.md`. Highlights:
<< 3–5 bullets an agent must not forget — the load-bearing conventions. >>

## A.6 Authoritative constants / reference values (optional)

<< If your project has a single source of truth for constants (fees, rates,
thresholds, legal values), name the file and paste or summarize its contents
here, with a `verifiedOn` date. If there are golden/reference values the tests
pin, list them with tolerances. Delete this section if not applicable. >>

## A.7 Slice Methodology

Strictly ordered; repo always builds; tests written in-slice; acceptance gates
per `CONTRIBUTING.md` §5. Manual checkpoints (⚑) mark slices that need
owner-only verification. Every slice is a file in `docs/slices/`, created from
`docs/slices/_TEMPLATE.md`; see that folder's README for the "deriving the arc"
principles and how to add one.

---

# PART B — THE SLICES

> **Plan shape.** By default the plan is *slices* (below). For a **phased**
> project — a version upgrade, migration, refactor, or maintenance batch —
> intake removes `docs/slices/` and replaces this Part B with an inline phased
> checklist (Phase 0 = baseline + safety net, then the phases). See
> `PROJECT_INTAKE.md` → "Deriving the plan → Phased plan". The rest of this
> section describes slice mode.

The slices no longer live in this file. Each is its own numbered, addressable
file in **`docs/slices/`** (same pattern as `docs/adr/`), so an agent loads only
the slice it's working on — not the whole arc.

- **Index & order:** `docs/slices/README.md`.
- **A single slice:** `docs/slices/NNNN-slug.md` (e.g. `0000-walking-skeleton.md`).
- **Add a slice:** copy `docs/slices/_TEMPLATE.md`; see that folder's README.
- **Status per slice:** `STATUS.md` board (this plan is the spec; the board is
  the state; git tags are the proof).

On first run, intake (`docs/PROJECT_INTAKE.md`) writes these slice files and the
index from a spec or an owner interview — Slice 0 is always a walking skeleton.

The `docs/slices/` folder is protected: adding, reordering, or rewriting a slice
spec needs owner approval, exactly as changing this plan always has.

---

## Escalation thresholds that change this plan

<< List the events that would force a re-plan (a platform capability lands, an
authoritative constant changes, an integration behaves differently than
assumed). When one happens: escalate, don't improvise. >>
