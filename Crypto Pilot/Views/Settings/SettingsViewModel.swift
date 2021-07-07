//
//  SettingsViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 06/07/2021.
//

import Foundation

class SettingsViewModel {
    
    private let authState: AuthState
    
    let aboutURL = URL(string: "https://getcryptopilot.com")!
    let faqURL = URL(string: "https://getcryptopilot.com/faq/")!
    let termsURL = URL(string: "https://getcryptopilot.com/terms-conditions/")!
    let privacyURL = URL(string: "https://getcryptopilot.com/privacy-policy/")!
    
    init(authState: AuthState = AuthState.shared) {
        self.authState = authState
    }
    
    func unlinkApiKeys() {
        authState.resetApiKeys()
    }
    
}
