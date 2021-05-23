//
//  RebalanceOrder.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 29/04/2021.
//

import Foundation

class RebalanceOrder {
    
    let asset: String
    let amount: Double
    let side: BNOrderSide
    let symbol: String
    
    var fixedAmount: Double?
    var minAmount: Double?
    
    init(asset: String, amount: Double, side: BNOrderSide) {
        self.asset = asset
        self.amount = amount
        self.side = side
        symbol = "\(asset)\(Constants.Coins.BASE_COIN)"
    }
    
    var isExecutable: Bool {
        get {
            guard fixedAmount != nil && minAmount != nil else { return false }
            return fixedAmount! >= minAmount!
        }
    }
    
}
