//
//  RebalanceTradeCalculator.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/04/2021.
//

import Foundation

class RebalanceTradeCalculator {
    
    private var userPortfolio: UserPortfolio
    let desiredAllocations: [CoinAllocation]
    private let allocationTools: PortfolioAllocationTools
    private let exchangeInfo = ExchangeInfo.shared.info
    private let tickers: [BNSymbolPrice]
    
    init(cmcListings: CMCListings, accountInfo: BNAccountInformation, tickers: [BNSymbolPrice], tools: PortfolioAllocationTools) {
        self.tickers = tickers
        userPortfolio = UserPortfolio(accountInfo: accountInfo, tickers: tickers)
        desiredAllocations = try! tools.calculateAllocations(coinsToAllocate: cmcListings.mapToCoinAllocations())
        allocationTools = tools
    }
    
    func updateAccountInfo(accountInfo: BNAccountInformation) {
        userPortfolio.updateAccountInfo(accountInfo: accountInfo)
    }
    
    func getSellOrders() throws -> [RebalanceOrder] {
        guard let balances = userPortfolio.balances else {
            throw RebalanceError.portfolioEmptyBalances
        }
        
        var orders: [RebalanceOrder] = []
        
        for coinBalance in balances {
            let allocatedCounterpart = desiredAllocations.filter({ $0.asset == coinBalance.asset }).first
            let isStableCoin = CoinUtility.isStableCoin(symbol: coinBalance.asset)
            let isBaseCoin = coinBalance.asset == Constants.Coins.BASE_COIN
            
            if isBaseCoin || isStableCoin {
                continue // Ignore these, we don't sell them
            }
            
            if allocatedCounterpart != nil {
                guard let balanceRatio = coinBalance.ratio, let desiredRatio = allocatedCounterpart!.ratio else {
                    throw RebalanceError.missingRatioInformation
                }
                
                if balanceRatio > desiredRatio {
                    let balanceValue = coinBalance.free
                    let desiredValue = (desiredRatio * balanceValue) / balanceRatio
                    let overflow = balanceValue - desiredValue
                    orders.append(
                        RebalanceOrder(asset: coinBalance.asset, amount: overflow, side: .SELL)
                    )
                }
            } else {
                orders.append(
                    RebalanceOrder(asset: coinBalance.asset, amount: coinBalance.free, side: .SELL)
                )
            }
        }
        
        return orders
    }
    
    func getBuyOrders() throws -> [RebalanceOrder] {
        var orders: [RebalanceOrder] = []
        
        for desiredAllocation in desiredAllocations {
            guard desiredAllocation.asset != Constants.Coins.BASE_COIN else { continue }
            let currentAllocation = userPortfolio.findCoinBalance(asset: desiredAllocation.asset)
            
            let currentRatio = currentAllocation?.ratio ?? 0.0
            guard let desiredRatio = desiredAllocation.ratio else {
                throw RebalanceError.missingRatioInformation
            }
            
            if desiredRatio > currentRatio {
                let portfolioValue = userPortfolio.totalValueBTC
                let currentAllocationValue = currentAllocation?.valueBTC ?? 0.0
                let desiredAllocationValue = (portfolioValue * (desiredRatio * 100)) / 100
                let delta = desiredAllocationValue - currentAllocationValue
                if let assetPriceInBTC = findPriceInBTC(asset: desiredAllocation.asset) {
                    let amountToBuy = delta / assetPriceInBTC
                    orders.append(
                        RebalanceOrder(asset: desiredAllocation.asset, amount: amountToBuy, side: .BUY)
                    )
                } else {
                    print("--- !!! --- Could not find BTC price for \(desiredAllocation.asset) while calculating BUY order")
                }
            }
        }
        
        return orders
    }
    
    private func findPriceInBTC(asset: String) -> Double? {
        let symbol = "\(asset)\(Constants.Coins.BASE_COIN)"
        if let price = tickers.first(where: { $0.symbol == symbol })?.price {
            return Double(price)
        }
        return nil
    }
    
    enum RebalanceError: Error {
        case portfolioEmptyBalances
        case missingRatioInformation
    }
    
}
