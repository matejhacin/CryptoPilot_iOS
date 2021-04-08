//
//  BinanceClient.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation
import Alamofire

class BinanceClient {
    
    func getAccountInformation() {
        let timestampMillis = Date().millisecondsSince1970
        var url = "\(Constants.Binance.BASE_URL)/api/v3/account?"
        var parameters = "timestamp=\(timestampMillis)&recvWindow=60000"
        let parametersSignature = CryptographyTools.hmacSHA256(text: parameters, secret: UserManager.shared.binanceSecretKey)
        parameters += "&signature=\(parametersSignature)"
        url += parameters
        let headers: HTTPHeaders = [HTTPHeader(name: "X-MBX-APIKEY", value: "sEOBB9W6EbvHFGLobrHvRle1rTiqsqLAQX4YC5lijaqleegKprrR3VuaJgVuxzH9")]
        
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<BNAccountInformation, AFError>) in
            print("break")
        }
    }
    
}
