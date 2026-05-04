# Converge

Converge is a native macOS Pomodoro app built with SwiftUI. It keeps focus timing on the Mac through a compact timer workflow, menu bar visibility, local statistics, session history, notifications, and Sparkle-based updates.

This repository is a medium-sized single macOS app. It is not a web app, backend service, API, database application, monorepo, or reusable library.

## Features

- Configurable Pomodoro timer with work, short break, and long break phases.
- Automatic or manual phase continuation.
- Menu bar timer with quick start, pause, reset, window, settings, update, and quit actions.
- Statistics counters for today, this week, and this month.
- Session history grouped by day with time range filters.
- Local history chart for the last 14 days using Swift Charts.
- Notification banners and configurable system sounds for work and break completion.
- Light, dark, and system appearance modes.
- Main, settings, compact, zoomed, and fullscreen window behavior using SwiftUI and AppKit.
- Sparkle integration for automatic updates.
- Installer script that downloads release ZIP assets from GitHub Releases.

## Technology Stack

- SwiftUI for the app interface and scene structure.
- AppKit for window management, menu bar activation, visual effects, and system sounds.
- Combine for timer ticks and observable state propagation.
- UserNotifications for macOS notification permission and delivery.
- Swift Charts for statistics visualization.
- Sparkle 2.8.1 for update checks and appcast-based update delivery.
- Xcode project targets for the app, unit tests, and UI tests.
- Swift Package Manager only for centralized dependency management.
- GitHub Actions for release packaging, Sparkle signing, GitHub Releases, and GitHub Pages appcast publishing.

## Project Structure

```text
.
|-- converge.xcodeproj/              # Xcode project and app/test targets
|-- converge/
|   |-- convergeApp.swift            # SwiftUI app entry point and scene wiring
|   |-- Models/                      # Timer, notification, theme, phase, and session models
|   |-- Services/                    # Timer, statistics, notifications, windows, compact mode, updates
|   |-- Views/                       # Timer, settings, statistics, history, menu bar, and shared controls
|   |-- Assets.xcassets/             # App icon and accent color assets
|   |-- Info.plist                   # Bundle metadata and Sparkle public configuration
|   `-- Converge.entitlements        # Sandbox and network client entitlements
|-- convergeTests/                   # Swift Testing unit target
|-- convergeUITests/                 # XCTest UI target
|-- Sources/ConvergeDependencies/    # Dummy package target for Sparkle dependency resolution
|-- scripts/
|   |-- install.sh                   # GitHub Releases installer
|   |-- update_appcast.py            # Sparkle appcast updater used by CI
|   `-- generate-sparkle-keys.sh     # Local helper for Sparkle EdDSA keys
|-- .github/workflows/release.yml    # Manual release workflow
|-- appcast.xml                      # Sparkle update feed
|-- Package.swift                    # Dependency manifest, not the app build definition
`-- docs/                            # Focused project documentation
```

## Requirements

- macOS for development and runtime.
- Xcode with macOS app development support.
- Swift Package Manager dependency resolution through Xcode.
- Python 3 for `scripts/install.sh` and `scripts/update_appcast.py`.
- Network access when downloading release assets, Sparkle tools, or GitHub release metadata.

The app target currently declares `MACOSX_DEPLOYMENT_TARGET = 26.0` in `converge.xcodeproj/project.pbxproj`. Project-level settings also include macOS 26.2, while `Package.swift` declares `.macOS(.v11)` only for the dependency-management package. Treat the Xcode app target as the runtime requirement source of truth.

## Installation

Install the latest GitHub Release through the hosted installer endpoint:

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash
```

Install a specific release version:

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash -s -- --version 1.0.0
```

The installer downloads release metadata from GitHub, selects a ZIP asset, extracts the `.app`, and copies it to `/Applications` when writable. If `/Applications` is not writable, it installs to `$HOME/Applications`.

Manual installation is also supported:

1. Download a Converge ZIP asset from GitHub Releases.
2. Extract the archive.
3. Move `Converge.app` to `/Applications` or `$HOME/Applications`.
4. Open the app from Finder.

If macOS blocks the first launch, use Finder's right-click > Open flow. The installer also attempts to remove the quarantine attribute from the copied app bundle.

## Local Development

Open `converge.xcodeproj` in Xcode and use the `converge` scheme for app development. The app target is defined in the Xcode project, not in `Package.swift`.

`Package.swift` exists to pin Sparkle as a dependency through a dummy `ConvergeDependencies` target. The application source lives under `converge/`.

Important app state is injected through SwiftUI environment objects in `converge/convergeApp.swift`:

- `PomodoroSettings`
- `PomodoroTimer`
- `ThemeSettings`
- `StatisticsStore.shared`

## Runtime Data

Converge stores local app data with `UserDefaults`.

- Timer settings are stored by `converge/Models/PomodoroSettings.swift`.
- Notification preferences are stored by `converge/Models/NotificationSettings.swift`.
- Theme selection is stored by `converge/Models/ThemeSettings.swift`.
- Welcome modal state is stored with `@AppStorage("hasSeenWelcomeModal")`.
- Completed sessions are encoded by `converge/Services/StatisticsStore.swift` under the `pomodoro_sessions` key.

`StatisticsStore` keeps at most 500 completed sessions.

## Available Scripts

| Script | Purpose |
| --- | --- |
| `scripts/install.sh` | Downloads and installs the latest or selected GitHub Release ZIP asset. |
| `scripts/update_appcast.py` | Adds or updates a Sparkle release item in `appcast.xml`. |
| `scripts/generate-sparkle-keys.sh` | Downloads Sparkle tools if needed and generates/exports EdDSA update keys. |

## Testing Status

The repository includes `convergeTests/` and `convergeUITests/`.

No command-line build or test command was verified during this documentation refresh. The current unit test in `convergeTests/convergeTests.swift` appears stale because it calls `PomodoroTimer()` while `converge/Services/PomodoroTimer.swift` currently initializes with `PomodoroTimer(settings:)`.

Use Xcode to inspect and repair the test targets before treating them as a reliable validation suite.

## Release and Updates

Releases are modeled in `.github/workflows/release.yml` as a manual GitHub Actions workflow. The workflow builds a Release app bundle, packages `Converge-macos-universal-v{version}.zip`, signs the update archive with Sparkle EdDSA metadata, updates `appcast.xml`, creates a GitHub Release, and publishes the appcast through GitHub Pages.

Sparkle is configured in two places:

- `converge/Info.plist` includes `SUFeedURL` and `SUPublicEDKey`.
- `converge/Services/UpdateManager.swift` returns the appcast URL to Sparkle.

Important release caveat: this checkout's Git remote points to `rckbrcls/converge`, while the workflow, appcast, installer, and README release links reference `polterware/converge`. Verify the canonical repository owner before release work.

See [docs/deployment.md](docs/deployment.md) and [docs/security.md](docs/security.md) before publishing updates.

## Documentation

- [Documentation index](docs/index.md)
- [Getting started](docs/getting-started.md)
- [Architecture](docs/architecture.md)
- [Deployment](docs/deployment.md)
- [Security](docs/security.md)
- [Troubleshooting](docs/troubleshooting.md)

## Current Status

Converge is active in this checkout as a native macOS Pomodoro app. The product surface is implemented locally; release ownership and test health should be verified before distribution work.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
