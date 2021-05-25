//
//  NumberTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/05/2021.
//

import Foundation

class NumberTools {
    
    static func roundDecimals(number: Double, precision: Double) -> Double {
        let multiplier = 1 / precision
        return Double(round(number * multiplier) / multiplier)
    }
    
}
