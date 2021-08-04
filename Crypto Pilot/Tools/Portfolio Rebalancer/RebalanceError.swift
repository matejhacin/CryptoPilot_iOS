//
//  RebalanceError.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 04/08/2021.
//

import Foundation

struct RebalanceError: LocalizedError {
    var errorDescription: String?
    
    init(_ message: String) {
        self.errorDescription = message
    }
}
