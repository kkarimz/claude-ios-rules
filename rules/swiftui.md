---
alwaysApply: false
paths: **/Views/**/*.swift, **/*View.swift, **/*App.swift, **/*Screen.swift
---

# SwiftUI (iOS and macOS)

Senior SwiftUI engineer. Prefer simple, maintainable code over architecture theater.

Match the **project's deployment target and Swift version**. Do not force Swift 6 or iOS 17 APIs unless the target already uses them.

## Architecture

- Default: **MVVM** or straightforward state in the view for small features.
- Use coordinators/navigation stacks only when flows are genuinely complex.
- **Views render state.** No networking, persistence, or service calls directly in `body`.
- Prefer **protocol injection** for testable services. `@EnvironmentObject` is fine for app-wide settings, not a junk drawer.
- Pass **display models** into child views, not raw domain/DTO types, when the shape differs from UI needs.

## SwiftUI practices

- **Composition:** Keep `body` readable. Extract subviews or `@ViewBuilder` helpers when a view grows past ~50 lines or mixes layout with logic.
- **Layout:** Avoid `GeometryReader` unless needed. Prefer `Layout`, alignment guides, or `.background(GeometryReader { ... })`.
- **Lists:** Use `LazyVStack` / `LazyHStack` / `List` appropriately. Stable `id` values, not `\.self` on models that are not `Hashable`.
- **Taps:** Add `.contentShape(Rectangle())` on tappable rows with transparent backgrounds.
- **Animation:** Prefer `.animation(_:value:)` tied to explicit state. Use `TimelineView` for clock-like updates, not `Timer` in `body`.
- **Lifecycle:** Prefer `.task(id:)` over bare `.onAppear` for async work that should cancel on disappear.

## State

- `@State` — local value-type UI state owned by this view.
- `@StateObject` — only where the view **creates** the observable object.
- `@ObservedObject` / `@Bindable` — child views that observe but do not own.
- `@Environment` — system values and narrowly scoped app dependencies.

## Concurrency

- UI on **MainActor**. Annotate view models `@MainActor` when they drive UI.
- Use `actor` or isolated services for shared mutable state when concurrency is enabled.
- Never block the main thread. Move heavy work off the main actor.
- In escaping closures that capture `self`, use `[weak self]` when lifecycle is unclear.

## Style

- Clear names (`fetchDocument` over `load`).
- Use `// MARK: -` sections and `private extension` for helpers.
- Add `#Preview` with mock data when adding non-trivial views.
- Do not delete existing comments unless they are wrong or obsolete.

## Testing (when tests exist)

- Unit tests: Given-When-Then.
- Mock via protocols, not concrete singletons.
- Set `accessibilityIdentifier` on elements targeted by UI tests.

## When this rule does not apply

- **UIKit** view controllers and `UIView` subclasses (see `uikit-ios.md`).
- **AppKit** `NSViewRepresentable` internals: follow existing bridge patterns in the repo.
- Small macOS utility apps: keep diffs minimal; do not introduce coordinators, VIPER, or extra layers without cause.

## Response habits

- Prefer focused diffs over full-file rewrites.
- Briefly note tradeoffs when performance, concurrency, or structure matter.
