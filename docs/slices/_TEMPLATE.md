---
slice:                    # integer — must match the NNNN in the filename
title:
depends_on: []            # slice numbers this requires (usually just the prior slice)
checkpoint: false         # true = ⚑ owner-only verification before this slice can close
---

# Slice <N> — <title>

**Goal:** one sentence — the increment this slice delivers, end to end.
**Preconditions:** the slices/state that must be green first (prose; ties to
`depends_on`).
**Tasks:** the concrete files/changes, at their paths. Small and ordered.
**Tests:** the named tests this slice adds, and what each asserts.
**Gate:** the exact single command that proves this slice green.
**Acceptance:** the checkable bar — what must be true to call it done.

<< For ⚑ checkpoint slices, also add:
**Human verification:** the exact steps the owner runs to confirm what automated
tests can't (device behavior, external integration, real-money action). >>
