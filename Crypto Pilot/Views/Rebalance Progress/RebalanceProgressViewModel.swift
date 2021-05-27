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
    private let portfolioRebalancer = PortfolioRebalancer()
    
    init() {
        portfolioRebalancer.$progress.sink { value in
            print("\(value) -> \(value.rawValue)")
            self.rebalanceProgress = value
        }.store(in: &cancelBag)
    }

    func startRebalance() {
        portfolioRebalancer.testBeginRebalance()
    }
    
}
