# CONTRIBUTING.md — {{PROJECT_NAME}}

How work happens in this repository — for AI agents primarily, and for the
owner ({{OWNER_NAME}}) when they dive in themselves. This doc covers *process*;
the rules of *what* to build live in the implementation plan, and *how* to
write it lives in the coding/testing guidelines.

## 1. Roles

- **Owner / product owner:** {{OWNER_NAME}}. Approves manual checkpoints,
  changes to authoritative constants, scope changes, and anything under
  "Escalation".
- **Agent:** any AI coding agent operating in the repo. Executes slices in
  order, gates itself on tests, escalates per AGENTS.md.

## 2. Session start ritual (every session, no exceptions)

0. **If the project isn't scoped yet** (`STATUS.md` → `current_slice: intake`,
   or the plan's Part B still has example slices), run intake first
   (`docs/PROJECT_INTAKE.md`) and stop for owner approval before any code. The
   steps below assume a scoped plan.
1. Read `AGENTS.md` top to bottom.
2. Read the Context Card in `docs/IMPLEMENTATION_PLAN.md` §A.1.
3. Determine repo state: `STATUS.md` board, `git log --oneline -10`, and the
   latest `slice-N-complete` tag → the current slice is the lowest-numbered
   slice whose acceptance criteria are not yet all met. Open **only that slice's
   file** in `docs/slices/` (e.g. `docs/slices/0003-*.md`), not the whole folder.
   *(Phased-plan projects: work the current phase in `IMPLEMENTATION_PLAN.md`
   Part B; there is no `docs/slices/`.)*
4. Skim `docs/knowledge/README.md`'s routing table (or `scripts/kb.sh list`)
   so you know what's already solved.
5. Run `scripts/check.sh` once to confirm the baseline is green **before**
   changing anything. If the baseline is red, fixing it *is* the task (as a
   `fix` commit) before slice work resumes.

## 3. Slice lifecycle

```
pick slice → verify preconditions → implement (small green commits)
      → write the slice's named tests → run the slice's exact gate command
      → run scripts/check.sh (full) → check every acceptance box
      → [manual-checkpoint slice? request owner sign-off and STOP]
      → update STATUS.md + write HANDOFF entry → tag slice-N-complete → next slice
```

*(Phased plans follow the same lifecycle with **phase** in place of **slice** —
tag `phase-N-complete`.)*

Rules:

- **Strictly in order.** Never open slice N+1 with slice N unfinished, and never
  reorder to "unblock" yourself — if you feel blocked, that's an escalation.
- **The repo always builds** between commits, not just between slices.
- **No hidden cross-slice work.** If a later slice needs a helper, it creates
  it. Do not gold-plate ahead.
- **Scope changes are owner decisions.** If a slice's task list seems wrong or
  incomplete, propose the change (see §6), don't improvise it.

## 4. Manual checkpoints (owner-only verification)

Some slices depend on things automated tests in your environment cannot prove
(device-only behavior, external integrations, real-money flows, production
deploys). Mark those slices ⚑ in the plan and STATUS board. For each:

1. Complete every code task; all runnable tests green; zero warnings.
2. Commit, then leave a checkpoint request containing: what was built, the human
   verification script from the plan, and any setup steps.
3. **Stop.** Do not tag `slice-N-complete`, do not begin the next slice, do not
   self-certify. Resume on the owner's explicit sign-off; record it in the tag
   message.

## 5. Definition of Done (any slice)

- [ ] Every task in the slice's task list implemented at the stated paths.
- [ ] Every named test exists and is green via the slice's exact gate command.
- [ ] `scripts/check.sh` ALL GREEN (project build/test, kb verify, guard, lint).
- [ ] Zero warnings.
- [ ] Acceptance-criteria checklist fully satisfied.
- [ ] Commits follow `docs/COMMIT_GUIDELINES.md`; slice tagged.
- [ ] Docs updated **in the same change** if behavior/architecture moved
      (ARCHITECTURE.md drift is a defect).
- [ ] Non-obvious discoveries captured in `docs/knowledge/`
      (knowledge-capture skill) and `scripts/kb.sh verify` passes.

## 6. Proposing changes to the plan or rules

The plan is authoritative but not infallible. To change it:

1. Open a short proposal: what, why, which slices/docs are affected, and
   evidence (test output, doc link, API change). If the change is a significant,
   contested, or hard-to-reverse *architectural* decision, write it as an ADR in
   `docs/adr/` (see its README) — that's the durable record of the "why".
2. Owner approves → apply the change to the plan/doc **and** the code in the
   same reviewed change, with a `docs:` or `rules:` commit as appropriate.
3. Changes to authoritative constants additionally follow COMMIT_GUIDELINES §4
   (dedicated commit, source cited, `verifiedOn`/`verified` bumped).

Never leave the plan saying one thing and the code doing another.

## 7. Escalation (stop-and-ask triggers)

Stop work and ask the owner when any of these occurs:

- A **golden/reference value** can't be reproduced (document your
  interpretation first).
- An **authoritative constant** looks outdated or wrong.
- Platform/library reality contradicts the plan (API removed/changed).
- A task appears to need a **dependency the policy forbids**.
- Two docs in `docs/` contradict each other.
- A **manual checkpoint** is reached (§4).
- Anything involving secrets, credentials, or personal data.

Escalations are cheap; silently-wrong authoritative logic is not.

## 8. Enforcement — the layers that make the gate real

"Instructions are suggestions; gates are mechanical." Three layers, defense in
depth, because each has an escape hatch the next one closes:

1. **Pre-commit hook** (`.githooks/pre-commit` → `guard.sh`) — blocks protected-
   path edits locally. Fast, but bypassable with `git commit --no-verify`.
2. **The gate** (`scripts/check.sh`) — runs the same guard plus kb/ADR hygiene
   and the project's build/test. Run it before calling anything done; a bypass
   at layer 1 still surfaces here.
3. **CI** (`.github/workflows/check.yml`) — runs `check.sh` on every push/PR, so
   a local bypass can't reach `main` unnoticed. **Recommended:** enable a branch
   protection rule / ruleset on `main` requiring the `check` job to pass (and,
   ideally, disallowing force-pushes). That is what makes the guard truly
   non-optional rather than merely encouraged.

## 9. Environment expectations

<< State what a full build/test environment needs (OS, toolchain, runtimes) and
which tools are optional. Note whether network access is required to build or
test, and where any secrets live (never in the repo). >>

## 10. For the human contributor

Everything above applies to you too, with one liberty: you may work out of
slice order on your own project. If you do, keep commits conventional, keep
tests green, and leave a note in the commit body when you've consciously
deviated — the next agent session will reconcile against the plan.
