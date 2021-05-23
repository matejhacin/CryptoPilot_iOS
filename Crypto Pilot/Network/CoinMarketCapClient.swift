//
//  Api.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation
import Alamofire

class CoinMarketCapClient {
    
    func getListings(count: Int) -> DataResponsePublisher<CMCListings> {
        let url = "\(Constants.CoinMarketCap.BASE_URL)/v1/cryptocurrency/listings/latest"
        let params = [
            "limit" : count,
            "sort" : "market_cap"
        ] as [String : Any]
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY" : Constants.CoinMarketCap.API_KEY
        ]
        return AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).publishDecodable()
    }
    
}
