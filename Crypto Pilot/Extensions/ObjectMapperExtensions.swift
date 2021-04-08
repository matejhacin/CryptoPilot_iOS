//
//  ObjectMapperExtensions.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation

extension CMCCoinData {
    func mapToCoinAllocation() -> CoinAllocation {
        return CoinAllocation(symbol: symbol, marketCap: quote.usd.marketCap)
    }
}

extension CMCListings {
    func mapToCoinAllocations() -> [CoinAllocation] {
        var allocations = [CoinAllocation]()
        for coinData in self.data {
            allocations.append(coinData.mapToCoinAllocation())
        }
        return allocations
    }
}
