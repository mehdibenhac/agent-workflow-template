# ARCHITECTURE.md — {{PROJECT_NAME}}

> System design of record. Keep this in sync with the code — architecture drift
> (this doc says one thing, the code does another) is a defect, fixed in the
> same change. Fill each section; delete guidance notes as you go.

## 1. Design goals

<< 3–6 bullets: the properties the architecture optimizes for (e.g.
testability, offline-first, a hard AI/authority boundary, no server). These are
the "why" behind the rules in §3–4. >>

## 2. Layer diagram

```
<< ASCII sketch of the layers and the allowed direction of dependencies.
Make illegal dependencies visually obvious. Example:

  UI  ──▶  ViewModels ──▶  Core (pure logic)   ◀── the authority
                     └──▶  Persistence  ──▶  storage
  (UI never imports Core internals directly; Core imports nothing app-specific)
>>
```

## 3. Module responsibilities

### 3.1 Core / pure logic (the authority)
<< The modules that own the real computation. State the purity contract: what
they may import, what they must never do (I/O, framework, randomness, clock
access except injected). This is the highest-tested layer. >>

### 3.2 ViewModels / controllers
<< What owns presentation state and orchestration. What they may and may not
contain (no business rules — those live in Core). >>

### 3.3 Persistence
<< The storage model and its invariants. If you have platform constraints
(e.g. sync rules), state them here and enforce them on every model. >>

### 3.4 Data model
<< The entities and their relationships. Keep authoritative. >>

### 3.5 External services / integrations
<< APIs, notifications, background work — each with its boundary. >>

## 4. The most important boundary in the system

<< Every project has one line that, if crossed, breaks the design's core
promise. Name it explicitly and describe how it is enforced (types, module
structure, review, tests). For an AI-assisted app this is the
"AI proposes / app disposes" line: the AI never writes authoritative state. >>

## 5. Data flow examples

<< Walk 1–2 representative flows end to end (a user action, a background event)
so an agent can trace how the layers cooperate. >>

## 6. Error-handling policy

<< How errors surface and propagate. What is recoverable vs. fatal. The
project's footgun policy (e.g. no force-unwraps / no swallowed exceptions). >>

## 7. Testing architecture (summary — see TESTING_GUIDELINES.md)

<< The one-paragraph version: what's unit-tested vs. integration vs. manual,
and where the golden/reference values live. >>

## 8. Decisions

The *why* behind significant, contested, or hard-to-reverse choices lives in
**`docs/adr/`** as Architecture Decision Records — see `docs/adr/README.md` for
the index. This section stays a pointer, not a second copy: when you make such a
decision, write an ADR and (optionally) note the one-liner here. Routine choices
don't need an ADR.
