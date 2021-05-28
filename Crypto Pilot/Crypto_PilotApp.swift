//
//  Crypto_PilotApp.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI

@main
struct Crypto_PilotApp: App {
    @ObservedObject var authState = AuthState.shared
    
    init() {
        ExchangeInfo.shared.update()
    }
    
    var body: some Scene {
        WindowGroup {
            if authState.isAuthenticated {
                RebalanceProgressView()
            } else {
                WelcomeOnboardingView()
            }
        }
    }
}
