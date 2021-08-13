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
    @Published var showErrorDialog = false
    
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
        
        portfolioRebalancer.$progress
            .receive(on: DispatchQueue.main)
            .sink { value in
                print(value)
                self.rebalanceProgress = value
                if value == .executingSellOrders {
                    Haptics.shared.play(.light)
                } else if value == .updatingUserPortfolio {
                    Haptics.shared.play(.light)
                } else if value == .executingBuyOrders {
                    Haptics.shared.play(.light)
                } else if value == .done {
                    Haptics.shared.notify(.success)
                    self.showWarningsDialogIfNeeded()
                    self.rebalanceDone()
                } else if self.isProgressFailed {
                    Haptics.shared.notify(.error)
                    self.showErrorDialog = true
                }
            }.store(in: &cancelBag)
    }
    
    func startRebalance() {
        portfolioRebalancer.beginRebalance()
    }
    
    func getStepState(for step: Int) -> StepState {
        if case .failed(_, let lastProgress) = rebalanceProgress {
            if step < lastProgress.stepNumber {
                return .finished
            } else if step == lastProgress.stepNumber {
                return .failed
            } else {
                return .notStarted
            }
        } else if step < rebalanceProgress.stepNumber || step == RebalanceProgress.done.stepNumber && rebalanceProgress == .done {
            return .finished
        } else if step == rebalanceProgress.stepNumber {
            return .inProgress
        } else {
            return .notStarted
        }
    }
    
    var isProgressFailed: Bool {
        return rebalanceProgress.isFailed
    }
    
    func getErrorMessage() -> String {
        if case .failed(let error, _) = rebalanceProgress {
            return "Rebalance failed due to the following error:\n\n\(error.localizedDescription)"
        } else if portfolioRebalancer.nonFatalErrors.count > 0 {
            var warningMessage = "Rebalance finished with the following issues:\n"
            for error in portfolioRebalancer.nonFatalErrors {
                warningMessage += "\n• \(error.localizedDescription)"
            }
            return warningMessage
        } else {
            return "Rebalance stopped due to unknown error"
        }
    }
    
    private func rebalanceDone() {
        rebalanceTimer.markRebalanceDone()
        notificationsManager.scheduleNotification(on: rebalanceTimer.nextRebalanceDate!)
    }
    
    private func showWarningsDialogIfNeeded() {
        showErrorDialog = portfolioRebalancer.nonFatalErrors.count > 0
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
