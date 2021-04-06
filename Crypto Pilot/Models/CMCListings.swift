//
//  CMCListings.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/04/2021.
//

import Foundation

extension CMCCoinData {
    func mapToCoinAllocation() -> CoinAllocation {
        return CoinAllocation(symbol: symbol, marketCap: quote.usd.marketCap)
    }
}

extension CMCListings {
    func mapToCoinAllocations() -> [CoinAllocation] {
        var allocations = [CoinAllocation]()
        for coinData in self.data {
            allocations.append(coinData.mapToCoinAllocation())
        }
        return allocations
    }
}

struct CMCListings: Codable {
    var status: CMCStatus
    var data: [CMCCoinData]
}

struct CMCCoinData: Codable, Identifiable {
    var id: Int
    var name, symbol, slug: String
    var numMarketPairs: Int
    var dateAdded: String
    var tags: [String]
    var maxSupply: Int?
    var circulatingSupply, totalSupply: Double
    var platform: CMCPlatform?
    var cmcRank: Int
    var lastUpdated: String
    var quote: CMCQuote

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case platform
        case cmcRank = "cmc_rank"
        case lastUpdated = "last_updated"
        case quote
    }
}

struct CMCPlatform: Codable {
    var id: Int
    var name, symbol, slug, tokenAddress: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case tokenAddress = "token_address"
    }
}

struct CMCQuote: Codable {
    var usd: CMCQuoteData

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct CMCQuoteData: Codable {
    var price, volume24H, percentChange1H, percentChange24H: Double
    var percentChange7D, percentChange30D, percentChange60D, percentChange90D: Double
    var marketCap: Double
    var lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case lastUpdated = "last_updated"
    }
}

struct CMCStatus: Codable {
    var timestamp: String
    var errorCode: Int
//    var errorMessage: Any?
    var elapsed, creditCount: Int
//    var notice: Any?
    var totalCount: Int

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
//        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
//        case notice
        case totalCount = "total_count"
    }
}
