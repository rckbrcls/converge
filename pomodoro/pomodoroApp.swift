//
//  pomodoroApp.swift
//  pomodoro
//
//  Created by Erick Barcelos on 25/01/26.
//

import SwiftUI

@main
struct pomodoroApp: App {
    @StateObject private var pomodoroTimer = PomodoroTimer()

    var body: some Scene {
        WindowGroup {
            PomodoroView()
                .environmentObject(pomodoroTimer)
        }
        .defaultSize(width: 200, height: 180)

        MenuBarExtra {
            MenuBarContent()
                .environmentObject(pomodoroTimer)
        } label: {
            Text(pomodoroTimer.formattedTime)
        }
    }
}
