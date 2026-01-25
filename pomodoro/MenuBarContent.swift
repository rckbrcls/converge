//
//  MenuBarContent.swift
//  pomodoro
//

import SwiftUI
import AppKit

struct MenuBarContent: View {
    @EnvironmentObject private var timer: PomodoroTimer
    @EnvironmentObject private var store: StatisticsStore
    @State private var showNotificationSettings = false
    @State private var showPomodoroSettings = false

    var body: some View {
        Group {
            Button(timer.isRunning ? "Pause" : "Start") {
                if timer.isRunning {
                    timer.pause()
                } else {
                    timer.start()
                }
            }

            Button("Reset") {
                timer.reset()
            }

            Divider()

            Text("Today: \(store.pomodorosToday) · Week: \(store.pomodorosThisWeek) · Month: \(store.pomodorosThisMonth)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Open Window") {
                openMainWindow()
            }
            
            Button("Pomodoro Settings...") {
                showPomodoroSettings = true
            }
            
            Button("Notification Settings...") {
                showNotificationSettings = true
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .sheet(isPresented: $showNotificationSettings) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showPomodoroSettings) {
            NavigationStack {
                SettingsView()
            }
        }
    }

    private func openMainWindow() {
        NSApp.activate(ignoringOtherApps: true)
        for window in NSApp.windows where window.canBecomeMain && window.isVisible {
            window.makeKeyAndOrderFront(nil)
            break
        }
    }
}
