# COMMIT_GUIDELINES.md — {{PROJECT_NAME}}

Git history is the project's second documentation system. An agent (or the
owner) must be able to reconstruct *why* anything changed from `git log` alone.

## 1. Format — Conventional Commits, slice-scoped

```
<type>(<scope>): <imperative summary ≤ 72 chars>

<body: what changed and WHY, wrapped at 72>

Slice: <N>
Tests: <suites/commands run and green, or "n/a">
```

### Types
| type | use for |
|---|---|
| `feat` | new user-visible or agent-verifiable capability |
| `fix` | bug fix (must reference the reproducing test) |
| `test` | tests only |
| `refactor` | behavior-preserving restructure |
| `chore` | build config, ignore rules, tooling, assets |
| `docs` | anything under `docs/`, README, AGENTS.md |
| `rules` | changes to authoritative constants (see §4) |

<< Add project-specific types if useful (e.g. `seed` for seed data). >>

### Scopes
<< List your project's module/area scopes, e.g.:
`core`, `api`, `ui`, `db`, `auth`, `docs`, `knowledge`, `project`. >>

Knowledge entries commit as `docs(knowledge): add kb-<id>` (or `update`/`supersede`).

### Example

```
feat(core): compute rolling-window eligibility

Adds the pure calculation over a rolling window anchored at the
start date. Boundary days count as full days per the spec; overlapping
inputs are merged before counting so nothing is double-counted.

Slice: 2
Tests: CoreTests (all green)
```

## 2. Scope discipline

- **One logical change per commit.** A slice is typically 2–6 commits
  (model → logic → tests → UI → wiring), each of which leaves the repo building.
- Never mix slices in one commit. Never mix `rules` with anything else.
- Build-config edits commit together with the artifacts they require, and note
  any generation command that was run.
- Generated files stay out of git (see `.gitignore`). Never force-add them.

## 3. The commit gate

Before every commit:

1. The project builds for the touched targets.
2. The tests named in `Tests:` are green (full `scripts/check.sh` at slice end).
3. Zero new warnings.
4. `git diff --staged` reviewed — no debug prints, no commented-out code, no
   stray files, no secrets (grep the diff for key-like strings).

## 4. Protected changes

Protected paths are listed in `.protected-paths` and enforced mechanically by
the committed pre-commit hook (`scripts/guard.sh`). An owner-approved change
commits with `ALLOW_PROTECTED=1 git commit …` using the proper type below.
`--no-verify` bypass is visible anyway: the same guard runs in
`scripts/check.sh`. **Note: the repo's very first commit introduces the
protected files themselves and therefore needs the override once**:
`ALLOW_PROTECTED=1 git commit ...`.

- **Authoritative constants** (the single-source-of-truth file) may only change
  in a dedicated `rules(...)` commit whose body cites the official source and
  the owner's approval, and which bumps the `verifiedOn`/`verified` date. Agents
  never change these on their own initiative (AGENTS.md escalation).
- **Golden test values** are never edited. A commit touching those literals is
  invalid by definition.

## 5. Branches, tags, merges

- Single-agent flow: work directly on `main`, keeping every commit green.
- If branching (multiple agents / risky spikes): `slice/N-short-name`, merged
  with `--no-ff` so the slice boundary survives in history.
- Tag slice completion: `git tag slice-N-complete` on the commit where the
  slice's acceptance criteria all passed.
- Manual-checkpoint slices get the tag only **after** owner sign-off; note the
  sign-off in the tag message.

## 6. Reverts & fixes

- Prefer `git revert` over history rewriting; `main` is never force-pushed.
- A `fix` commit body names the failing test that reproduced the bug and the
  commit that introduced it (`Fixes regression from <sha>`).
