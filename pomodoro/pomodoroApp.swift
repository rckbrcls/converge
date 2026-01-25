//
//  pomodoroApp.swift
//  pomodoro
//
//  Created by Erick Barcelos on 25/01/26.
//

import SwiftUI

@main
struct pomodoroApp: App {
    @StateObject private var pomodoroSettings: PomodoroSettings
    @StateObject private var pomodoroTimer: PomodoroTimer
    @StateObject private var themeSettings: ThemeSettings

    init() {
        let settings = PomodoroSettings()
        _pomodoroSettings = StateObject(wrappedValue: settings)
        _pomodoroTimer = StateObject(wrappedValue: PomodoroTimer(settings: settings))
        _themeSettings = StateObject(wrappedValue: ThemeSettings())
        
        Task {
            await NotificationManager.shared.requestAuthorization()
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                PomodoroView()
                    .tabItem { Label("Timer", systemImage: "timer") }
                StatisticsView()
                    .tabItem { Label("Statistics", systemImage: "chart.bar") }
                SessionHistoryView()
                    .tabItem { Label("History", systemImage: "list.bullet") }
            }
            .environmentObject(pomodoroTimer)
            .environmentObject(pomodoroSettings)
            .environmentObject(themeSettings)
            .environmentObject(StatisticsStore.shared)
            .preferredColorScheme(themeSettings.currentColorScheme)
        }
        .windowResizability(.automatic)
        .defaultSize(width: 400, height: 500)

        MenuBarExtra {
            MenuBarContent()
                .environmentObject(pomodoroTimer)
                .environmentObject(pomodoroSettings)
                .environmentObject(themeSettings)
                .environmentObject(StatisticsStore.shared)
        } label: {
            Text(pomodoroTimer.formattedTime)
        }
    }
}
