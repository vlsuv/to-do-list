//
//  NotificationManager.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NotificationManagerType {
    func sendNotification(with model: Reminder)
    func removeNotification(_ model: Reminder)
}

class NotificationManager: NotificationManagerType {
    
    // MARK: - Properties
    private let userNotificationCenter: UNUserNotificationCenter
    
    // MARK: - Init
    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.userNotificationCenter = notificationCenter
        
        requestNotificationAuthorization()
    }
    
    // MARK: - Input Handlers
    func sendNotification(with model: Reminder) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = model.title
        notificationContent.sound = .default
        
        let calendar = Calendar(identifier: .gregorian)
        
        let dateComponents = calendar.dateComponents([.calendar, .day, .hour, .minute, .month], from: model.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: model.id,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func removeNotification(_ model: Reminder) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [model.id])
    }
}

// MARK: - Notification Helpers
extension NotificationManager {
    private func requestNotificationAuthorization() {
        let authOption = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOption) { succes, error in
            if let error = error {
                print(error)
            }
        }
        
    }
}
