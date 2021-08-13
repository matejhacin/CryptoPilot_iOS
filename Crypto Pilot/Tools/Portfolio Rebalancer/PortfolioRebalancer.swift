//
//  PortfolioRebalancer.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/05/2021.
//

import Foundation
import Combine
import Alamofire

class PortfolioRebalancer {
    
    @Published var progress = RebalanceProgress.ready
    var nonFatalErrors: [LocalizedError] = [
        //        RebalanceError("Coin BTC didn't SELL (transaction too small)"),
        //        RebalanceError("Coin LTC didn't SELL (transaction too small)"),
        //        RebalanceError("Coin ETH didn't BUY (transaction too small)")
    ]
    
    private let cmc: CoinMarketCapClient
    private let bnb: BinanceClient
    private let allocationTools: PortfolioAllocationTools
    private var rebalanceCalculator: RebalanceTradeCalculator?
    
    private var cancelBag = Set<AnyCancellable>()
    private var orderQueue: [RebalanceOrder] = []
    
    init(cmc: CoinMarketCapClient = CoinMarketCapClient(), bnb: BinanceClient = BinanceClient(), allocationTools: PortfolioAllocationTools = PortfolioAllocationTools(allocationCount: 20, excludeStablecoins: true)) {
        self.cmc = cmc
        self.bnb = bnb
        self.allocationTools = allocationTools
    }
    
    private var testCancellable: AnyCancellable?
    func testBeginRebalance() {
        progress = .gettingLatestValues
        testCancellable = Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .sink { value in
                switch (self.progress) {
                case .ready:
                    self.progress = .gettingLatestValues
                case .gettingLatestValues:
                    self.progress = .executingSellOrders
                case .executingSellOrders:
                    self.progress = .updatingUserPortfolio
                case .updatingUserPortfolio:
                    // self.progress = .failed(RebalanceError("Nothing really went wrong, just me being a silly goose 🦆"), self.progress)
                    self.progress = .executingBuyOrders
                case .executingBuyOrders:
                    self.progress = .done
                case .done:
                    self.testCancellable?.cancel()
                case .failed:
                    print("Do nothing")
                }
            }
    }
    
    func beginRebalance() {
        self.progress = .gettingLatestValues
        Publishers.Zip3(
            cmc.getListings(count: 50),
            bnb.getAccountInformation(),
            bnb.getAllTradingPairPrices())
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .sink(receiveValue: { (listings, accountInfo, tickers) in
                if let listings = listings.value, let accountInfo = accountInfo.value, let tickers = tickers.value {
                    self.initRebalanceCalculator(cmcListings: listings, accountInformation: accountInfo, tickers: tickers)
                    self.beginExecutingSellOrders()
                } else {
                    self.progress = .failed(RebalanceError("Something went wrong when gathering your account information. Check your connection and try again."), self.progress)
                }
            }).store(in: &cancelBag)
    }
    
    private func initRebalanceCalculator(cmcListings: CMCListings, accountInformation: BNAccountInformation, tickers: [BNSymbolPrice]) {
        do {
            rebalanceCalculator = try RebalanceTradeCalculator(
                cmcListings: cmcListings,
                accountInfo: accountInformation,
                tickers: tickers,
                tools: allocationTools)
        } catch {
            progress = .failed(error, progress)
        }
    }
    
    private func beginExecutingSellOrders() {
        guard !progress.isFailed else { return }
        
        progress = .executingSellOrders
        do {
            let sellOrders = try rebalanceCalculator!.getSellOrders()
            addToQueue(orders: sellOrders)
            executeQueuedOrders {
                self.refreshAccountInformation()
            }
        } catch {
            progress = .failed(error, progress)
        }
    }
    
    private func refreshAccountInformation() {
        guard !progress.isFailed else { return }
        
        let refreshError = RebalanceProgress.failed(RebalanceError("Something went wrong when refreshing account portfolio after completing sell orders. Check your network and rebalance again to continue with buy orders."), progress)
        
        bnb.getAccountInformation()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .handleEvents(receiveSubscription: { _ in
                self.progress = .updatingUserPortfolio
            })
            .sink { response in
                if let accountInfo = response.value {
                    do {
                        try self.rebalanceCalculator?.updateAccountInfo(accountInfo: accountInfo)
                        self.beginExecutingBuyOrders()
                    } catch {
                        self.progress = refreshError
                    }
                } else {
                    if let _ = response.error, let data = response.data, let _ = try? JSONDecoder().decode(BNError.self, from: data) {
                        // Possibly handle here as well
                    }
                    self.progress = refreshError
                }
            }.store(in: &cancelBag)
    }
    
    private func beginExecutingBuyOrders() {
        guard !progress.isFailed else { return }
        
        progress = .executingBuyOrders
        do {
            let buyOrders = try self.rebalanceCalculator!.getBuyOrders()
            addToQueue(orders: buyOrders)
            executeQueuedOrders {
                self.finishRebalance()
            }
        } catch {
            progress = .failed(error, progress)
        }
    }
    
    private func finishRebalance() {
        progress = .done
    }
    
    private func executeQueuedOrders(onFinish: (() -> Void)?) {
        guard !progress.isFailed else { return }
        
        guard let order = orderQueue.popLast() else {
            onFinish?()
            return
        }
        
        guard order.isExecutable else {
            nonFatalErrors.append(RebalanceError("Coin \(order.symbol) didn't \(order.side.rawValue)\n(transaction too small)"))
            executeQueuedOrders(onFinish: onFinish)
            return
        }
        
        bnb.createOrder(order: order)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .sink { response in
                var continueExecutingOrders = true
                if let value = response.value {
                    print("--- Order success: \(value.symbol) \(value.status)")
                } else if let _ = response.error, let data = response.data, let error = try? JSONDecoder().decode(BNError.self, from: data) {
                    switch error.code {
                    case -2015: // Invalid API-key, IP, or permissions for action.
                        continueExecutingOrders = false
                        self.progress = .failed(RebalanceError("Rebalance stopped due to insufficient trading permissions. Please make sure your generated API keys have spot & margin trading enabled."), self.progress)
                    case -1013:
                        self.nonFatalErrors.append(RebalanceError("Coin \(order.symbol) didn't \(order.side.rawValue)\n(transaction too small)"))
                    default:
                        self.nonFatalErrors.append(RebalanceError(error.msg))
                    }
                } else {
                    self.nonFatalErrors.append(RebalanceError("Trade order to \(order.side.rawValue) \(order.asset) failed due to an unknown error"))
                }
                if continueExecutingOrders {
                    self.executeQueuedOrders(onFinish: onFinish)
                } else {
                    self.orderQueue.removeAll()
                }
            }.store(in: &cancelBag)
    }
    
    private func addToQueue(orders: [RebalanceOrder]) {
        orderQueue.append(contentsOf: orders)
    }
    
}
