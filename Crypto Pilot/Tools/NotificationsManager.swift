//
//  NotificationsManager.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 03/07/2021.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    var alreadyAskedForPermission: Bool {
        set(value) {
            UserDefaults.standard.setValue(value, forKey: Constants.UserDefaults.NOTIFICATION_PERMISSION_ASKED)
        }
        get {
            UserDefaults.standard.bool(forKey: Constants.UserDefaults.NOTIFICATION_PERMISSION_ASKED)
        }
    }
    
    func requestPermission(finish: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            self.alreadyAskedForPermission = true
            finish(granted)
        }
    }
    
    func scheduleNotification(on date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Time to rebalance!"
        content.body = "Your crypto portfolio is ready for rebalance. Let Crypto Pilot do its' magic!"
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.calendar = calendar
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            // Do nothing for now
            // Possibly implement error handling later
        }
    }
    
}
