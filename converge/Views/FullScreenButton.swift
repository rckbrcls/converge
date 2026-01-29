//
//  FullScreenButton.swift
//  converge
//

import SwiftUI

struct FullScreenButton: View {
    @StateObject private var windowObserver = WindowObserver()

    private var iconName: String {
        windowObserver.isFullScreen ? "arrow.down.right.and.arrow.up.left.rectangle" : "arrow.up.left.and.arrow.down.right.rectangle"
    }

    private var helpText: String {
        windowObserver.isFullScreen ? "Exit full screen" : "Enter full screen"
    }

    var body: some View {
        Button {
            CompactWindowService.toggleFullScreen()
        } label: {
            fullScreenLabel
        }
        .buttonStyle(PlainButtonStyle())
        .help(helpText)
        .animation(.easeInOut, value: iconName)
        .transition(.opacity)
    }

    @ViewBuilder
    private var fullScreenLabel: some View {
        Image(systemName: iconName)
            .foregroundStyle(.secondary)
            .frame(width: 36, height: 36)
            .contentShape(Circle())
            .glassEffect()
    }
}
