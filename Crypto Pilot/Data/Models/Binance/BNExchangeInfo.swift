//
//  BNExchangeInfo.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/05/2021.
//

import Foundation

class BNExchangeInfo: Codable {
    var timezone: String
    var serverTime: Int
    var rateLimits: [RateLimit]
    var symbols: [Symbol]
    
    func findSymbol(symbol: String) -> Symbol? {
        return symbols.first(where: { $0.symbol == symbol })
    }
}

struct RateLimit: Codable {
    var rateLimitType, interval: String
    var intervalNum, limit: Int
}

struct Symbol: Codable {
    var symbol: String
    var status: Status
    var baseAsset: String
    var baseAssetPrecision: Int
    var quoteAsset: QuoteAsset
    var quotePrecision, quoteAssetPrecision, baseCommissionPrecision, quoteCommissionPrecision: Int
    var orderTypes: [OrderType]
    var icebergAllowed, ocoAllowed, quoteOrderQtyMarketAllowed, isSpotTradingAllowed: Bool
    var isMarginTradingAllowed: Bool
    var filters: [Filter]
    var permissions: [Permission]
    
    var minQty: Double? {
        get {
            let lotSizeFilter = filters.first(where: { $0.filterType == FilterType.lotSize })
            return Double(lotSizeFilter?.minQty ?? "")
        }
    }
    
    var stepSize: Double? {
        get {
            let lotSizeFilter = filters.first(where: { $0.filterType == FilterType.lotSize })
            return Double(lotSizeFilter?.stepSize ?? "")
        }
    }
}

struct Filter: Codable {
    var filterType: FilterType
    var minPrice, maxPrice, tickSize, multiplierUp: String?
    var multiplierDown: String?
    var avgPriceMins: Int?
    var minQty, maxQty, stepSize, minNotional: String?
    var applyToMarket: Bool?
    var limit, maxNumOrders, maxNumAlgoOrders: Int?
}

enum FilterType: String, Codable {
    case icebergParts = "ICEBERG_PARTS"
    case lotSize = "LOT_SIZE"
    case marketLotSize = "MARKET_LOT_SIZE"
    case maxNumAlgoOrders = "MAX_NUM_ALGO_ORDERS"
    case maxNumOrders = "MAX_NUM_ORDERS"
    case minNotional = "MIN_NOTIONAL"
    case percentPrice = "PERCENT_PRICE"
    case priceFilter = "PRICE_FILTER"
}

enum OrderType: String, Codable {
    case limit = "LIMIT"
    case limitMaker = "LIMIT_MAKER"
    case market = "MARKET"
    case stopLossLimit = "STOP_LOSS_LIMIT"
    case takeProfitLimit = "TAKE_PROFIT_LIMIT"
}

enum Permission: String, Codable {
    case leveraged = "LEVERAGED"
    case margin = "MARGIN"
    case spot = "SPOT"
}

enum QuoteAsset: String, Codable {
    case aud = "AUD"
    case bidr = "BIDR"
    case bkrw = "BKRW"
    case bnb = "BNB"
    case brl = "BRL"
    case btc = "BTC"
    case busd = "BUSD"
    case bvnd = "BVND"
    case dai = "DAI"
    case eth = "ETH"
    case eur = "EUR"
    case gbp = "GBP"
    case gyen = "GYEN"
    case idrt = "IDRT"
    case ngn = "NGN"
    case pax = "PAX"
    case quoteAssetTRY = "TRY"
    case rub = "RUB"
    case trx = "TRX"
    case tusd = "TUSD"
    case uah = "UAH"
    case usdc = "USDC"
    case usds = "USDS"
    case usdt = "USDT"
    case vai = "VAI"
    case xrp = "XRP"
    case zar = "ZAR"
}

enum Status: String, Codable {
    case statusBREAK = "BREAK"
    case trading = "TRADING"
}
