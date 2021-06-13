//
//  HomeViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/06/2021.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var userPortfolio: UserPortfolio? { get }
    func loadUserPortfolio()
}

class HomeViewModel: HomeViewModelProtocol {
    
    @Published private(set) var userPortfolio: UserPortfolio?
    
    private let cmcClient: CoinMarketCapClient
    private let bnClient: BinanceClient
    private var cancelBag = Set<AnyCancellable>()
    
    init(cmcClient: CoinMarketCapClient = CoinMarketCapClient(), bnClient: BinanceClient = BinanceClient()) {
        self.cmcClient = cmcClient
        self.bnClient = bnClient
    }
    
    func loadUserPortfolio() {
        Publishers.Zip(
            bnClient.getAccountInformation(),
            bnClient.getAllTradingPairPrices())
            .sink { accountInfo, tickers in
                if let accountInfo = accountInfo.value, let tickers = tickers.value {
                    self.userPortfolio = UserPortfolio(accountInfo: accountInfo, tickers: tickers)
                } else {
                    // TODO Handle error
                }
            }.store(in: &cancelBag)
    }
    
}

class HomeViewModelMock: HomeViewModelProtocol {
    @Published private(set) var userPortfolio: UserPortfolio?
    
    func loadUserPortfolio() {
        userPortfolio = UserPortfolio(
            accountInfo: BNAccountInformation(
                makerCommission: 1,
                takerCommission: 1,
                buyerCommission: 1,
                sellerCommission: 1,
                canTrade: true,
                canWithdraw: true,
                canDeposit: true,
                updateTime: 1,
                accountType: "Test",
                balances: [
                    Balance(asset: "BTC", free: "0.5384634", locked: "0"),
                    Balance(asset: "LTC", free: "12.45345", locked: "0"),
                    Balance(asset: "ETH", free: "3.12", locked: "0")
                ],
                permissions: []),
            tickers: [
                BNSymbolPrice(symbol: "BTCUSDT", price: "51580"),
                BNSymbolPrice(symbol: "LTCBTC", price: "0.0512"),
                BNSymbolPrice(symbol: "ETHBTC", price: "0.1343")
            ])
    }
    
}
