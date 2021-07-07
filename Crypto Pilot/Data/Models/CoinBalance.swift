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
    var percentChange24H: Double?
    
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
    
    var ratioPrettyText: String? {
        get {
            guard let ratio = ratio else { return nil }
            var fixedRatio = (ratio * 100)
            fixedRatio = NumberTools.roundDecimals(number: fixedRatio, precision: 0.01)
            return "\(fixedRatio)%"
        }
    }
    
    var valueUSDPrettyText: String {
        get {
            let roundedValue = NumberTools.roundDecimals(number: valueUSD, precision: 0.01)
            return "$\(roundedValue)"
        }
    }
    
    var pricePerUnitUSDPrettyText: String {
        get {
            let roundedValue = NumberTools.roundDecimals(number: pricePerUnitUSD, precision: 0.01)
            return "$\(roundedValue)"
        }
    }
    
    var percentChange24HPrettyText: String? {
        get {
            guard let percentChange = percentChange24H else { return nil }
            let prefix = percentChange > 0 ? "+" : "-"
            let roundedValue = NumberTools.roundDecimals(number: percentChange, precision: 0.01)
            return "\(prefix)\(roundedValue)%"
        }
    }
    
    var imageUrl: String {
        return "https://cryptoicons.org/api/icon/\(asset.lowercased())/200"
    }
    
}
