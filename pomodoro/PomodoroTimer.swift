//
//  PomodoroTimer.swift
//  pomodoro
//

import Foundation
import Combine

enum PomodoroPhase: String {
    case idle
    case work
    case `break`
}

@MainActor
final class PomodoroTimer: ObservableObject {
    static let workDurationSeconds = 25 * 60
    static let breakDurationSeconds = 5 * 60

    @Published private(set) var remainingSeconds: Int
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var phase: PomodoroPhase = .idle

    private var timerCancellable: AnyCancellable?

    var formattedTime: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    init() {
        self.remainingSeconds = Self.workDurationSeconds
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        if phase == .idle {
            phase = .work
            remainingSeconds = Self.workDurationSeconds
        }

        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.tick()
                }
            }
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func reset() {
        pause()
        phase = .idle
        remainingSeconds = Self.workDurationSeconds
    }

    private func tick() {
        guard isRunning else { return }
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        } else {
            advanceToNextPhase()
        }
    }

    private func advanceToNextPhase() {
        switch phase {
        case .work:
            phase = .break
            remainingSeconds = Self.breakDurationSeconds
        case .break:
            phase = .work
            remainingSeconds = Self.workDurationSeconds
        case .idle:
            phase = .work
            remainingSeconds = Self.workDurationSeconds
        }
    }
}
