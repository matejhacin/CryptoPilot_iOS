//
//  BaseError.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 10/08/2021.
//

import Foundation

struct CPError: LocalizedError {
    var errorDescription: String?
    
    init(_ message: String) {
        self.errorDescription = message
    }
}
