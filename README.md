# Claude iOS Rules

Battle-tested [Claude Code](https://code.claude.com) memory rules for **iOS and macOS** development. SwiftUI, UIKit, App Store shipping, and agent discipline in one install pack.

Same content as [cursor-ios-rules](https://github.com/kkarimz/cursor-ios-rules), formatted for Claude Code's `.claude/rules/` system and `CLAUDE.md` imports.

## What's inside

| Rule | Activation | Purpose |
|------|------------|---------|
| `swiftui.md` | Path-scoped (SwiftUI files) | MVVM, state, concurrency, previews |
| `uikit-ios.md` | Path-scoped (UIKit files) | Programmatic UIKit, display models, layout |
| `ios-swift-general.md` | Path-scoped (Swift, Xcode project files) | SPM, XcodeGen, build habits |
| `app-store-shipping.md` | Path-scoped (plist, LISTING, app-store docs) | Version bumps, screenshots, checklist |
| `app-store-copy.md` | Path-scoped (listing / strings) | Human App Store copy, no AI tells |
| `anti-overengineering.md` | **Always on** (via CLAUDE.md) | Scoped diffs, no architecture theater |
| `agent-honesty.md` | **Always on** (via CLAUDE.md) | Verify APIs, no false "looks good" |
| `agent-efficiency.md` | **Always on** (via CLAUDE.md) | Grep before read, risk-based builds |

Path-scoped rules use Claude's `paths:` frontmatter and load when Claude reads matching files. The three agent rules are imported from `CLAUDE.md` every session.

## Quick install

### Option A: One project (recommended for teams)

```bash
git clone https://github.com/kkarimz/claude-ios-rules.git
cd YourApp
/path/to/claude-ios-rules/install.sh project
```

This copies rules to `YourApp/.claude/rules/` and creates or updates `CLAUDE.md` with `@` imports for the always-on rules. Commit both with your project.

### Option B: Global (all projects on this Mac)

```bash
git clone https://github.com/kkarimz/claude-ios-rules.git
claude-ios-rules/install.sh user
```

Installs to `~/.claude/rules/` and merges imports into `~/.claude/CLAUDE.md`.

### Option C: Submodule + symlink

```bash
git submodule add https://github.com/kkarimz/claude-ios-rules.git .claude/claude-ios-rules
./.claude/claude-ios-rules/install.sh link
```

## Verify rules loaded

In Claude Code, run:

```
/memory
```

You should see `CLAUDE.md` and files under `.claude/rules/`. Open a Swift file and ask Claude to edit a view; path-scoped rules like `swiftui.md` should attach when relevant.

## How Claude Code rules work (vs Cursor)

| Cursor | Claude Code |
|--------|-------------|
| `.cursor/rules/*.mdc` | `.claude/rules/*.md` |
| `globs:` + `alwaysApply:` | `paths:` (CSV, single line) + `alwaysApply: false` for lazy load |
| User folder `~/.cursor/rules/` | User folder `~/.claude/rules/` + `~/.claude/CLAUDE.md` |
| No native CLAUDE.md | `CLAUDE.md` at project root with `@` imports |

**Path frontmatter format** (important):

```yaml
---
alwaysApply: false
paths: **/*View.swift, **/Views/**/*.swift
---
```

Use a **comma-separated line**, not a YAML array. Both `alwaysApply: false` and `paths:` are required for lazy loading on current Claude Code versions.

Rules with **no `paths` field** load at session start. We import the three agent discipline rules via `CLAUDE.md` instead to keep path-scoped rules lazy.

## Recommended project layout

```
YourApp/
  CLAUDE.md              ← imports always-on rules (install.sh manages this)
  .claude/
    rules/               ← all rule files from this repo
  docs/
    app-store/
      LISTING.md         ← source of truth for App Store copy
```

## Token budget

- **Always-on:** only the three rules imported in `CLAUDE.md` (~120 lines).
- **Path-scoped:** load when Claude touches matching files.
- Long sessions: start a fresh session or use `/compact` when context fills up.
- Keep `CLAUDE.md` short; put long conventions in `.claude/rules/` files.

## Manual install

If you prefer not to run the script:

1. Copy `rules/*.md` to `.claude/rules/`.
2. Add to your project `CLAUDE.md`:

```markdown
@.claude/rules/anti-overengineering.md
@.claude/rules/agent-honesty.md
@.claude/rules/agent-efficiency.md
```

## Rule highlights

### SwiftUI

- Views render state; no networking in `body`
- `.task(id:)` over bare `.onAppear`
- `#Preview` for non-trivial views

### App Store shipping

- Bump version in **Info.plist + project.yml + pbxproj** together
- LISTING.md drives What's New
- Never reuse a closed marketing version train

### Agent discipline

- Smallest diff that works
- Verify `Package.swift` before using third-party APIs
- Grep before read; build only what risk requires

## Using both Cursor and Claude Code

Use both tool-specific repos in the same project:

```bash
cursor-ios-rules/install.sh project    # → .cursor/rules/
claude-ios-rules/install.sh project    # → .claude/rules/ + CLAUDE.md
```

Keep rule content in sync by updating both repos or scripting a copy step.

## Contributing

PRs welcome for Tuist/fastlane paths, watchOS/tvOS/visionOS globs, and tighter rules.

One concern per file. Path-scoped rules must use CSV `paths:` with `alwaysApply: false`.

## License

MIT. See [LICENSE](LICENSE).

## Related

- [Claude Code memory docs](https://code.claude.com/docs/en/memory)
- [cursor-ios-rules](https://github.com/kkarimz/cursor-ios-rules) (Cursor equivalent)

---

**Not affiliated with Apple or Anthropic.** Rules from real app shipping workflows. Adjust for your team.
