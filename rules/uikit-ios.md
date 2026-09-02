---
alwaysApply: false
paths: **/*ViewController.swift, **/*ViewController+*.swift, **/ios/**/*.swift, **/UIKit/**/*.swift
---

# UIKit (iOS)

Expert Swift and UIKit. Programmatic UI only. No storyboards or xibs unless the project already uses them.

## Layout

- Prefer **SnapKit** when the project already uses it. Otherwise use `NSLayoutConstraint` or stack views.
- Support **Safe Area** and **Dynamic Type**.
- Use stack views and compositional layout when they simplify the code.

## Architecture

- **UIView subclasses render state.** No networking, persistence, or service calls in views.
- Do not pass raw DTOs or domain models into views. Pass **display models** or **view models**.
- View controllers (or coordinators) own wiring. Factories/builders are fine when they reduce duplication.

Good:

```swift
let model = UserDisplayModel(name: user.name, email: user.email)
let userView = UserView(model: model)
```

Avoid:

```swift
let userView = UserView(user: user) // leaks domain model into the view layer
```

## Events

- Pass events with **closures** or **delegates**.
- When multiple instances exist, pass the sender: `var didTap: ((MyView) -> Void)?` and call `didTap?(self)`.
- Use `[weak self]` in escaping closures when the closure can outlive the view.

## Modern UIKit

- Prefer diffable data sources and compositional layout when the deployment target allows.
- Use semantic colors and test in light and dark mode.
- Set accessibility labels and support VoiceOver for interactive controls.

## Code style

- Short, clear descriptions in new code. Do not delete existing comments unless they are wrong or obsolete.
- UI updates on the **main thread** only.

## Not for SwiftUI or macOS

This rule applies to UIKit iOS work only. For SwiftUI or macOS apps, follow the project's existing patterns instead.
