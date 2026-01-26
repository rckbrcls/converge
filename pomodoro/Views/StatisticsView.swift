//
//  StatisticsView.swift
//  pomodoro
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject private var store: StatisticsStore
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    countersSection
                    chartSection
                }
                .padding(24)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }

    private var countersSection: some View {
        HStack(spacing: 32) {
            StatCounter(label: "Today", value: store.pomodorosToday)
            StatCounter(label: "Week", value: store.pomodorosThisWeek)
            StatCounter(label: "Month", value: store.pomodorosThisMonth)
        }
        .frame(maxWidth: .infinity)
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Productivity (last 14 days)")
                .font(.headline)
            Chart(store.chartData(days: 14)) { point in
                BarMark(
                    x: .value("Date", point.date),
                    y: .value("Pomodoros", point.count)
                )
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }
        }
    }
}

private struct StatCounter: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
    }
}

#if DEBUG
#Preview {
    StatisticsView()
        .environmentObject(StatisticsStore.shared)
        .environmentObject(PomodoroSettings())
        .environmentObject(ThemeSettings())
}
#endif
