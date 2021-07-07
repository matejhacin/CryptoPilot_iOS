//
//  PortfolioValue.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/07/2021.
//

import Foundation

// Used for remembering the last portfolio value, so we can display it next time user opens the app
struct PortfolioValue: Codable {
    let value: Double
    let timestamp: Date
    
    var valuePrettyText: String {
        get {
            let rounded = NumberTools.roundDecimals(number: value, precision: 0.01)
            return "$\(rounded)"
        }
    }
}

class PortfolioValueRepository {
    
    func savePortfolioValue(_ value: Double) {
        let newValue = PortfolioValue(value: value, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(newValue) {
            UserDefaults.standard.set(encoded, forKey: "PortfolioValue")
        }
    }
    
    func getPortfolioValue() -> PortfolioValue {
        if let data = UserDefaults.standard.object(forKey: "PortfolioValue") as? Data {
            if let portfolioValue = try? JSONDecoder().decode(PortfolioValue.self, from: data) {
                return portfolioValue
            }
        }
        return PortfolioValue(value: 0.0, timestamp: Date())
    }
    
}
