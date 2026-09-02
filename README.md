# Claude iOS Rules

Battle-tested [Claude Code](https://code.claude.com) memory rules for **iOS and macOS** development. SwiftUI, UIKit, App Store shipping, and agent discipline in one install pack.

Same content as [cursor-ios-rules](https://github.com/kkarimz/cursor-ios-rules), formatted for Claude Code's `.claude/rules/` system and `CLAUDE.md` imports.

## What's inside

| Rule | Location | Activation | Purpose |
|------|----------|------------|---------|
| `swiftui.md` | `.claude/rules/` | Path-scoped | MVVM, state, concurrency, previews |
| `uikit-ios.md` | `.claude/rules/` | Path-scoped | Programmatic UIKit, display models, layout |
| `ios-swift-general.md` | `.claude/rules/` | Path-scoped | SPM, XcodeGen, build habits |
| `app-store-shipping.md` | `.claude/rules/` | Path-scoped | Version bumps, screenshots, checklist |
| `app-store-copy.md` | `.claude/rules/` | Path-scoped | Human App Store copy, no AI tells |
| `anti-overengineering.md` | `.claude/always/` | **Always on** (via CLAUDE.md) | Scoped diffs, no architecture theater |
| `agent-honesty.md` | `.claude/always/` | **Always on** (via CLAUDE.md) | Verify APIs, no false "looks good" |
| `agent-efficiency.md` | `.claude/always/` | **Always on** (via CLAUDE.md) | Grep before read, risk-based builds |

Path-scoped rules use Claude's `paths:` frontmatter and load when Claude reads matching files. Always-on rules live in `.claude/always/` and are imported from `CLAUDE.md` so they are not double-loaded from `.claude/rules/`.

## Quick install

### Option A: Global (all projects on this Mac)

```bash
git clone https://github.com/kkarimz/claude-ios-rules.git
claude-ios-rules/install.sh user
```

Installs to `~/.claude/rules/`, `~/.claude/always/`, and merges imports into `~/.claude/CLAUDE.md`.

### Option B: One project (recommended for teams)

```bash
git clone https://github.com/kkarimz/claude-ios-rules.git
cd YourApp
/path/to/claude-ios-rules/install.sh project
```

Copies path-scoped rules to `.claude/rules/`, always-on rules to `.claude/always/`, and creates or updates `CLAUDE.md`. Commit all three with your project.

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

You should see `CLAUDE.md`, files under `.claude/rules/`, and imports from `.claude/always/`. Open a Swift file and ask Claude to edit a view; path-scoped rules like `swiftui.md` should attach when relevant.

## How Claude Code rules work (vs Cursor)

| Cursor | Claude Code |
|--------|-------------|
| `.cursor/rules/*.mdc` | `.claude/rules/*.md` + `.claude/always/*.md` |
| `globs:` + `alwaysApply:` | `paths:` (CSV, single line) + `alwaysApply: false` for lazy load |
| User folder `~/.cursor/rules/` | User folder `~/.claude/` |
| No native CLAUDE.md | `CLAUDE.md` with `@` imports |

**Path frontmatter format** (important):

```yaml
---
alwaysApply: false
paths: **/*View.swift, **/Views/**/*.swift
---
```

Use a **comma-separated line**, not a YAML array. Both `alwaysApply: false` and `paths:` are required for lazy loading on current Claude Code versions.

Files in `.claude/rules/` **without** `paths` load at session start. Always-on rules stay in `.claude/always/` and are pulled in only via `CLAUDE.md` imports.

## Recommended project layout

```
YourApp/
  CLAUDE.md              ← imports from .claude/always/ (install.sh manages this)
  .claude/
    rules/               ← path-scoped rules (5 files)
    always/              ← always-on agent discipline (3 files)
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
2. Copy `always/*.md` to `.claude/always/`.
3. Add to your project `CLAUDE.md`:

```markdown
@.claude/always/anti-overengineering.md
@.claude/always/agent-honesty.md
@.claude/always/agent-efficiency.md
```

## Rule highlights

### SwiftUI

- Views render state; no networking in `body`
- `@Observable` / `@Bindable` when deployment target allows; otherwise `ObservableObject`
- `.task(id:)` over bare `.onAppear`
- `#Preview` for non-trivial views

### App Store shipping

- Bump version in **Info.plist + project.yml + pbxproj** together
- LISTING.md drives What's New
- Privacy manifest and export compliance on checklist
- Never reuse a closed marketing version train

### Agent discipline

- Smallest diff that works
- Verify `Package.swift` and Apple docs before using APIs
- Grep before read; build only what risk requires

## Using both Cursor and Claude Code

Use both tool-specific repos in the same project:

```bash
cursor-ios-rules/install.sh user      # or: install.sh project
claude-ios-rules/install.sh user      # or: install.sh project
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
