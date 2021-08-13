//
//  NumberTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/05/2021.
//

import Foundation

class NumberTools {
    
    static func roundDecimals(number: Double, precision: Double, roundDown: Bool = false) -> Double {
        let multiplier = 1 / precision
        if roundDown {
            return Double(floor(number * multiplier) / multiplier)
        } else {
            return Double(round(number * multiplier) / multiplier)
        }
        
    }
    
}
