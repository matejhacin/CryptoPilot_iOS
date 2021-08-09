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
//                    self.progress = .failed(RebalanceError("Nothing really went wrong, just me being a silly goose 🦆"), self.progress)
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
        Publishers.Zip3(
            cmc.getListings(count: 50),
            bnb.getAccountInformation(),
            bnb.getAllTradingPairPrices())
            .handleEvents(receiveSubscription: { _ in
                self.progress = .gettingLatestValues
            })
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
        let refreshError = RebalanceProgress.failed(RebalanceError("Something went wrong when refreshing account portfolio after completing sell orders. Check your network and rebalance again to continue with buy orders."), progress)
        
        bnb.getAccountInformation()
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
        guard let order = orderQueue.popLast() else {
            onFinish?()
            return
        }
        
        guard order.isExecutable else {
            nonFatalErrors.append(RebalanceError("Coin \(order.symbol) didn't \(order.side.rawValue)\n(transaction too small)"))
            return
        }
        
        bnb.createOrder(order: order).sink { response in
            if let value = response.value {
                print("--- Order success: \(value.symbol) \(value.status)")
            } else {
                if let _ = response.error, let data = response.data, let _ = try? JSONDecoder().decode(BNError.self, from: data) {
                    // Possibly handle this as well
                }
                self.nonFatalErrors.append(RebalanceError("Coin \(order.symbol) didn't \(order.side.rawValue)\n(transaction too small)"))
            }
            self.executeQueuedOrders(onFinish: onFinish)
        }.store(in: &cancelBag)
    }
    
    private func addToQueue(orders: [RebalanceOrder]) {
        orderQueue.append(contentsOf: orders)
    }
    
}
