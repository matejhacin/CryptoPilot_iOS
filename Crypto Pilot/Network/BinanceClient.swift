//
//  BinanceClient.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation
import Alamofire
import Combine

class BinanceClient {
    
    func getAveragePrice(for symbol: String) -> DataResponsePublisher<BNAveragePrice> {
        let url = "\(Constants.Binance.BASE_URL)/api/v3/avgPrice?symbol=\(symbol.uppercased())USDT"
        let headers: HTTPHeaders = [HTTPHeader(name: "X-MBX-APIKEY", value: AuthState.shared.apiKey!)]
        
        return AF.request(url, method: .get, headers: headers).validate().publishDecodable(type: BNAveragePrice.self)
    }
    
    func testConnection(apiKey: String, secretKey: String) -> DataResponsePublisher<BNAccountInformation> {
        var url = "\(Constants.Binance.BASE_URL)/api/v3/account?"
        var parameters = prepareTimestampParameters()
        let parametersSignature = CryptographyTools.hmacSHA256(text: parameters, secret: secretKey)
        parameters += "&signature=\(parametersSignature)"
        url += parameters
        let headers: HTTPHeaders = [HTTPHeader(name: "X-MBX-APIKEY", value: apiKey)]
        return AF.request(url, method: .get, headers: headers).publishDecodable()
    }
    
    func getAccountInformation() -> DataResponsePublisher<BNAccountInformation> {
        var url = "\(Constants.Binance.BASE_URL)/api/v3/account?"
        var parameters = prepareTimestampParameters()
        let parametersSignature = CryptographyTools.hmacSHA256(text: parameters, secret: AuthState.shared.secretKey!)
        parameters += "&signature=\(parametersSignature)"
        url += parameters
        let headers: HTTPHeaders = [HTTPHeader(name: "X-MBX-APIKEY", value: AuthState.shared.apiKey!)]
        return AF.request(url, method: .get, headers: headers).publishDecodable()
    }
    
    func getAllTradingPairPrices() -> DataResponsePublisher<[BNSymbolPrice]> {
        let url = "\(Constants.Binance.BASE_URL)/api/v3/ticker/price"
        return AF.request(url).validate().publishDecodable()
    }
    
    func createOrder(order: RebalanceOrder) -> DataResponsePublisher<BNOrder> {
        var url = "\(Constants.Binance.BASE_URL)/api/v3/order"
        let parameters = [
            "symbol" : order.symbol,
            "side" : order.side.rawValue,
            "type" : "MARKET",
            "quantity" : order.fixedAmount!,
            "timestamp" : Date().millisecondsSince1970,
            "recvWindow" : Constants.Binance.DEFAULT_RECWINDOW
        ] as [String : Any]
        var queryString = parameters.sorted { $0.0 < $1.0 }.map { "\($0.0)=\($0.1)"}.joined(separator: "&")
        let signature = CryptographyTools.hmacSHA256(text: queryString, secret: AuthState.shared.secretKey!)
        queryString += "&signature=\(signature)"
        let headers: HTTPHeaders = [HTTPHeader(name: "X-MBX-APIKEY", value: AuthState.shared.apiKey!)]
        url += "?\(queryString)"
        return AF.request(url, method: .post, headers: headers, interceptor: nil, requestModifier: nil).responseString(completionHandler: { response in
            print("--------\n\(response.value)\n--------")
        }).publishDecodable()
    }
    
    func getExchangeInformation() -> DataResponsePublisher<BNExchangeInfo> {
        let url = "\(Constants.Binance.BASE_URL)/api/v3/exchangeInfo"
        return AF.request(url, method: .get).publishDecodable()
    }
    
}

extension BinanceClient {
    
    private func prepareTimestampParameters(_ recWindow: Int = 5000) -> String {
        return "timestamp=\(Date().millisecondsSince1970)&recvWindow=\(recWindow)"
    }
    
}
