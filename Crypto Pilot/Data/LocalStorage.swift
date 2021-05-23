//
//  LocalStorage.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/05/2021.
//

import Foundation

class LocalStorage {
    
    private static let userDefaults = UserDefaults.standard
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    static var exchangeInfo: BNExchangeInfo? {
        set {
            if let data = try? encoder.encode(newValue) {
                userDefaults.setValue(data, forKey: "exchangeInfo")
            }
        }
        get {
            if let data = userDefaults.object(forKey: "exchangeInfo") as? Data {
                return try? decoder.decode(BNExchangeInfo.self, from: data)
            }
            return nil
        }
    }
    
}
