//
//  Crypto_PilotApp.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI

@main
struct Crypto_PilotApp: App {
    init() {
        ExchangeInfo.shared.update()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeOnboardingView()
        }
    }
}
