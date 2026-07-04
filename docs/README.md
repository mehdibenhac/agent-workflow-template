# Documentation map

Where everything lives, and — using the four
[Diátaxis](https://diataxis.fr) modes — where *new* docs belong. Keeping each
doc in one mode is what stops them sprawling into each other.

## The four modes

- **Explanation** (understanding-oriented): why the system is the way it is.
  → `ARCHITECTURE.md`, `docs/adr/` (decision records).
- **Reference** (information-oriented): precise, lookup-first facts and rules.
  → `CODING_GUIDELINES.md`, `TESTING_GUIDELINES.md`, `COMMIT_GUIDELINES.md`,
  `docs/knowledge/` (the searchable knowledge base).
- **How-to** (task-oriented): steps to accomplish a specific goal.
  → `CONTRIBUTING.md` (the working process), `PROJECT_INTAKE.md` (first-run
  onboarding), the `.agents/skills/` playbooks.
- **Tutorial** (learning-oriented): a guided first path.
  → the root `README.md` ("Using this template").

## The full set

| File | Mode | For |
|---|---|---|
| `../AGENTS.md` | (entry point) | The contract every agent reads first — rules, constitution, doc map |
| `../README.md` | Tutorial | Human overview + how to instantiate the template |
| `IMPLEMENTATION_PLAN.md` | Reference | Global plan reference: Context Card, conventions, methodology |
| `slices/` | Reference | The slice plan — one file per slice (slice-mode projects; a phased plan omits this) |
| `PROJECT_INTAKE.md` | How-to | First-run ritual: derive the plan from a spec or interview |
| `CONTRIBUTING.md` | How-to | Slice lifecycle, checkpoints, escalation |
| `ARCHITECTURE.md` | Explanation | System design: layers, data flow, the one boundary |
| `adr/` | Explanation | Why significant decisions were made (immutable, numbered) |
| `CODING_GUIDELINES.md` | Reference | How to write code here |
| `TESTING_GUIDELINES.md` | Reference | Test strategy, golden values, determinism |
| `COMMIT_GUIDELINES.md` | Reference | Commit format, scope discipline, tagging |
| `knowledge/` | Reference | Searchable long-term memory (`kb.sh`) — facts & pitfalls |
| `../STATUS.md` | (state) | Machine-readable current position |
| `HANDOFF.md` | (state) | Session-continuity log |

## Placing a new doc

- Explaining a *choice* → an ADR in `adr/`. Explaining the *system* →
  `ARCHITECTURE.md`.
- A reusable *fact or recipe* discovered while working → a `knowledge/` entry
  (`kb.sh new`), not prose buried in a guideline.
- A *rule* everyone must follow → the relevant `*_GUIDELINES.md`.
- A *procedure* → `CONTRIBUTING.md` or a skill in `.agents/skills/`.

If a doc wants to be two modes at once, split it. Drift between a doc and the
code is a defect, fixed in the same change.
