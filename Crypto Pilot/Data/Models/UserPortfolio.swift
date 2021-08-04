//
//  UserPortfolio.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/04/2021.
//

import Foundation

class UserPortfolio {
    
    private var accountInfo: BNAccountInformation
    private let tickers: [BNSymbolPrice]
    private let cmcListings: CMCListings?
    
    let canTrade: Bool
    var balances: [CoinBalance]?
    
    init(accountInfo: BNAccountInformation, tickers: [BNSymbolPrice], cmcListings: CMCListings? = nil) throws {
        self.accountInfo = accountInfo
        self.tickers = tickers
        self.cmcListings = cmcListings
        self.canTrade = accountInfo.canTrade
        try mapPrices()
        recalculateBalanceRatios()
        map24hPercentChangesIfPossible()
    }
    
    var totalValueUSD: Double {
        get {
            var result = 0.0
            for coin in balances ?? [] {
                result += coin.valueUSD
            }
            return result
        }
    }
    
    var totalValueBTC: Double {
        get {
            var result = 0.0
            for coin in balances ?? [] {
                result += coin.valueBTC
            }
            return result
        }
    }
    
    var totalValueUSDPrettyText: String {
        get {
            let roundedValue = NumberTools.roundDecimals(number: totalValueUSD, precision: 0.01)
            return "$\(roundedValue)"
        }
    }
    
    func updateAccountInfo(accountInfo: BNAccountInformation) throws {
        self.accountInfo = accountInfo
        try mapPrices()
        recalculateBalanceRatios()
    }
    
    private func mapPrices() throws {
        var mappedBalances: [CoinBalance] = []
        
        // Find USD price for base currency
        guard let btcUsdPrice = tickers.filter({ $0.symbol == "BTCUSDT" }).first?.price else {
            throw MappingError.baseCurrencyPriceNotFound
        }
        
        // Find USD price for each coin in our balance
        for balance in accountInfo.balances {
            
            // Remove and ignore stable coints
            if (CoinUtility.isStableCoin(symbol: balance.asset)) {
                continue
            }
            
            // If we run into BTC, we already know the price
            if (balance.asset == "BTC") {
                mappedBalances.append(
                    CoinBalance(
                        symbol: balance.asset,
                        free: Double(balance.free)!,
                        locked: Double(balance.locked)!,
                        priceUsd: Double(btcUsdPrice)!,
                        priceBTC: 1)
                )
            }
            
            // Otherwise we continue with the calculation
            guard let balancePriceInBtc = tickers.filter({ $0.symbol == "\(balance.asset)\(Constants.Coins.BASE_COIN)" }).first?.price else {
                // If BTC trading pair is not found, we assume the coin is untradeable and we ignore it for now
                // Later, when we support more trading pairs, this logic might need to be improved
                continue
            }
            
            // Calculate the final price per unit, then add it to balances array
            let balancePricePerUnit = Double(balancePriceInBtc)! * Double(btcUsdPrice)!
            
            mappedBalances.append(
                CoinBalance(
                    symbol: balance.asset,
                    free: Double(balance.free)!,
                    locked: Double(balance.locked)!,
                    priceUsd: balancePricePerUnit,
                    priceBTC: Double(balancePriceInBtc)!)
            )
        }
        
        balances = mappedBalances.filter({ $0.free > 0 })
    }
    
    private func recalculateBalanceRatios() {
        guard let balances = balances else { return }
        
        // Get total first
        var totalBalance = 0.0
        for balance in balances {
            totalBalance += balance.valueUSD
        }
        
        // Now calculate ratio for each balance
        for balance in balances {
            balance.ratio = balance.valueUSD / totalBalance
        }
    }
    
    private func map24hPercentChangesIfPossible() {
        guard let balances = balances, let listings = cmcListings?.data else { return }
        
        for balance in balances {
            for listing in listings {
                if balance.asset == listing.symbol {
                    balance.percentChange24H = listing.quote.usd.percentChange24H
                }
            }
        }
    }
    
    func findCoinBalance(asset: String) -> CoinBalance? {
        return balances?.first(where: { $0.asset == asset })
    }
    
    enum MappingError: Error {
        case baseCurrencyPriceNotFound
        case baseCurrencyTradingPairMissing
    }
    
}
