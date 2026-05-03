# Converge

> **Status:** Active
> This project is currently maintained as a native macOS Pomodoro app.

Pomodoro on Mac. Real focus.

Converge is a native Pomodoro app for macOS built with SwiftUI. Focused on productivity and simplicity, it offers a complete Pomodoro timer with statistics, session history, notifications, and macOS menu bar integration.

## Summary

- Native macOS Pomodoro app for focus timing, session history, statistics, notifications, themes, and menu bar visibility.
- Solves desktop focus tracking with a simple SwiftUI timer workflow and Sparkle-based automatic updates.
- Main stack: SwiftUI, macOS native APIs, Sparkle updates, GitHub releases, and install scripts.
- Current status: active in this checkout, but verify against the primary Converge repository before release work.
- Technical value: demonstrates a small native macOS product with distribution and update concerns documented beside the app.

## Motivation

- Keep focus timing on the Mac, away from phone distractions.
- Provide a simple Pomodoro workflow with enough statistics and history to build awareness.
- Make the timer visible through native macOS surfaces such as the menu bar and compact windows.
- Stay open source and easy to install/update.

## Features

- **Pomodoro Timer**: Configurable work and break cycles with automatic or manual mode
- **Statistics**: Track your productivity with daily, weekly, and monthly counters
- **Session History**: Complete record of all completed sessions
- **Menu Bar Integration**: Timer always visible in the macOS menu bar
- **Notifications**: Alerts and sounds at the end of each phase
- **Themes**: Light, dark, or follow system appearance
- **Automatic Updates**: Stay up to date with automatic updates using Sparkle

## Getting Started

### Installation

Download and install the app:

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash
```

Install a specific version:

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash -s -- --version 1.0.0
```

1. Download the ZIP file from [GitHub Releases](https://github.com/polterware/converge/releases)
2. Extract the ZIP file
3. Move `Converge.app` to your Applications folder
4. Run the app for the first time

**Note**: If the app shows security warnings, right-click on the app and select "Open".

### Requirements

- macOS 26.0 or higher

## Technical Highlights

Converge is an open source project. We believe in transparency, community collaboration, and making productivity tools accessible to everyone. Feel free to explore the code, report issues, or contribute improvements.

## Current Status

This checkout documents the native macOS app, installation flow, Sparkle update path, and GitHub release links. Verify against the primary Converge repository before release work.

- **GitHub**: [https://github.com/polterware/converge](https://github.com/polterware/converge)
- **Issues**: [https://github.com/polterware/converge/issues](https://github.com/polterware/converge/issues)
- **Releases**: [https://github.com/polterware/converge/releases](https://github.com/polterware/converge/releases)

## Roadmap

**Automatic Updates**

Converge supports automatic updates via Sparkle inside the app.

**Manual Updates**

Download the latest version from [GitHub Releases](https://github.com/polterware/converge/releases) and replace the app in your Applications folder.

## Known Limitations

- Requires macOS 26.0 or higher according to this README.
- First launch may require using right-click > Open if macOS Gatekeeper shows a security warning.
- Canonical release status should be confirmed before treating this mirror as the source of truth.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
