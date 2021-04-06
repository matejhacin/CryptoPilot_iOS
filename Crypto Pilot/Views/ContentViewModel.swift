//
//  ContentViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    private var api: Api
    
    @Published var allocations = [CoinAllocation]()
    
    init(api: Api = Api()) {
        self.api = api
    }
    
    func getListings() {
        api.getListings(count: 20) { cmcListings, error in
            self.allocations = PortfolioAllocationTools.calculateTop20Allocations(emptyAllocations: cmcListings!.mapToCoinAllocations())
        }
    }
    
}
