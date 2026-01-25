//
//  NotificationSettingsView.swift
//  pomodoro
//

import SwiftUI
import AppKit

struct NotificationSettingsView: View {
    @StateObject private var settings = NotificationSettings.shared
    
    var body: some View {
        Form {
            Section("Sound Settings") {
                Toggle("Enable Sound", isOn: $settings.soundEnabled)
                
                if settings.soundEnabled {
                    Toggle("Silent Mode", isOn: $settings.silentMode)
                        .help("When enabled, notifications will be sent without sound")
                    
                    Picker("Sound Type", selection: $settings.soundType) {
                        ForEach(SoundType.allCases) { soundType in
                            Text(soundType.rawValue).tag(soundType)
                        }
                    }
                    
                    Button("Test Sound") {
                        testSound()
                    }
                    .disabled(settings.silentMode)
                }
            }
            
            Section {
                Text("Notifications will appear when:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("Work session completes", systemImage: "checkmark.circle")
                    Label("Break session completes", systemImage: "checkmark.circle")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 300)
    }
    
    private func testSound() {
        guard settings.shouldPlaySound else { return }
        
        // Play system sound
        if let soundName = settings.soundType.systemSoundName {
            NSSound(named: soundName)?.play()
        } else {
            NSSound.beep()
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
