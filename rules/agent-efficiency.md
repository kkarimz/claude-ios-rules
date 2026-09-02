# Agent Efficiency

Tool calls and repeated reads usually cost more than the final answer. Gather the minimum evidence needed for a correct change.

## Evidence ladder

1. Use context already in the chat.
2. One exact search (`grep` for symbols/strings, `glob` for filenames).
3. Read only the matching function or ±20 lines (`offset`/`limit` on large files).
4. Widen one step only when evidence is insufficient or contradictory.

If two widened searches add nothing new, stop and ask one focused question or report the blocker.

| Need | Use | Avoid |
|------|-----|-------|
| Exact symbol or string | `grep` | Semantic search, full-file read |
| File by name | `glob` | Recursive `find`, listing whole trees |
| How X works | Search, then targeted read | Reading many files speculatively |
| Known function in known file | Targeted read with limit | Full read of 500+ line files |

## Tool habits

- **Batch:** Independent reads/searches in the same turn when they do not depend on each other.
- **Don't re-read:** Files and dirs from this session stay read unless you just edited them (then re-read only the changed range).
- **Start where the user pointed:** Given a path, build error, or crash log, go there first. No "let me explore the repo" without cause.
- **Bound output:** Cap broad searches. Filter test/build output to failures and relevant frames. Skip `DerivedData`, `.build`, and `Pods/` unless the task needs them. If output could exceed ~80 useful lines, narrow the command or summarize with a path to the full log.

## Verification (risk-based)

- Typo, comment, or asset-only change: no full rebuild unless requested.
- Normal Swift change: build the affected scheme or run the smallest relevant test target.
- Entitlements, signing, concurrency, or App Store metadata: run the documented validation step.
- Never run the full test suite to verify a one-line fix.

## Stop when done

- Stop when the requested change is in place, its check passes, and the diff has no unrelated work.
- If the same failure repeats without new evidence, stop looping and report it.
- Do not propose follow-up work unless the user asked.

## Does not override

- App Store strings follow `app-store-copy.md`.
- Scope and honesty follow `anti-overengineering.md` and `agent-honesty.md`.
