//
//  BNOrder.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 10/05/2021.
//

import Foundation

struct BNOrder: Codable {
    var symbol: String
    var orderId, orderListId: Int
    var clientOrderId: String
    var transactTime: Int
    var price, origQty, executedQty, cummulativeQuoteQty: String
    var status, timeInForce, type, side: String
    var fills: [Fill]
    
    struct Fill: Codable {
        var price, qty, commission, commissionAsset: String
    }
}
