//
//  ContentViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation
import Combine
import Alamofire

class RebalanceProgressViewModel: ObservableObject {
    
    @Published var rebalanceProgress = PortfolioRebalancer.Progress.ready
    
    private var cancelBag = Set<AnyCancellable>()
    private let portfolioRebalancer: PortfolioRebalancer
    private let notificationsManager: NotificationsManager
    private let rebalanceTimer: RebalanceTimer
    var shouldAskForNotificationPermission = false
    
    init(portfolioRebalancer: PortfolioRebalancer = PortfolioRebalancer(), notificationsManager: NotificationsManager = NotificationsManager(), rebalanceTimer: RebalanceTimer = RebalanceTimer.shared) {
        self.portfolioRebalancer = portfolioRebalancer
        self.notificationsManager = notificationsManager
        self.rebalanceTimer = rebalanceTimer
        self.shouldAskForNotificationPermission = !notificationsManager.alreadyAskedForPermission
        
        portfolioRebalancer.$progress.sink { value in
            if value == .done {
                self.rebalanceDone()
            }
            self.rebalanceProgress = value
        }.store(in: &cancelBag)
    }

    func startRebalance() {
        portfolioRebalancer.testBeginRebalance()
    }
    
    private func rebalanceDone() {
        rebalanceTimer.markRebalanceDone()
        notificationsManager.scheduleNotification(on: rebalanceTimer.nextRebalanceDate!)
    }
    
}
