//
//  CryptographyTools.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation
import CryptoKit

class CryptographyTools {
    
    static func hmacSHA256(text: String, secret: String) -> String {
        let key = SymmetricKey(data: secret.data(using: .utf8)!)
        let signature = HMAC<SHA256>.authenticationCode(for: text.data(using: .utf8)!, using: key)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
    
}
