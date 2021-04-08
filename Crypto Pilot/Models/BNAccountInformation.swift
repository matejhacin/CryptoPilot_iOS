//
//  BNAccountInformation.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation

struct BNAccountInformation: Codable {
    var makerCommission, takerCommission, buyerCommission, sellerCommission: Int
    var canTrade, canWithdraw, canDeposit: Bool
    var updateTime: Int
    var accountType: String
    var balances: [Balance]
    var permissions: [String]
    
//    enum CodingKeys: String, CodingKey {
//        case makerCommission, takerCommission, buyerCommission, sellerCommission, canTrade, canWithdraw, canDeposit, updateTime, accountType, balances, permissions
//    }
}

struct Balance: Codable {
    var asset, free, locked: String
    
//    enum CodingKeys: String, CodingKey {
//        case asset, free, locked
//    }
}
