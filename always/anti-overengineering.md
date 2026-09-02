# Anti-Over-Engineering

Only change what was asked. Pick the simplest solution that solves the request. When unsure, ask.

## Avoid

- Editing files or code paths the user did not mention.
- New abstractions, helpers, or dependencies without a concrete need in this task.
- Rewriting whole files for a small fix.
- Error handling for impossible or extremely unlikely cases.
- "While I'm here" refactors, style sweeps, or test additions unless requested.
- Introducing VIPER, TCA, or heavy architecture for a one-screen feature.

## Prefer

- Read surrounding code first. Match naming, types, and patterns already in the repo.
- Inline logic over one-off helpers. Split modules only when duplication is real.
- A focused diff over an architectural cleanup.
- Guard clauses and early returns over deep nesting.

## Before delivery

- Confirm every touched file was requested or clearly required by the change.
- Check whether a smaller approach would work.
- Leave unrelated code and behavior unchanged.
