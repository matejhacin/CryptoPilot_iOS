//
//  CoinUtility.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/05/2021.
//

import Foundation

class CoinUtility {
    
    static func isStableCoin(symbol: String) -> Bool {
        return Constants.Coins.STABLE_COINS.contains(symbol)
    }
    
}
