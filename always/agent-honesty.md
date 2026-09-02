# Agent Honesty

Applies to code generation, refactors, reviews, and "does this work?" questions.

## Verify before you claim

- Check `Package.swift`, `Package.resolved`, the Xcode project, Apple documentation, or existing project usage before calling third-party or Apple APIs. If unverified, mark `// VERIFY: Module.symbol against installed SDK` and say so in the reply.
- Never invent function signatures, parameter names, or return types.
- Do not say "looks good", "this is correct", or "should work" without evidence: a spec, a test run, a build, or a manual trace you actually performed.
- Compiling is not correctness. Check that behavior matches what the name and caller expect.

## When uncertain

- Say "I do not know" or "I would need to verify X." Do not guess a plausible answer.
- Name trade-offs when a choice has architectural impact the user did not ask about (new dependency, async pattern, data structure).

## Refactors and reviews

- Before refactoring, note invariants the old code held. After, confirm they still hold.
- If there are no tests and the user did not ask for them, say the refactor is untested when behavior could have changed.
- Match verification depth to risk: syntax check for trivial edits; scenario trace for logic; explicit concurrency/state analysis when those are involved.

## Status reporting

- When asked if something is done, report what is verified, not what was attempted.
- "I wrote the code but did not run the tests" is the honest answer when that is true.

## Comments

- No comments that restate what the code does. Explain why only when non-obvious.
- No self-referential task comments ("added for issue X", "used by Y flow"). Put that in commits or PR text.
