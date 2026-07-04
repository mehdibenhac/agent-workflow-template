# AGENTS.md — {{PROJECT_NAME}}

> **Read this file first, every session.** The entry point for any agent or
> human here: what {{PROJECT_NAME}} is, what you may and may not do, and where
> the authoritative docs live. It stays lean on purpose — it points, it doesn't
> duplicate. Fill every `{{TOKEN}}` and `<< ... >>` block when instantiating,
> then delete this note. See `README.md` (§ Using this template).

## What this project is

{{PROJECT_DESCRIPTION}}
<< One or two paragraphs: what it is, who it's for, what it is NOT (e.g.
"no server", "personal, not commercial"). Keep it tight — this is the frame
every agent reads first. >>

## Tech stack (fixed — do not change without escalation)

| Concern | Choice |
|---|---|
| Language / runtime | << e.g. TypeScript / Node 20 >> |
| Framework / UI | << >> |
| Persistence | << >> |
| Architecture | << the shape agents must respect >> |
| Tests | << framework + how they run >> |
| Build / project gen | << the command of record >> |
| Dependencies policy | << e.g. "no third-party packages" or "approved list only" >> |

## Constitution — non-negotiable (violating any of these fails review)

The small set of principles that govern **all** work here and outrank any
slice, instruction, or agent convenience. Keep this list short and absolute;
everything else is guidance. (This section lives inside AGENTS.md, which is a
protected path — changes need owner approval.)

<< Make each rule specific and checkable. Replace the examples below; keep the
ones that generalize. >>

1. **The declared architecture is binding.** << name your load-bearing
   boundary — e.g. "core logic is pure and framework-free; UI never contains
   business rules". >>
2. **A single source of truth owns << the critical data >>** — never derived
   from model memory or guessed. << e.g. authoritative constants live in one
   file with a `verifiedOn` date. >>
3. **The AI copilot (if any) proposes; the app disposes.** Every AI output is a
   draft requiring explicit human approval; AI code paths never write
   authoritative state directly. << delete if no AI in this project. >>
4. **Golden / reference values are immovable.** << list them or point to the
   file. If you cannot reproduce a golden value, STOP, document your
   interpretation, and reconcile — never edit the reference number. >>
5. **No force-unwrapping / no silent failure** in shipped code paths.
   << adapt to your language's footgun. >>
6. << add project-specific invariants — persistence rules, security rules,
   performance budgets. >>

## How to work in this repo

0. **First run?** If `STATUS.md` shows `current_slice: intake`, or the plan's
   Part B still has example `<< … >>` slices, or this file still has unfilled
   `{{TOKEN}}`/`<< … >>` blocks — the project hasn't been scoped yet. Run the
   intake ritual (`docs/PROJECT_INTAKE.md`, project-intake skill) to derive the
   plan *before* any slice work, and stop for owner approval. Otherwise skip to 1.
1. Read the **Context Card** in `docs/IMPLEMENTATION_PLAN.md` (§A.1) at the
   start of every session, then `STATUS.md` and the newest `docs/HANDOFF.md`
   entry.
2. Find the current slice from `STATUS.md`, then open **only that slice's file**
   in `docs/slices/` (e.g. `docs/slices/0003-*.md`) — not the whole folder. The
   current slice is the lowest-numbered one whose acceptance criteria aren't yet
   met. Work **strictly in slice order**. *(Phased-plan projects have no
   `docs/slices/` — work the current phase in `IMPLEMENTATION_PLAN.md` Part B
   instead; see `PROJECT_INTAKE.md`.)*
3. **Before solving any non-trivial problem, check the knowledge base**
   (`scripts/kb.sh search <terms>` or the routing table in
   `docs/knowledge/README.md`). **After diagnosing anything surprising, capture
   it** (`scripts/kb.sh new …`; see the knowledge-capture skill).
4. Follow `docs/CODING_GUIDELINES.md` for all code you write.
5. Write the slice's tests in the same slice as the code
   (`docs/TESTING_GUIDELINES.md`).
6. Gate yourself: a slice is done only when its named tests pass via the exact
   command in the plan, the build is clean (**zero warnings**),
   `scripts/kb.sh verify` passes, and every acceptance-criteria box is checked.
7. Commit per `docs/COMMIT_GUIDELINES.md` — small, slice-scoped commits.
8. Never start a slice whose preconditions aren't green.
9. Some slices end in a **Manual Checkpoint** (owner-only verification — things
   automated tests can't prove). Complete all code and buildability, then stop
   and request owner sign-off. Do not self-certify.

## Build & test quick reference

**The gate:** `scripts/check.sh` — one command that proves the repo is healthy
(knowledge lint, protected-paths guard, then your project's lint/build/test as
defined in `scripts/project.sh`). Green `check.sh` is the definition of "done";
everything below is for targeted inner loops.

```bash
scripts/setup.sh            # one-time (idempotent) bootstrap: hooks, exec bits
scripts/check.sh            # THE gate — must be ALL GREEN to call work done
scripts/check.sh --fast     # inner loop (skips slow/UI tests)

# << add your project's own inner-loop commands here — the exact build and
# single-suite test invocations agents will use. These also live, verbatim,
# in each slice's Gate line in IMPLEMENTATION_PLAN.md. >>
```

## Document map

| Document | Purpose |
|---|---|
| `AGENTS.md` (this file) | Entry point, rules of engagement |
| `README.md` | Human-facing overview + how to instantiate this template |
| `docs/README.md` | Map of the doc set (Diátaxis modes) — where each doc and any new one belongs |
| `docs/PROJECT_INTAKE.md` | **First-run onboarding** — derive the plan from a spec or owner interview |
| `docs/ARCHITECTURE.md` | System design: layers, data flow, module contracts, boundaries |
| `docs/IMPLEMENTATION_PLAN.md` | Global reference: Context Card, conventions, methodology (Part B → docs/slices/) |
| `docs/slices/` | The slice plan — one numbered, addressable file per slice; read only the current one |
| `docs/adr/` | Architecture Decision Records — *why* significant decisions were made |
| `docs/CODING_GUIDELINES.md` | Naming, structure, safety, project-specific code rules |
| `docs/TESTING_GUIDELINES.md` | Test strategy, golden values, mocking, commands |
| `docs/COMMIT_GUIDELINES.md` | Commit format, scope discipline, slice tagging |
| `docs/CONTRIBUTING.md` | Workflow: slice lifecycle, checkpoints, escalation |
| `docs/knowledge/README.md` | **Knowledge base index** — routing table mapping questions to files |
| `.agents/skills/project-intake/SKILL.md` | Skill: first-run — interview/ingest a spec and derive the slice arc |
| `.agents/skills/knowledge-lookup/SKILL.md` | Skill: find answers in docs/knowledge before web-searching |
| `.agents/skills/knowledge-capture/SKILL.md` | Skill: record discoveries so they're never re-derived |
| `.github/workflows/check.yml` | CI: runs `scripts/check.sh` on every push/PR (hook backstop) |
| `scripts/kb.sh` | Helper: `list` / `search` / `show` / `new` / `verify` across docs + knowledge |
| `STATUS.md` | Machine-readable state: current slice, slice board — update before session end |
| `docs/HANDOFF.md` | Session-continuity log — newest entry = where the last session stopped |
| `scripts/check.sh` | **The gate.** One command proving the repo healthy; degrades loudly by stage |
| `scripts/project.sh` | Project-specific lint/build/test hooks called by check.sh & setup.sh |
| `scripts/guard.sh` + `.protected-paths` + `.githooks/` | Mechanical protected-paths enforcement (data + hook), tool-independent |
| `scripts/setup.sh` | Idempotent bootstrap: hooks path, exec bits, capability report |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | Thin adapters — pointer files only; all content lives HERE |

## Multi-tool policy (provider-agnostic by design)

This file is the single source of truth for **every** agent — Claude Code,
Codex, Gemini CLI/Jules, Cursor, Copilot, Aider, or anything newer. Adapter
files exist only to route those tools here; never put instructions in them.
Rules that must survive a tool switch are enforced mechanically, not by prose:
protected paths via the committed git hook, health via `scripts/check.sh`.
Skills in `.agents/skills/` are plain-markdown playbooks — follow them as
instructions even if your tool has no native skill loading.

## Read-only mode (cloud / limited environments)

Can't run the real build/test toolchain (no target OS/SDK/device)? You may
still do `docs/` + `docs/knowledge/` work, tests-as-specification (mark them
`// UNVERIFIED: written off-environment`), review, and plan/status upkeep. You
may **not** mark slices done, tag, advance `STATUS.md` past `in-progress`, or
claim `check.sh` results you didn't run. Note the limitation in your HANDOFF.

## Escalation — stop and ask the owner when

- A golden/reference value cannot be reproduced (Non-negotiable #4).
- An authoritative constant appears outdated (do not silently "fix" it).
- Platform/library behavior contradicts the plan.
- Any task seems to require a new dependency the policy forbids (redesign, or
  escalate for approval).
- Two docs in `docs/` contradict each other.
- A Manual Checkpoint is reached.
