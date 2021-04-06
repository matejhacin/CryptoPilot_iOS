//
//  CoinAllocation.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/04/2021.
//

import Foundation

class CoinAllocation: Identifiable {
    
    let symbol: String
    let marketCap: Double
    
    var ratio: Double?
    
    init(symbol: String, marketCap: Double) {
        self.symbol = symbol
        self.marketCap = marketCap
    }
    
}
