//
//  PortfolioAllocationTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/04/2021.
//

import Foundation

class PortfolioAllocationTools {
    
    static func calculateTop20Allocations(emptyAllocations: [CoinAllocation]) -> [CoinAllocation] {
        var allocations = emptyAllocations
        let totalCap = calculateTotalMarketCap(allocations)
        
        allocations.forEach { allocation in
            allocation.ratio = allocation.marketCap / totalCap
        }
        
        for i in 0...allocations.count - 1 {
            let allocation = allocations[i]
            if allocation.ratio! > 0.1 {
                let overflow = allocation.ratio! - 0.1
                allocation.ratio = 0.1
                let remainingAllocations = Array(allocations.dropFirst(i + 1))
                let totalNestedCap = calculateTotalMarketCap(remainingAllocations)
                var newAllocations = [CoinAllocation]()
                
                remainingAllocations.forEach { remainingAllocation in
                    let capFraction = remainingAllocation.marketCap / totalNestedCap
                    remainingAllocation.ratio! += overflow * capFraction
                    newAllocations.append(remainingAllocation)
                }
                
                print("break")
                
                allocations = Array(allocations.dropLast(allocations.count - (i + 1)))
                allocations.append(contentsOf: newAllocations)
                
                print("break")
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
