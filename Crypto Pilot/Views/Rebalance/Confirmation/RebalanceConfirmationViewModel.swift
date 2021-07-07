//
//  RebalanceConfirmationViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 03/07/2021.
//

import Foundation

class RebalanceConfirmationViewModel: ObservableObject {
    
    @Published var lastRebalanceDateText: String = "/"
    @Published var nextRebalanceDateText: String = "/"
    @Published var countdownText: String? = nil
    @Published var rebalanceAllowed: Bool = false
    
    private let rebalanceTimer: RebalanceTimer
    
    init(rebalanceTimer: RebalanceTimer = RebalanceTimer.shared) {
        self.rebalanceTimer = rebalanceTimer
        setValues()
    }
    
    private func setValues() {
        // Dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let lastRebalanceDate = rebalanceTimer.lastRebalanceDate {
            lastRebalanceDateText = dateFormatter.string(from: lastRebalanceDate)
        }
        if let nextRebalanceDate = rebalanceTimer.nextRebalanceDate {
            nextRebalanceDateText = dateFormatter.string(from: nextRebalanceDate)
        }
        // Countdown text
        let rebalancePeriod = Constants.AppSettings.REBALANCE_PERIOD
        if let daysSinceLastRebalance = rebalanceTimer.daysSinceLastRebalance {
            let diff = rebalancePeriod - daysSinceLastRebalance
            if diff >= 0 {
                countdownText = "in \(diff) days"
            } else {
                countdownText = "rebalance now available"
            }
        } else {
            if rebalanceTimer.rebalanceAllowed {
                countdownText = "rebalance now available"
            } else {
                countdownText = "rebalance not available"
            }
        }
        // Rebalance allowed flag
        rebalanceAllowed = rebalanceTimer.rebalanceAllowed
    }
    
}
