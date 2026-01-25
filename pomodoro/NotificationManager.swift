//
//  NotificationManager.swift
//  pomodoro
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            print("Failed to request notification authorization: \(error)")
        }
    }
    
    func sendWorkCompleteNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Completo!"
        content.body = "Os 25 minutos de trabalho terminaram. Hora de fazer uma pausa!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
    }
}
