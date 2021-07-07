//
//  MainNavigationViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/07/2021.
//

import Foundation

class MainNavigationViewModel: ObservableObject {
    
    @Published var rebalanceAvailable: Bool
    
    init(rebalanceTimer: RebalanceTimer = RebalanceTimer.shared) {
        rebalanceAvailable = rebalanceTimer.rebalanceAllowed
        $rebalanceAvailable = rebalanceTimer.$rebalanceAllowed
    }
    
}
