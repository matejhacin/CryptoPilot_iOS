//
//  UserManager.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 08/04/2021.
//

import Foundation
import Combine

class AuthState: ObservableObject {
    
    @Published var apiKey: String?
    @Published var secretKey: String?
    @Published var isAuthenticated = false
    
    static let shared = AuthState()
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadApiKeys()
    }
    
    private func loadApiKeys() {
        apiKey = userDefaults.string(forKey: "apiKey")
        secretKey = userDefaults.string(forKey: "secretKey")
        isAuthenticated = apiKey != nil && secretKey != nil
    }
    
    func saveApiKeys(apiKey: String, secretKey: String) {
        userDefaults.setValue(apiKey, forKey: "apiKey")
        userDefaults.setValue(secretKey, forKey: "secretKey")
        loadApiKeys()
    }
    
    func resetApiKeys() {
        userDefaults.setValue(nil, forKey: "apiKey")
        userDefaults.setValue(nil, forKey: "secretKey")
        loadApiKeys()
    }
    
    // Hacin
    //    let binanceApiKey = "sEOBB9W6EbvHFGLobrHvRle1rTiqsqLAQX4YC5lijaqleegKprrR3VuaJgVuxzH9"
    //    let binanceSecretKey = "4P5gg7Jshu50XlxCBC6yIBnF9jTztkarjGlTZ1UOejKfr53m0kizCr6uxkUl6Yr3"
    
    // Zupan
    //    let binanceApiKey = "Qkke8KA2vEd8JrNlxPgke6kt5AVBcE6dNkSVqcZ3uBMZNuW7wrOnAQstcyGULDoJ"
    //    let binanceSecretKey = "MxVvCbWJ8J0CPlHIH4fHKXiFN1gKbRtakItpIrvHhFEN4Azi5QhKyW9F82Gj0DSk"
    
}
