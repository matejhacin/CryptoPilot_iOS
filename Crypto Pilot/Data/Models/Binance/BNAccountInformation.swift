//
//  BNAccountInformation.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation

struct BNAccountInformation: Codable {
    let makerCommission, takerCommission, buyerCommission, sellerCommission: Int
    let canTrade, canWithdraw, canDeposit: Bool
    let updateTime: Int
    let accountType: String
    let balances: [Balance]
    let permissions: [String]
}

struct Balance: Codable {
    let asset, free, locked: String
}
