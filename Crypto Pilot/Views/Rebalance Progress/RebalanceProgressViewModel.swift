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
    
    @Published var allocations = [CoinAllocation]()
    
    private let portfolioRebalancer = PortfolioRebalancer()
    
    init() {
        
    }

    func startRebalance() {
        portfolioRebalancer.beginRebalance()
    }
    
}
