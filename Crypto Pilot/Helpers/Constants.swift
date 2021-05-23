//
//  Constants.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation

class Constants {
    
    class CoinMarketCap {
        static let BASE_URL = "https://pro-api.coinmarketcap.com"
        static let API_KEY = "69a0d9e3-fe46-4cab-8c20-a38f105f0cf3"
    }
    
    class Binance {
        static let BASE_URL = "https://api.binance.com"
        static let DEFAULT_RECWINDOW = 60000
    }
    
    class Coins {
        static let BASE_COIN = "BTC"
        static let STABLE_COINS = ["USDC", "USDT", "PAX", "WBTC", "BUSD", "DAI"]
    }
    
}
