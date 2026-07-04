# TESTING_GUIDELINES.md — {{PROJECT_NAME}}

Tests are how a slice proves it's done. Green `scripts/check.sh` is the only
accepted proof. Fill each section for your stack.

## 0. Shape tests to the architecture (principle)

Don't cargo-cult a fixed ratio — let the design decide the shape. A codebase
with a large pure, deterministic core leans toward a **pyramid** (many fast unit
tests over that core, few end-to-end). A codebase whose value is mostly in
integrations and I/O leans toward the **testing trophy** (weight on integration
tests that exercise real seams). Pick per project; state your choice and its
rationale in §8. Whatever the shape: the highest-consequence logic gets the
highest bar, and every test is deterministic (§5).

## 1. Frameworks & placement
<< The test framework(s), where tests live relative to source, naming
conventions, and how suites map to modules. >>

## 2. Commands (the only accepted proof of green)
<< The exact commands, wired into scripts/project.sh → project_test:

  scripts/check.sh              # full gate (slice completion)
  scripts/check.sh --fast       # inner loop (skips slow/UI)
  << your one-suite command >>  # targeted run named in each slice's Gate
>>

## 3. The golden values (calibration contract)
<< If the project has reference outputs the tests pin (a known-correct result
of the authoritative computation), list them here with tolerances and where
they're asserted. These literals are protected: never edited to make a test
pass. If a golden value can't be reproduced, STOP and escalate — document your
formula interpretation first. Delete this section if not applicable. >>

## 4. What every layer's tests must cover

### Core / pure logic (highest bar)
<< Exhaustive: boundary conditions, edge cases, the golden values. No mocks
needed — pure functions. This layer carries the project's correctness. >>

### Persistence
<< Round-trip, cascade/delete behavior, invariants (construct every model
arg-free if that's a rule), migration. >>

### ViewModels / controllers
<< State transitions given inputs; that they call Core rather than
recomputing. >>

### AI layer (delete if no AI)
<< Fully mocked — no live network in tests. Assert that AI outputs are treated
as drafts and never written to authoritative state; assert grounded answers
come from the source of truth. >>

### UI (thin, stable)
<< A few smoke/interaction tests; keep them stable and few. >>

## 5. Determinism rules
<< No wall-clock, no real network, no randomness in tests — inject clock/RNG.
Tests must pass identically on any machine, any order. >>

## 6. What cannot be tested here (Manual Checkpoints)
<< List behaviors your automated environment can't verify (device features,
external integrations, real deploys). These become ⚑ slices verified by the
owner. >>

## 7. Slice test discipline
<< Tests are written in the same slice as the code they cover. A slice isn't
done until its named tests exist and pass via its exact gate command. >>

## 8. Coverage posture
<< Your stance: e.g. "coverage is an outcome of testing behavior, not a target;
Core approaches 100%, UI is thin." State any hard floors. >>
