//
//  Api.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 23/03/2021.
//

import Foundation
import Alamofire

class Api {
    
    func getListings(count: Int, onResponse: @escaping ((CMCListings?, AFError?) -> Void)) {
        let url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
        let params = [
            "limit" : count,
            "sort" : "market_cap"
        ] as [String : Any]
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY" : "69a0d9e3-fe46-4cab-8c20-a38f105f0cf3"
        ]
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseDecodable { (response: DataResponse<CMCListings, AFError>) in
                onResponse(response.value, response.error)
            }
    }
    
}
