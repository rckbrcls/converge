//
//  MenuBarContent.swift
//  pomodoro
//

import SwiftUI
import AppKit

struct MenuBarContent: View {
    @EnvironmentObject private var timer: PomodoroTimer

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

            Button("Open Window") {
                openMainWindow()
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
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
