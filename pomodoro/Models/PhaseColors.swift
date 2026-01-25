//
//  PhaseColors.swift
//  pomodoro
//

import SwiftUI

struct PhaseColors {
    let background: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    
    static func color(for phase: PomodoroPhase, colorScheme: ColorScheme = .light) -> PhaseColors {
        switch phase {
        case .work:
            return PhaseColors(
                background: colorScheme == .dark 
                    ? Color(red: 0.2, green: 0.1, blue: 0.1)
                    : Color(red: 1.0, green: 0.95, blue: 0.95),
                primary: colorScheme == .dark
                    ? Color(red: 1.0, green: 0.4, blue: 0.4)
                    : Color(red: 0.9, green: 0.2, blue: 0.2),
                secondary: colorScheme == .dark
                    ? Color(red: 0.8, green: 0.3, blue: 0.3)
                    : Color(red: 0.7, green: 0.1, blue: 0.1),
                accent: colorScheme == .dark
                    ? Color(red: 1.0, green: 0.5, blue: 0.5)
                    : Color(red: 0.95, green: 0.3, blue: 0.3)
            )
        case .break:
            return PhaseColors(
                background: colorScheme == .dark
                    ? Color(red: 0.1, green: 0.15, blue: 0.2)
                    : Color(red: 0.95, green: 0.98, blue: 1.0),
                primary: colorScheme == .dark
                    ? Color(red: 0.4, green: 0.7, blue: 1.0)
                    : Color(red: 0.2, green: 0.6, blue: 0.9),
                secondary: colorScheme == .dark
                    ? Color(red: 0.3, green: 0.6, blue: 0.9)
                    : Color(red: 0.1, green: 0.5, blue: 0.8),
                accent: colorScheme == .dark
                    ? Color(red: 0.5, green: 0.75, blue: 1.0)
                    : Color(red: 0.3, green: 0.65, blue: 0.95)
            )
        case .idle:
            return PhaseColors(
                background: colorScheme == .dark
                    ? Color(red: 0.1, green: 0.1, blue: 0.1)
                    : Color(red: 0.98, green: 0.98, blue: 0.98),
                primary: colorScheme == .dark
                    ? Color(red: 0.7, green: 0.7, blue: 0.7)
                    : Color(red: 0.3, green: 0.3, blue: 0.3),
                secondary: colorScheme == .dark
                    ? Color(red: 0.5, green: 0.5, blue: 0.5)
                    : Color(red: 0.5, green: 0.5, blue: 0.5),
                accent: colorScheme == .dark
                    ? Color(red: 0.8, green: 0.8, blue: 0.8)
                    : Color(red: 0.4, green: 0.4, blue: 0.4)
            )
        }
    }
}
