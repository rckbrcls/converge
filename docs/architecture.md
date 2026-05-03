# Architecture

## Overview

Converge is a native macOS Pomodoro app built with SwiftUI. It combines a timer service, statistics persistence, session history, notification handling, menu bar UI, compact windows, and Sparkle updates.

## Components

- `converge/convergeApp.swift`: SwiftUI app entry point.
- `converge/Models/`: timer settings, notification settings, themes, colors, and session records.
- `converge/Services/`: timer engine, statistics store, notifications, windows, compact window behavior, and updates.
- `converge/Views/`: Pomodoro screen, settings, statistics, history, menu bar content, and reusable controls.
- `convergeTests/` and `convergeUITests/`: test targets.

## Data Flow

1. The app boots from `convergeApp.swift`.
2. `PomodoroTimer` owns phase timing and session transitions.
3. Views observe service/model state and render the timer, settings, history, and statistics.
4. `NotificationManager` emits phase alerts.
5. `StatisticsStore` records completed sessions.
6. `UpdateManager` integrates Sparkle update behavior.

## Trade-offs

- The app is intentionally native, which gives access to menu bar and window APIs.
- Sparkle adds update capability but introduces release-signing and feed responsibilities.
