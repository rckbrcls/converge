# Getting Started

This guide covers local orientation for the Converge macOS app. Setup is intentionally Xcode-centered, so a separate setup guide is not needed.

## Prerequisites

- macOS.
- Xcode with macOS app development support.
- Python 3 for the installer and appcast scripts.
- Network access when resolving Sparkle, GitHub release metadata, or Sparkle tooling.

The app target currently declares `MACOSX_DEPLOYMENT_TARGET = 26.0` in `converge.xcodeproj/project.pbxproj`. Project-level settings include macOS 26.2, and `Package.swift` declares macOS 11 only for the dependency-management package.

## Open the Project

Open `converge.xcodeproj` in Xcode.

The app source is under `converge/`. The app target, unit test target, UI test target, signing settings, deployment target, entitlements, and Sparkle package product are defined in the Xcode project.

## Dependency Model

`Package.swift` is not the application build definition. It is a Swift Package Manager manifest used to centralize dependency resolution for Sparkle.

The package contains one dummy target:

```text
Sources/ConvergeDependencies/Dependencies.swift
```

Sparkle is pinned in both root `Package.resolved` and the Xcode workspace package resolution file.

## Development Map

Start with these files:

- `converge/convergeApp.swift` for app scenes, commands, menu bar setup, and environment object wiring.
- `converge/Services/PomodoroTimer.swift` for phase timing and transitions.
- `converge/Services/StatisticsStore.swift` for completed session persistence and counters.
- `converge/Services/NotificationManager.swift` for notifications and sounds.
- `converge/Services/UpdateManager.swift` for Sparkle integration.
- `converge/Views/SettingsView.swift` for settings and destructive actions.
- `converge/Views/PomodoroView.swift`, `StatisticsView.swift`, and `SessionHistoryView.swift` for the main tabs.

## Local Data

The app persists state in `UserDefaults`, not a database:

- Timer settings.
- Notification and sound settings.
- Theme selection.
- Welcome modal state.
- Completed Pomodoro sessions.

To debug unexpected state, inspect the relevant model or service before changing views.

## Scripts

The repository includes three scripts:

```bash
scripts/install.sh [--version <version>]
scripts/update_appcast.py --help
SPARKLE_TOOLS_VERSION=2.8.1 scripts/generate-sparkle-keys.sh
```

- `scripts/install.sh` queries GitHub Releases, selects a ZIP asset, extracts the `.app`, installs it to `/Applications` or `$HOME/Applications`, and removes quarantine metadata when possible.
- `scripts/update_appcast.py` updates `appcast.xml` with Sparkle release metadata.
- `scripts/generate-sparkle-keys.sh` downloads Sparkle tools if needed and exports EdDSA keys under `keys/`, which is ignored by Git.

## Tests

The repository has:

- `convergeTests/` using Swift Testing.
- `convergeUITests/` using XCTest.

No command-line build or test command was verified during this documentation refresh. The current unit test in `convergeTests/convergeTests.swift` appears stale because it calls `PomodoroTimer()` while the implementation currently requires `PomodoroTimer(settings:)`.

Use Xcode to review and repair the test targets before relying on them.

## Development Constraints

- Keep app-facing strings in English unless the project intentionally adds localization.
- Treat `converge.xcodeproj` as the source of truth for app target settings.
- Do not document a database, backend API, or web deployment unless those systems are added to the repository.
