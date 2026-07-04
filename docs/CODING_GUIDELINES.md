# CODING_GUIDELINES.md — {{PROJECT_NAME}}

How to write code in this repo. These are binding for every agent; deviations
are escalations, not judgment calls. Fill each section for your stack; delete
sections that don't apply.

## 1. Language & build settings
<< Language version, strictness/lint flags, the "zero warnings" bar, target
platforms/runtimes. State what "clean build" means precisely. >>

## 2. File & type organization
<< One-type-per-file? Folder-by-feature vs by-layer? Where shared code lives.
Keep it mechanical so agents place files predictably. >>

## 3. Naming
<< Conventions for types, functions, files, tests, constants. Give examples. >>

## 4. Safety
<< The footgun policy: what is forbidden (e.g. force-unwrap, unchecked casts,
swallowed errors, mutable global state) and the safe alternative for each. >>

## 5. Concurrency / async model
<< The concurrency rules: what runs where, how shared state is protected, what
the type system enforces. If N/A, say so. >>

## 6. Persistence rules
<< The invariants every stored model must satisfy (e.g. optionality/defaults,
no forbidden constraints, migration discipline). Apply to EVERY model. >>

## 7. UI rules
<< View-layer conventions: no business logic in views, state ownership,
accessibility baseline, formatting/localization of user-facing strings. >>

## 8. Core purity (the highest-grade code)
<< The rules that keep the authoritative logic pure and deterministic: allowed
imports, injected clock/RNG, no I/O. This is what the golden tests pin. >>

## 9. AI layer rules (delete if no AI)
<< How AI code paths are constrained: outputs are drafts, never authoritative
writes; grounded answers come only from the single source of truth + app data,
never model memory; a kill switch makes the app fully functional with AI off. >>

## 10. Comments & docs
<< When to comment (the "why", not the "what"), doc-comment expectations on
public surface, and the rule that behavior changes update ARCHITECTURE.md in
the same commit. >>

## 11. Formatting
<< The formatter/linter of record and how it runs (also wired into
scripts/project.sh → project_lint). Indentation, line length, import order. >>
