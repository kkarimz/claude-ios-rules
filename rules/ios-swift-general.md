---
alwaysApply: false
paths: **/*.swift, **/Package.swift, **/Package.resolved, **/project.yml, **/*.pbxproj, **/*.entitlements
---

# iOS / Swift (general)

Match the repo's existing toolchain. Do not upgrade Swift, Xcode, or deployment targets unless asked.

When SwiftUI or UIKit rules also apply to a file, follow those for view-layer code. This rule covers project wiring, models, services, and build config.

## Project layout

- **SPM:** Dependencies in `Package.swift`. Prefer local packages for shared modules.
- **XcodeGen:** If `project.yml` exists, edit YAML and run `xcodegen generate`; do not hand-edit `project.pbxproj` unless the project has no generator.
- **Plain Xcode:** Edit the project through Xcode or documented scripts; keep `pbxproj` diffs minimal.

## Swift habits

- Respect `@MainActor` for UI-bound types. Offload heavy work with `Task` or background actors.
- Prefer `async/await` over completion handlers in new code when the deployment target allows.
- Use `Sendable` and isolation correctly when strict concurrency is enabled.
- Prefer value types and `Codable` for models. Keep reference types for shared mutable state only when needed.

## Dependencies

- Check `Package.resolved` or the lockfile before adding or bumping packages.
- Do not add CocoaPods or Carthage to an SPM-only project without explicit approval.
- One dependency should solve one problem. No kitchen-sink utility libraries for a single call site.

## Build and run

- Build with `xcodebuild` or the project's documented script. Include scheme and destination when running from CLI.
- For simulator: use a concrete destination (`platform=iOS Simulator,name=iPhone 16`) not "latest device" guesses.
- After changing entitlements, Info.plist keys, or capabilities, mention that a clean build or re-sign may be needed.

## Avoid

- Force-unwrapping in production paths without a documented invariant.
- Global singletons for testable services.
- `#available` branches that leave older OS paths broken or untested.
- Committing `DerivedData`, `.build`, or user-specific `xcuserdata`.

## Prefer

- Protocol-based services injected at composition root.
- Feature flags or build settings over compile-time `#if DEBUG` hacks in shipping code.
- Asset catalogs and semantic colors over hardcoded RGB in views.
