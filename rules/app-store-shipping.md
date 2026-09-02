---
alwaysApply: false
paths: **/Info.plist, **/project.yml, **/*.pbxproj, **/*.entitlements, **/LISTING.md, **/docs/app-store/**, **/fastlane/**
---

# App Store shipping (iOS and macOS)

Use when preparing a build for TestFlight or App Store Connect.

## Version bumps (check all three)

Apple rejects uploads when marketing version or build number is wrong or stale. Update every source of truth:

1. **`Info.plist`** (or generated `info.properties` in XcodeGen): `CFBundleShortVersionString` (marketing, e.g. `1.1`) and `CFBundleVersion` (build, e.g. `2`).
2. **`project.yml`** (XcodeGen): same keys under target `info.properties`.
3. **`project.pbxproj`**: `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` if not fully generated.

Increment **build** for every upload. Increment **marketing version** when the train closes or you ship user-visible features.

## Listing copy

- Keep **`LISTING.md`** (or equivalent) as the source of truth for description, keywords, promotional text, and What's New.
- Paste What's New from LISTING into App Store Connect; do not invent copy in chat without updating the file.
- Follow the **app-store-copy** rule for App Store strings.

## Screenshots

- Match Apple's required sizes for the target platform (iPhone, iPad, Mac, Apple Watch as applicable).
- Store sources and exports in a documented folder (e.g. `docs/screenshots/`).
- Regenerate derived sizes from source captures when dimensions change; do not upscale small images.

## Pre-upload checklist

- Archive with the correct scheme and signing team.
- Validate entitlements match capabilities in Connect (iCloud, push, etc.).
- Confirm privacy manifest (`PrivacyInfo.xcprivacy`) and usage description strings if the app accesses protected APIs.
- Set export compliance correctly (many apps: no custom encryption beyond HTTPS).
- Run the app on the minimum supported OS version once before submission.

## Do not

- Bump only one of plist / yml / pbxproj and leave the others stale.
- Reuse a marketing version Apple already approved on a closed train.
- Hand-edit production Connect metadata without syncing LISTING.md in the repo.
