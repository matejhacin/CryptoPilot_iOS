//
//  CoinBalance.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/04/2021.
//

import Foundation

class CoinBalance {
    
    let asset: String
    let free: Double
    let locked: Double
    let pricePerUnitUSD: Double
    let pricePerUnitBTC: Double
    
    var ratio: Double?
    
    init(symbol: String, free: Double, locked: Double, priceUsd: Double, priceBTC: Double) {
        self.asset = symbol
        self.free = free
        self.locked = locked
        self.pricePerUnitUSD = priceUsd
        self.pricePerUnitBTC = priceBTC
    }
    
    var valueUSD: Double {
        get {
            return free * pricePerUnitUSD
        }
    }
    
    var valueBTC: Double {
        get {
            return free * pricePerUnitBTC
        }
    }
    
}
