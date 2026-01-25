//
//  SessionHistoryView.swift
//  pomodoro
//

import SwiftUI

struct SessionHistoryView: View {
    @EnvironmentObject private var store: StatisticsStore

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        List {
            ForEach(store.recentSessions(limit: 50)) { session in
                HStack {
                    Text(Self.dateFormatter.string(from: session.completedAt))
                    Spacer()
                    Text(durationLabel(session.durationSeconds))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .background(.ultraThinMaterial)
    }

    private func durationLabel(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes) min"
    }
}

#Preview {
    SessionHistoryView()
        .environmentObject(StatisticsStore.shared)
}
