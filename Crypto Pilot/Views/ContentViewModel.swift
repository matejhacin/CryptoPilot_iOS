//
//  ContentViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation
import Combine
import Alamofire

class ContentViewModel: ObservableObject {
    
    @Published var allocations = [CoinAllocation]()
    
    private let cmc: CoinMarketCapClient
    private let bnb: BinanceClient
    private let allocationTools: PortfolioAllocationTools
    private var cancelBag = Set<AnyCancellable>()
    private var rebalanceCalculator: RebalanceTradeCalculator?
    
    init(cmc: CoinMarketCapClient = CoinMarketCapClient(),
         bnb: BinanceClient = BinanceClient(),
         allocationTools: PortfolioAllocationTools = PortfolioAllocationTools(allocationCount: 20, excludeStablecoins: true)) {
        self.cmc = cmc
        self.bnb = bnb
        self.allocationTools = allocationTools
    }
    
    func loadAndCacheExchangeInfo() {
        bnb.getExchangeInformation()
            .sink { response in
                if let value = response.value {
                    LocalStorage.exchangeInfo = value
                }
            }.store(in: &cancelBag)
    }

    func startRebalance() {
        Publishers.Zip3(
            cmc.getListings(count: 50),
            bnb.getAccountInformation(),
            bnb.getAllTradingPairPrices())
            .sink(receiveValue: { (listings, accountInfo, tickers) in
                if let listings = listings.value, let accountInfo = accountInfo.value, let tickers = tickers.value {
                    self.initRebalanceCalculator(cmcListings: listings, accountInformation: accountInfo, tickers: tickers)
                }
            }).store(in: &cancelBag)
    }
    
    private func initRebalanceCalculator(cmcListings: CMCListings, accountInformation: BNAccountInformation, tickers: [BNSymbolPrice]) {
        rebalanceCalculator = RebalanceTradeCalculator(cmcListings: cmcListings, accountInfo: accountInformation, tickers: tickers, tools: allocationTools)
        allocations = rebalanceCalculator!.desiredAllocations
        
        let sellOrders = try! rebalanceCalculator!.getSellOrders()
        for order in sellOrders {
            guard let symbolRules = LocalStorage.exchangeInfo?.findSymbol(symbol: order.symbol) else {
                print("--- !!! --- Could not find symbol rules (\(order.symbol)")
                continue
            }
            guard let stepSize = symbolRules.stepSize else {
                print("--- !!! --- Could not find stepSize (\(order.symbol)")
                continue
            }
            guard let minQty = symbolRules.minQty else {
                print("--- !!! --- Could not find minQty (\(order.symbol)")
                continue
            }
            
            order.fixedAmount = NumberTools.roundDecimals(number: order.amount, precision: stepSize)
            order.minAmount = minQty
            
            if order.isExecutable {
                orderRequests.append(
                    bnb.createOrder(symbol: order.symbol, side: order.side, quantity: order.fixedAmount!)
                )
            } else {
                print("--- !!! --- Order is not executable: \(order.fixedAmount!) \(order.asset)")
            }
        }
        
        executeNextOrder {
            print("--- Moving to buy phase...")
            self.moveToBuyPhase()
        }
    }
    
    var orderRequests: [DataResponsePublisher<BNOrder>] = []
    
    func executeNextOrder(onFinish: (() -> Void)?) {
        guard let nextOrder = orderRequests.popLast() else {
            print("--- !!! --- No more orders to execute")
            onFinish?()
            return
        }
        
        nextOrder.sink { response in
            if let error = response.error {
                if let data = response.data, let bnError = try? JSONDecoder().decode(BNError.self, from: data) {
                    print("--- !!! --- Order error: \(bnError.msg) (\(bnError.code))")
                } else {
                    print("--- !!! --- Order error: \(error)")
                }
            } else if let value = response.value {
                print("--- \(value.symbol) \(value.status)")
            } else {
                print("--- Not sure what happened here :))")
            }
            self.executeNextOrder(onFinish: onFinish)
        }.store(in: &cancelBag)
    }
    
    func moveToBuyPhase() {
        bnb.getAccountInformation().sink { response in
            if let error = response.error {
                if let data = response.data, let bnError = try? JSONDecoder().decode(BNError.self, from: data) {
                    print("--- !!! --- Account info error: \(bnError.msg) (\(bnError.code))")
                } else {
                    print("--- !!! --- Account info error: \(error)")
                }
            } else if let value = response.value {
                print("--- Updating account info...")
                self.rebalanceCalculator?.updateAccountInfo(accountInfo: value)
                
                let buyOrders = try? self.rebalanceCalculator?.getBuyOrders()
                
                for order in buyOrders ?? [] {
                    
                    guard let symbolRules = LocalStorage.exchangeInfo?.findSymbol(symbol: order.symbol) else {
                        print("--- !!! --- Could not find symbol rules (\(order.symbol)")
                        continue
                    }
                    guard let stepSize = symbolRules.stepSize else {
                        print("--- !!! --- Could not find stepSize (\(order.symbol)")
                        continue
                    }
                    guard let minQty = symbolRules.minQty else {
                        print("--- !!! --- Could not find minQty (\(order.symbol)")
                        continue
                    }
                    
                    order.fixedAmount = NumberTools.roundDecimals(number: order.amount, precision: stepSize)
                    order.minAmount = minQty
                    
                    if order.isExecutable {
                        self.orderRequests.append(
                            self.bnb.createOrder(symbol: order.symbol, side: order.side, quantity: order.fixedAmount!)
                        )
                    } else {
                        print("--- !!! --- Order is not executable: \(order.fixedAmount!) \(order.asset)")
                    }
                    
                }
                
                self.executeNextOrder {
                    print("--- DONE")
                }
            }
        }.store(in: &cancelBag)
    }
    
}
