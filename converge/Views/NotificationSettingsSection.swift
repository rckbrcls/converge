//
//  NotificationSettingsSection.swift
//  pomodoro
//

import SwiftUI
import AppKit

struct NotificationSettingsSection: View {
    @ObservedObject private var settings = NotificationSettings.shared
    @State private var currentSound: NSSound?

    var body: some View {
        Section("Notifications") {
            Toggle(isOn: $settings.notificationsEnabled) {
                Label("Enable Notifications", systemImage: "bell.badge.fill")
            }
        }

        Section("Sound Settings") {
            Toggle(isOn: $settings.soundEnabled) {
                Label("Enable Sound", systemImage: "speaker.wave.2.fill")
            }

            if settings.soundEnabled {
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Picker("Sound when Pomodoro ends", selection: $settings.workSoundType) {
                            ForEach(SoundType.allCases) { soundType in
                                Text(soundType.rawValue).tag(soundType)
                            }
                        }
                    } icon: {
                        Image(systemName: "clock.fill")
                    }

                    Button {
                        testSound(soundType: settings.workSoundType)
                    } label: {
                        Label("Test Sound", systemImage: "play.circle")
                    }
                    .font(.caption)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Picker("Sound when Break ends", selection: $settings.breakSoundType) {
                            ForEach(SoundType.allCases) { soundType in
                                Text(soundType.rawValue).tag(soundType)
                            }
                        }
                    } icon: {
                        Image(systemName: "cup.and.saucer.fill")
                    }

                    Button {
                        testSound(soundType: settings.breakSoundType)
                    } label: {
                        Label("Test Sound", systemImage: "play.circle")
                    }
                    .font(.caption)
                }
            }
        }
    }

    private func testSound(soundType: SoundType) {
        guard settings.shouldPlaySound else { return }

        // Stop any currently playing sound
        currentSound?.stop()
        currentSound = nil

        if let soundName = soundType.systemSoundName {
            if let sound = NSSound(named: soundName) {
                currentSound = sound
                sound.play()
            } else {
                // Fallback to beep if sound not found
                NSSound.beep()
            }
        } else {
            // Default sound - use beep
            NSSound.beep()
        }
    }
}
