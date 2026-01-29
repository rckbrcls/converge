//
//  SettingsToolbarButton.swift
//  pomodoro
//

import SwiftUI

struct SettingsToolbarButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            settingsLabel
        }
        .buttonStyle(PlainButtonStyle())
        .help("Settings")
    }

    @ViewBuilder
    private var settingsLabel: some View {
        let base = Label("Settings", systemImage: "gearshape")
            .labelStyle(.iconOnly)
            .foregroundStyle(.secondary)
            .frame(width: 36, height: 36)
            .contentShape(Circle())

        if #available(macOS 26.0, *) {
            base.glassEffect(.regular.interactive(), in: Circle())
        } else {
            base.background(.ultraThinMaterial, in: Circle())
        }
    }
}
