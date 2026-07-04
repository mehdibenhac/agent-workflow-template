---
id: kb-agent-portability
title: Provider-agnostic agent setup — what reads what, and what is mechanical
tags: [agents, tooling, portability, guardrails]
origin: seeded
status: watch
verified: 2026-07-04
supersedes: ""
sources: [AGENTS.md spec, vendor docs for Codex/Gemini/Cursor/Copilot/Claude Code]
---

# Provider-agnostic agent setup

## The facts

- **AGENTS.md is the neutral core.** Codex, Gemini CLI/Jules, Cursor, Amp and
  others read it natively; Claude Code and Copilot need thin adapters. This
  repo therefore keeps ALL instruction content in AGENTS.md and ships
  pointer-only adapters: `CLAUDE.md`, `GEMINI.md`,
  `.github/copilot-instructions.md`, `.cursor/rules/project.mdc`.
- **Instructions are suggestions; gates must be mechanical.** Any agent can
  ignore a doc; none can ignore git. Protected paths live as data in
  `.protected-paths`, enforced by `scripts/guard.sh` via the committed
  `.githooks/pre-commit` (activated by `git config core.hooksPath .githooks`
  in `scripts/setup.sh`). Hooks are bypassable with `--no-verify`, so the same
  guard also runs inside `scripts/check.sh`.
- **One verification command.** `scripts/check.sh` is the universal
  "prove you're done" interface every vendor's agent can run; it degrades
  loudly (SKIPPED sections) before the first slice and on machines missing the
  build toolchain.
- **Skills are playbooks first.** `.agents/skills/*/SKILL.md` are plain
  markdown any agent can follow as instructions; native skill-loading is a
  bonus, not a dependency.
- **Some cloud agents cannot run the real build.** They operate in read-only
  mode (docs, knowledge, tests-as-specs, review) per AGENTS.md.

## Boundaries / invalidation

- Vendor file conventions move quickly (`status: watch`): re-verify adapter
  filenames when adopting a new tool, and update this entry + adapters together.
- If AGENTS.md gains true universal adoption (including every tool you use),
  delete the adapters and this entry's first bullet.
