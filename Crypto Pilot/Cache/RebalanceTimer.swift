//
//  RebalanceTimer.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 03/07/2021.
//

import Foundation

class RebalanceTimer {
    
    static let shared = RebalanceTimer()
    
    @Published var rebalanceAllowed = true
    
    init() {
        updateRebalanceAllowed()
    }
    
    var lastRebalanceDate: Date? {
        get {
            UserDefaults.standard.value(forKey: Constants.UserDefaults.LAST_REBALANCE_DATE) as? Date
        }
    }
    
    var nextRebalanceDate: Date? {
        get {
            if let lastDate = lastRebalanceDate {
                return calculateNextDate(from: lastDate)
            }
            return nil
        }
    }
    
    var daysSinceLastRebalance: Int? {
        get {
            if let date = lastRebalanceDate {
                return Calendar.current.dateComponents([.day], from: date, to: Date()).day
            }
            return nil
        }
    }
    
    func markRebalanceDone() {
        UserDefaults.standard.setValue(Date(), forKey: Constants.UserDefaults.LAST_REBALANCE_DATE)
        updateRebalanceAllowed()
    }
    
    private func calculateNextDate(from date: Date) -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: Constants.AppSettings.REBALANCE_PERIOD, to: date)!
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.year = calendar.component(.year, from: nextDate)
        dateComponents.month = calendar.component(.month, from: nextDate)
        dateComponents.day = calendar.component(.day, from: nextDate)
        dateComponents.hour = 8
        dateComponents.minute = 0
        return dateComponents.date!
    }
    
    private func updateRebalanceAllowed() {
        if let days = daysSinceLastRebalance {
            let isAllowed = days >= Constants.AppSettings.REBALANCE_PERIOD
            rebalanceAllowed = isAllowed
        } else {
            rebalanceAllowed = true
        }
    }
    
}
