# Converge Documentation

Converge is a native macOS SwiftUI Pomodoro app with local state, menu bar controls, notifications, session history, statistics, and Sparkle updates.

Use these documents when working on this repository:

- [Getting Started](getting-started.md): local setup, repository layout, dependency notes, scripts, and current test caveats.
- [Architecture](architecture.md): app structure, state flow, persistence, notifications, windows, menu bar behavior, and update flow.
- [Deployment](deployment.md): manual GitHub Actions release flow, ZIP packaging, Sparkle appcast updates, installer, and ownership checks.
- Shared macOS playbook (with Sparky): `/Users/erickpatrickbarcelos/codes/docs/macos-desktop-distribution.md`.
- [Security](security.md): sandboxing, update signing, secrets, installer behavior, local data, and release risks.
- [Troubleshooting](troubleshooting.md): practical investigation paths for updates, notifications, installer failures, statistics, windows, and tests.

Documentation intentionally does not include API, database, contribution, or internal module README files because this repository does not currently expose an app-owned API, use a database, define a broad contribution process, or contain standalone subpackages.
