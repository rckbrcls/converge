//
//  SettingsView.swift
//  pomodoro
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: PomodoroSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var workDuration: Int
    @State private var shortBreakDuration: Int
    @State private var longBreakDuration: Int
    @State private var pomodorosUntilLongBreak: Int
    @State private var showVisualSettings = false
    
    init() {
        // Initialize with default values, will be updated from environmentObject
        _workDuration = State(initialValue: 25)
        _shortBreakDuration = State(initialValue: 5)
        _longBreakDuration = State(initialValue: 15)
        _pomodorosUntilLongBreak = State(initialValue: 4)
    }
    
    var body: some View {
        Form {
            Section("Work Duration") {
                Stepper(
                    value: $workDuration,
                    in: 1...120,
                    step: 1
                ) {
                    HStack {
                        Text("Minutes")
                        Spacer()
                        Text("\(workDuration) min")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Short Break Duration") {
                Stepper(
                    value: $shortBreakDuration,
                    in: 1...60,
                    step: 1
                ) {
                    HStack {
                        Text("Minutes")
                        Spacer()
                        Text("\(shortBreakDuration) min")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Long Break Duration") {
                Stepper(
                    value: $longBreakDuration,
                    in: 1...120,
                    step: 1
                ) {
                    HStack {
                        Text("Minutes")
                        Spacer()
                        Text("\(longBreakDuration) min")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Pomodoros Until Long Break") {
                Stepper(
                    value: $pomodorosUntilLongBreak,
                    in: 1...20,
                    step: 1
                ) {
                    HStack {
                        Text("Count")
                        Spacer()
                        Text("\(pomodorosUntilLongBreak)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Visual Settings") {
                Button {
                    showVisualSettings = true
                } label: {
                    HStack {
                        Text("Appearance")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }

            NotificationSettingsSection()

            Section {
                Button("Reset to Defaults") {
                    resetToDefaults()
                }
                .foregroundStyle(.red)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveSettings()
                }
                .fontWeight(.semibold)
            }
        }
        .onAppear {
            loadCurrentSettings()
        }
        .sheet(isPresented: $showVisualSettings) {
            NavigationStack {
                VisualSettingsView()
            }
        }
    }
    
    private func loadCurrentSettings() {
        workDuration = settings.workDurationMinutes
        shortBreakDuration = settings.shortBreakDurationMinutes
        longBreakDuration = settings.longBreakDurationMinutes
        pomodorosUntilLongBreak = settings.pomodorosUntilLongBreak
    }
    
    private func saveSettings() {
        settings.workDurationMinutes = workDuration
        settings.shortBreakDurationMinutes = shortBreakDuration
        settings.longBreakDurationMinutes = longBreakDuration
        settings.pomodorosUntilLongBreak = pomodorosUntilLongBreak
        dismiss()
    }
    
    private func resetToDefaults() {
        settings.resetToDefaults()
        loadCurrentSettings()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(PomodoroSettings())
        }
    }
}
