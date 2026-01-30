//
//  WelcomeModalView.swift
//  converge
//

import SwiftUI

struct WelcomeModalView: View {
    var onDismiss: () -> Void
    @EnvironmentObject private var themeSettings: ThemeSettings
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 8)

            Image(systemName: "desktopcomputer")
                .font(.system(size: 32))
                .foregroundColor(colors.primary)

            VStack(spacing: 6) {
                Text("Welcome to Converge")
                    .font(.headline.bold())
                    .foregroundColor(colors.primary)

                Text("Pomodoro on Mac. Real focus.")
                    .font(.subheadline)
                    .foregroundColor(colors.secondary)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    bulletPoint("Converge was purposefully made for Mac.")
                    bulletPoint("Keeping your phone away is part of the design.")
                    bulletPoint("The mere presence of a smartphone reduces cognitive capacity — even when it's off.")
                    bulletPoint("With the timer on your Mac, you don't need your phone on the desk.")
                    bulletPoint("Leave it in another room and focus.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal, 8)

            Spacer(minLength: 8)

            Button {
                onDismiss()
            } label: {
                Label("Get Started", systemImage: "arrow.right")
                    .labelStyle(.titleAndIcon)
                    .font(.subheadline)
            }
            .buttonStyle(RoundedBorderedProminentButtonStyle(color: colors.accent))
            .padding(.bottom, 32)
        }
        .padding(32)
        .frame(minWidth: 360, minHeight: 400)
        .background(colors.background)
    }

    private var effectiveColorScheme: ColorScheme {
        themeSettings.currentColorScheme ?? systemColorScheme
    }

    private var colors: PhaseColors {
        PhaseColors.color(for: .idle, colorScheme: effectiveColorScheme, isRunning: true)
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.subheadline)
                .foregroundColor(colors.secondary)
            Text(text)
                .font(.subheadline)
                .foregroundColor(colors.secondary)
                .multilineTextAlignment(.leading)
        }
    }
}
