//
//  PortfolioAllocationTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/04/2021.
//

import Foundation

class PortfolioAllocationTools {
    
    static func calculateTop20Allocations(coinsToAllocate: [CoinAllocation]) -> [CoinAllocation] {
        let maxAllocationRatio = 0.1 // 10%
        var allocations = coinsToAllocate
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
        
        return allocations
    }
    
    static func calculateTotalMarketCap(_ allocations: [CoinAllocation]) -> Double {
        var sum = 0.0
        for allocation in allocations {
            sum += allocation.marketCap
        }
        return sum
    }
    
}
