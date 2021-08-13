//
//  LocalStorage.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/05/2021.
//

import Foundation
import Combine

class ExchangeInfo {
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    static let shared = ExchangeInfo()
    
    private var cancellable: AnyCancellable?
    
    var info: BNExchangeInfo? {
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
    
    func update() {
        cancellable = BinanceClient().getExchangeInformation()
            .sink { response in
                if let info = response.value {
                    self.info = info
                }
            }
    }
    
}
