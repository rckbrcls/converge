# Troubleshooting

Use this guide to find the owner of common Converge issues before changing UI code.

## Sparkle Updates Do Not Appear

Start with:

- `converge/Services/UpdateManager.swift`
- `converge/Info.plist`
- `appcast.xml`
- `.github/workflows/release.yml`

Check that:

- Sparkle is available through the Xcode package dependency.
- `UpdateManager.canCheckForUpdates` is true.
- `SUFeedURL` matches the feed returned by `UpdateManager`.
- `SUPublicEDKey` matches the private key used by the release workflow.
- The appcast item points to an existing ZIP asset.
- The ZIP asset length and Sparkle EdDSA signature are current.

Also verify the repository ownership mismatch: this checkout's remote points to `rckbrcls/converge`, while release configuration references `polterware/converge`.

## Notifications Do Not Fire

Start with:

- `converge/Services/NotificationManager.swift`
- `converge/Models/NotificationSettings.swift`
- macOS notification permission settings for Converge.

Check that:

- The app requested notification authorization during initialization.
- `notificationsEnabled` is true.
- The current timer phase actually completed.
- The notification delegate is initialized.
- macOS Focus modes or notification settings are not suppressing banners.

Sounds are played separately with `NSSound`, so a missing banner and a missing sound may have different causes.

## Sounds Do Not Play

Start with:

- `converge/Models/NotificationSettings.swift`
- `converge/Services/NotificationManager.swift`
- `converge/Views/NotificationSettingsSection.swift`

Check that:

- `soundEnabled` is true.
- The selected `SoundType` maps to an available `NSSound` name.
- The app can play the fallback system beep.

## Timer State Looks Wrong

Start with:

- `converge/Services/PomodoroTimer.swift`
- `converge/Models/PomodoroSettings.swift`
- `converge/Views/PomodoroView.swift`

Check that:

- The timer was initialized with the same `PomodoroSettings` instance used by the views.
- The timer is not paused in manual-next-phase mode.
- `autoContinue` matches the expected behavior.
- Settings changes are only expected to reset remaining time while the timer is idle.

## Statistics or History Are Missing

Start with:

- `converge/Services/StatisticsStore.swift`
- `converge/Models/PomodoroSession.swift`
- `converge/Views/StatisticsView.swift`
- `converge/Views/SessionHistoryView.swift`

Check that:

- Work phases completed normally.
- `recordCompletedPomodoro(durationSeconds:)` was called.
- `pomodoro_sessions` exists in `UserDefaults`.
- History was not cleared from Settings.
- The selected history filter includes the session date.

`StatisticsStore` keeps only the 500 most recent sessions.

## Settings Reset or Clear History Seems Unexpected

Start with `converge/Views/SettingsView.swift`.

Reset to defaults changes timer settings, theme settings, and notification settings. Clear history deletes all session history and derived statistics through `StatisticsStore.clearAll()`.

Both actions are destructive from the user's perspective.

## Window or Menu Bar Actions Open Duplicate Windows

Start with:

- `converge/convergeApp.swift`
- `converge/Services/WindowManager.swift`
- `converge/Views/MenuBarContent.swift`

Check that:

- Window IDs are still `main` and `converge-settings`.
- Settings windows keep the title `Converge Settings`.
- Existing windows are found before `openWindow(id:)` is called.
- App activation happens before window ordering.

## Installer Fails

Start with `scripts/install.sh`.

Common causes:

- Python 3 is missing.
- GitHub release metadata cannot be fetched.
- The selected release has no `.zip` asset.
- The asset size does not match GitHub metadata.
- The archive does not contain an `.app` bundle.
- `/Applications` is not writable and `$HOME/Applications` cannot be created.
- The hosted install endpoint does not match the local script.

## Tests Do Not Compile

Start with `convergeTests/convergeTests.swift`.

The current unit test appears stale because it calls:

```swift
PomodoroTimer()
```

The current implementation requires:

```swift
PomodoroTimer(settings: PomodoroSettings())
```

Review the unit test target in Xcode before relying on test results.
