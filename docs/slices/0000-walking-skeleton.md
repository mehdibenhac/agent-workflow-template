---
slice: 0
title: Walking skeleton
depends_on: []
checkpoint: false
---

# Slice 0 — Walking skeleton (repo & project scaffolding)

**Goal:** The thinnest end-to-end path that builds, runs, and passes one trivial
test — a slice through every layer, however shallow, not a horizontal "set up
everything" phase.
**Preconditions:** Empty git repo; toolchain from `scripts/setup.sh` present.
**Tasks:** Create the source tree (stubs allowed) per `IMPLEMENTATION_PLAN.md`
§A.2; build config (§A.3); `.gitignore`; the minimal entry point that builds;
copy `scripts/project.sh.example` → `scripts/project.sh` and fill in
`project_build` / `project_test`; one trivial passing test.
**Tests:** `smokeTestPasses` → asserts `true`.
**Gate:** `scripts/check.sh` (project_test runs the smoke test).
**Acceptance:** project builds; the smoke test passes; `scripts/check.sh` ALL
GREEN; zero warnings.
