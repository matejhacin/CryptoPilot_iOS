//
//  Constants.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation

class Constants {
    
    class AppSettings {
        static let REBALANCE_PERIOD = 30 // Days
    }
    
    class UserDefaults {
        static let LAST_REBALANCE_DATE = "last_rebalance_date"
        static let NOTIFICATION_PERMISSION_ASKED = "notification_permission_asked"
    }
    
    class CoinMarketCap {
        static let BASE_URL = "https://pro-api.coinmarketcap.com"
        static let API_KEY = "69a0d9e3-fe46-4cab-8c20-a38f105f0cf3"
    }
    
    class Binance {
        static let BASE_URL = "https://api.binance.com"
        static let DEFAULT_RECWINDOW = 60000
    }
    
    class MixPanel {
        static let PROJECT_TOKEN = "fe2c968dd381b602defbb11f2feb9aa1"
    }
    
    class Coins {
        static let BASE_COIN = "BTC"
        static let STABLE_COINS = ["USDC", "USDT", "PAX", "WBTC", "BUSD", "DAI", "SCRT"] // SCRT is not a stablecoin, remove when possible
    }
    
}
