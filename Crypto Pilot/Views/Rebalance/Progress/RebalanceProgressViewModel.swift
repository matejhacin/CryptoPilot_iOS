//
//  ContentViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class RebalanceProgressViewModel: ObservableObject {
    
    @Published var rebalanceProgress = RebalanceProgress.ready
    
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
    
    // This function is fucking with my head as it never sets the step states right after one fails.
    // Take a break and write this simple IF statements with a clear head..
    func getStepState(for step: Int) -> StepState {
        if rebalanceProgress.stepNumber > step {
            return .finished
        } else if rebalanceProgress.stepNumber < step && rebalanceProgress.stepNumber != -1 {
            return .notStarted
        } else if case .failed(_, let lastProgress) = rebalanceProgress, lastProgress.stepNumber == step {
            return .failed
        } else if rebalanceProgress.stepNumber == step && step != RebalanceProgress.done.stepNumber {
            return .inProgress
        }
        return .finished
    }
    
    private func rebalanceDone() {
        rebalanceTimer.markRebalanceDone()
        notificationsManager.scheduleNotification(on: rebalanceTimer.nextRebalanceDate!)
    }
    
    enum StepState {
        case notStarted
        case inProgress
        case finished
        case failed
        
        var color: Color {
            switch self {
            case .notStarted:
                return Color.gray()
            case .inProgress:
                return Color.blue()
            case .finished:
                return Color.green()
            case .failed:
                return Color.red()
            }
        }
    }
    
}
