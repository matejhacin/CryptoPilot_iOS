//
//  PortfolioAllocationTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/04/2021.
//

import Foundation

class PortfolioAllocationTools {
    
    private let allocationCount: Int
    private let excludeStablecoins: Bool
    
    init(allocationCount: Int, excludeStablecoins: Bool) {
        self.allocationCount = allocationCount
        self.excludeStablecoins = excludeStablecoins
    }
    
    func calculateAllocations(coinsToAllocate: [CoinAllocation]) throws -> [CoinAllocation] {
        // Filter allocations to remove unwanted ones
        var allocations = filterCoins(foundIn: coinsToAllocate)
        
        guard allocations.count == allocationCount else {
            throw AllocationError.invalidCoinCount
        }
        
        let maxAllocationRatio = 0.1 // 10%
        let totalCap = calculateTotalMarketCap(allocations)
        
        // Calculate market cap ratio for each coin
        allocations.forEach { allocation in
            allocation.ratio = allocation.marketCap / totalCap
        }
        
        // Loop through coins and allocate redundant ratio when it exceeds the max
        for i in 0...allocations.count - 1 {
            let allocation = allocations[i]
            if allocation.ratio! > maxAllocationRatio {
                let overflow = allocation.ratio! - maxAllocationRatio
                allocation.ratio = maxAllocationRatio
                let remainingAllocations = Array(allocations.dropFirst(i + 1))
                let totalNestedCap = calculateTotalMarketCap(remainingAllocations)
                var newAllocations = [CoinAllocation]()
                
                remainingAllocations.forEach { remainingAllocation in
                    let capFraction = remainingAllocation.marketCap / totalNestedCap
                    remainingAllocation.ratio! += overflow * capFraction
                    newAllocations.append(remainingAllocation)
                }
                
                allocations = Array(allocations.dropLast(allocations.count - (i + 1)))
                allocations.append(contentsOf: newAllocations)
            }
        }
        
        if allocations.count != allocationCount {
            throw AllocationError.miscalculation
        }
        
        return allocations
    }
    
    func calculateTotalMarketCap(_ allocations: [CoinAllocation]) -> Double {
        var sum = 0.0
        for allocation in allocations {
            sum += allocation.marketCap
        }
        return sum
    }
    
    func filterCoins(foundIn allocations: [CoinAllocation]) -> [CoinAllocation] {
        // Exclude stablecoins
        var filtered = allocations.filter({ !isStableCoin(symbol: $0.asset) })
        
        // Remove redundant coins
        if filtered.count > allocationCount {
            let alpha = filtered.count - allocationCount
            filtered = filtered.dropLast(alpha)
        }
        
        return filtered
    }
    
    func isStableCoin(symbol: String) -> Bool {
        return Constants.Coins.STABLE_COINS.contains(symbol)
    }
    
    // MARK: Error Enum
    
    enum AllocationError: Error {
        case invalidCoinCount
        case miscalculation
    }
    
}
