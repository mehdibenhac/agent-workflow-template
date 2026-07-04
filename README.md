# Agent Workflow Template

A reusable, provider-agnostic scaffold for building a project with AI coding
agents under tight control. It gives you, from commit zero:

- **One source of truth** (`AGENTS.md`) every agent reads first — Claude Code,
  Codex, Gemini, Cursor, Copilot, or whatever's next. The other tool files are
  thin pointers.
- **A self-bootstrapping onboarding** (`docs/PROJECT_INTAKE.md`) — on first run
  an agent interviews you (or reads your spec) and *derives* the plan for your
  project: vertical slices for a build, or a phased checklist for an upgrade /
  migration (in which case it strips the slice apparatus). No hand-filling, no
  presets.
- **A test-gated slice plan** (`docs/slices/`, one addressable file per slice) —
  work proceeds in small, ordered, individually-verified increments, never a
  big-bang, and an agent loads only the slice it's on.
- **A single health gate** (`scripts/check.sh`, backed by CI) — "done" means
  this is ALL GREEN. It degrades loudly (SKIPPED, never silently passed) before
  you've wired anything up, and runs on every push/PR.
- **Mechanical guardrails** (`.protected-paths` + a committed git hook, + CI +
  branch protection) — the files you designate as dangerous can't be changed
  without an explicit, audited override. Enforced at the git level, so it
  survives a tool switch.
- **A durable decision record** (`docs/adr/`) — significant, hard-to-reverse
  choices are captured as ADRs so the "why" survives across sessions.
- **A living knowledge base** (`docs/knowledge/` + `scripts/kb.sh`) — agents
  look up what's already solved and record what they discover, so the next
  session doesn't re-derive it.
- **Session continuity** (`STATUS.md` + `docs/HANDOFF.md`) — any agent can pick
  up exactly where the last one stopped.

The workflow is stack-agnostic. Your project's actual build/lint/test commands
live in one place (`scripts/project.sh`); everything else is just discipline.

---

## Using this template

### 1. Copy & name it

```bash
cp -r agent-workflow-template my-new-project
cd my-new-project
```

### 2. Stamp in your project's identity

Run the initializer — it replaces the `{{TOKENS}}` across every file:

```bash
scripts/init.sh
# prompts for: PROJECT_NAME, PROJECT_SLUG, OWNER_NAME, PROJECT_TAGLINE
# (or pass them:  scripts/init.sh --name "Maple" --slug maple --owner "Mehdi" \
#                                 --tagline "Tracks our Canada immigration plan")
```

Tokens used across the template:

| Token | Meaning | Example |
|---|---|---|
| `{{PROJECT_NAME}}` | Display name | `Maple` |
| `{{PROJECT_SLUG}}` | Lowercase machine name | `maple` |
| `{{OWNER_NAME}}` | Product owner (approves checkpoints) | `Mehdi` |
| `{{PROJECT_TAGLINE}}` | One-line purpose | `Tracks a family's Canada immigration plan` |
| `{{PROJECT_DESCRIPTION}}` | The "what this is" paragraph | *(fill by hand)* |

`init.sh` handles the four scalar tokens. The larger `<< ... >>` guidance
blocks are meant to be filled by hand — they're where you think, not just
substitute.

### 3. Scope the project — let an agent run intake (recommended)

The template ships with `STATUS.md` set to `current_slice: intake`. Point any
agent at the repo and tell it to read `AGENTS.md` and run intake. Following
`docs/PROJECT_INTAKE.md`, it will interview you (or ingest a spec doc you drop
in), then fill `AGENTS.md` (stack, constitution, escalation), derive the slice
arc as one file per slice in `docs/slices/`, sketch `ARCHITECTURE.md`, and set the
`STATUS.md` board — **then stop for your approval before writing any code.**

Prefer to do it yourself? Fill by hand in this order:
`AGENTS.md` → `scripts/project.sh` (copy from `.example`, define
build/test/lint) → `.protected-paths` (add your constants + golden-value files)
→ `docs/slices/` (one file per slice from `_TEMPLATE.md`; Slice 0 = walking
skeleton; ⚑ for owner-verified; update the index) → the
`ARCHITECTURE`/`CODING`/`TESTING` skeletons → `STATUS.md` board.

### 4. Initialize the repo

```bash
git init
scripts/setup.sh                       # activates hooks, reports tooling
ALLOW_PROTECTED=1 git commit -am "chore: scaffold from agent-workflow-template"
```

The very first commit needs `ALLOW_PROTECTED=1` because it introduces the
protected files themselves. After that, the guard blocks unapproved edits to
protected paths. On a hosted remote, enable a branch-protection ruleset on
`main` requiring the CI `check` job (see `.github/workflows/check.yml`) — that's
what makes the guard non-optional.

### 5. Build, slice by slice

Once intake is approved, the agent begins at Slice 0 and works the core loop
below — read state, implement a thin slice, prove it green, tag it, repeat.

---

## How the pieces fit

```
AGENTS.md ───────────────► the contract every agent reads first
  │
  ├─ docs/PROJECT_INTAKE.md ► first run: derive the plan (interview / spec)
  ├─ STATUS.md ──────────► where we are now (intake, then current slice + board)
  ├─ docs/HANDOFF.md ────► where the last session stopped
  ├─ docs/IMPLEMENTATION_PLAN.md ► plan reference (Context Card, methodology)
  ├─ docs/slices/ ───────► the slices — one addressable file each (read the current one)
  ├─ docs/README.md ─────► map of the doc set (where each doc belongs)
  ├─ docs/*.md ──────────► how to build/test/commit (the rules)
  ├─ docs/adr/ ──────────► why the significant decisions were made
  └─ docs/knowledge/ ────► what's true & already solved (kb.sh)

scripts/check.sh ────────► the gate: kb verify + guard + ADR & slice hygiene + project.sh lint/build/test
guard.sh + .protected-paths + .githooks/ + .github/workflows/ ► layered mechanical protection
CLAUDE.md / GEMINI.md / .github/ / .cursor/ ► one-line pointers to AGENTS.md
```

## The core loop

```
[first run] intake → derive plan → owner approves
then, per slice:
read AGENTS.md → STATUS.md → HANDOFF → pick lowest un-done slice
  → implement (small green commits) → write the slice's tests
  → scripts/check.sh ALL GREEN → tick acceptance boxes
  → [⚑ checkpoint? stop for owner sign-off]
  → update STATUS.md + write HANDOFF → tag slice-N-complete → next slice
```

## Design principles worth keeping

- **Instructions are suggestions; gates are mechanical.** Anything that must not
  break is enforced by git, not by asking nicely.
- **Green means green.** `check.sh` is the single definition of done. It never
  passes silently when it couldn't actually run something.
- **Escalate, don't improvise.** When plan and reality disagree, agents stop and
  ask rather than "fixing" authoritative logic.
- **Write down what you learn.** The knowledge base is part of the work, not
  overhead.
