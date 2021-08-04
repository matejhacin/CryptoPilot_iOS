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
    @Published private(set) var error: Error?
    
    private let cmcClient: CoinMarketCapClient
    private let bnClient: BinanceClient
    private let portfolioValueRepository: PortfolioValueRepository
    private var cancelBag = Set<AnyCancellable>()
    
    init(cmcClient: CoinMarketCapClient = CoinMarketCapClient(), bnClient: BinanceClient = BinanceClient(), portfolioValueRepository: PortfolioValueRepository = PortfolioValueRepository()) {
        self.cmcClient = cmcClient
        self.bnClient = bnClient
        self.portfolioValueRepository = portfolioValueRepository
    }
    
    func loadUserPortfolio() {
        Publishers.Zip3(
            bnClient.getAccountInformation(),
            bnClient.getAllTradingPairPrices(),
            cmcClient.getListings(count: 100))
            .sink { accountInfo, tickers, listings in
                if let accountInfo = accountInfo.value, let tickers = tickers.value, let listings = listings.value {
                    do {
                        self.userPortfolio = try UserPortfolio(accountInfo: accountInfo, tickers: tickers, cmcListings: listings)
                        self.updateSavedPortfolioValue(newValue: self.userPortfolio?.totalValueUSD)
                    } catch {
                        self.error = error
                    }
                } else {
                    // TODO Handle error
                }
            }.store(in: &cancelBag)
    }
    
    private func updateSavedPortfolioValue(newValue: Double?) {
        if let value = newValue {
            portfolioValueRepository.savePortfolioValue(value)
        }
    }
    
}

class HomeViewModelMock: HomeViewModelProtocol {
    @Published private(set) var userPortfolio: UserPortfolio?
    
    func loadUserPortfolio() {
        userPortfolio = try! UserPortfolio(
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
