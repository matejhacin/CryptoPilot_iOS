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
    
    @Published var progress = Progress.ready
    
    private let cmc: CoinMarketCapClient
    private let bnb: BinanceClient
    private let allocationTools: PortfolioAllocationTools
    private var rebalanceCalculator: RebalanceTradeCalculator?
    
    private var cancelBag = Set<AnyCancellable>()
    private var orderQueue: [DataResponsePublisher<BNOrder>] = []
    
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
                    self.progress = .executingBuyOrders
                case .executingBuyOrders:
                    self.progress = .done
                case .done:
                    self.testCancellable?.cancel()
                }
            }
    }
    
    func beginRebalance() {
        Publishers.Zip3(
            cmc.getListings(count: 50),
            bnb.getAccountInformation(),
            bnb.getAllTradingPairPrices())
            .sink(receiveValue: { (listings, accountInfo, tickers) in
                if let listings = listings.value, let accountInfo = accountInfo.value, let tickers = tickers.value {
                    self.initRebalanceCalculator(cmcListings: listings, accountInformation: accountInfo, tickers: tickers)
                    self.beginExecutingSellOrders()
                } else {
                    print("break") // TODO Handle error
                }
            }).store(in: &cancelBag)
    }
    
    private func initRebalanceCalculator(cmcListings: CMCListings, accountInformation: BNAccountInformation, tickers: [BNSymbolPrice]) {
        rebalanceCalculator = RebalanceTradeCalculator(
            cmcListings: cmcListings,
            accountInfo: accountInformation,
            tickers: tickers,
            tools: allocationTools)
    }
    
    private func beginExecutingSellOrders() {
        do {
            let sellOrders = try rebalanceCalculator!.getSellOrders()
            addToQueue(orders: sellOrders)
            executeQueuedOrders {
                self.refreshAccountInformation()
            }
        } catch {
            // TODO Handle error
            print(error)
        }
    }
    
    private func refreshAccountInformation() {
        bnb.getAccountInformation().sink { response in
            if let error = response.error {
                if let data = response.data, let bnError = try? JSONDecoder().decode(BNError.self, from: data) {
                    print("--- !!! --- Account info error: \(bnError.msg) (\(bnError.code))")
                } else {
                    print("--- !!! --- Account info error: \(error)")
                }
            } else if let accountInfo = response.value {
                self.rebalanceCalculator?.updateAccountInfo(accountInfo: accountInfo)
                self.beginExecutingBuyOrders()
            } else {
                print("--- Not sure what happened while getting account info")
            }
        }.store(in: &cancelBag)
    }
    
    private func beginExecutingBuyOrders() {
        do {
            let buyOrders = try self.rebalanceCalculator!.getBuyOrders()
            addToQueue(orders: buyOrders)
            executeQueuedOrders {
                self.finishRebalance()
            }
        } catch {
            // TODO Handle error
            print(error)
        }
    }
    
    private func finishRebalance() {
        print("Rebalance finished!")
    }
    
    private func executeQueuedOrders(onFinish: (() -> Void)?) {
        guard let order = orderQueue.popLast() else {
            onFinish?()
            return
        }
        
        order.sink { response in
            if let error = response.error {
                if let data = response.data, let bnError = try? JSONDecoder().decode(BNError.self, from: data) {
                    print("--- !!! --- Order error: \(bnError.msg) (\(bnError.code))")
                } else {
                    print("--- !!! --- Order error: \(error)")
                }
            } else if let value = response.value {
                print("--- \(value.symbol) \(value.status)")
            } else {
                print("--- Not sure what happened with order: \(response.request?.url?.absoluteString ?? "NO_URL")")
            }
            self.executeQueuedOrders(onFinish: onFinish)
        }.store(in: &cancelBag)
    }
    
    private func addToQueue(order: RebalanceOrder) {
        if order.isExecutable {
            orderQueue.append(
                bnb.createOrder(order: order)
            )
        } else {
            // TODO Handle unknown state
        }
    }
    
    private func addToQueue(orders: [RebalanceOrder]) {
        for order in orders {
            addToQueue(order: order)
        }
    }
    
    // MARK: Progress Enum
    
    enum Progress: Int {
        case ready = 0
        case gettingLatestValues = 1
        case executingSellOrders = 2
        case updatingUserPortfolio = 3
        case executingBuyOrders = 4
        case done = 5
    }
    
}
