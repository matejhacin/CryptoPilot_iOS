//
//  RebalanceProgress.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 04/08/2021.
//

import Foundation

indirect enum RebalanceProgress: Equatable {
    case failed(Error, RebalanceProgress)
    case ready
    case gettingLatestValues
    case executingSellOrders
    case updatingUserPortfolio
    case executingBuyOrders
    case done
    
    var stepNumber: Int {
        get {
            switch self {
            case .failed:
                return -1
            case .ready:
                return 0
            case .gettingLatestValues:
                return 1
            case .executingSellOrders:
                return 2
            case .updatingUserPortfolio:
                return 3
            case .executingBuyOrders:
                return 4
            case .done:
                return 5
            }
        }
    }
    
    static func == (lhs: RebalanceProgress, rhs: RebalanceProgress) -> Bool {
        switch (lhs, rhs) {
        case (.failed, .failed):
            return true
        case (.ready, .ready):
            return true
        case (.gettingLatestValues, .gettingLatestValues):
            return true
        case (.executingSellOrders, .executingSellOrders):
            return true
        case (.updatingUserPortfolio, .updatingUserPortfolio):
            return true
        case (.executingBuyOrders, .executingBuyOrders):
            return true
        case (.done, .done):
            return true
        default:
            return false
        }
    }
}
