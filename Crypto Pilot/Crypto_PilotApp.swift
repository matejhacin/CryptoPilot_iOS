//
//  Crypto_PilotApp.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI
import Firebase
import Mixpanel

@main
struct Crypto_PilotApp: App {
    @ObservedObject var authState = AuthState.shared
    
    // On MainView, we are showing the last value of the portfolio (so the user can see the difference)
    // We cache this value here on app startup in order to display the same value throughout the app lifecycle.
    static let lastPortfolioValue = PortfolioValueRepository().getPortfolioValue()
    
    init() {
        ExchangeInfo.shared.update()
        FirebaseApp.configure()
        Mixpanel.initialize(token: Constants.MixPanel.PROJECT_TOKEN)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authState.isAuthenticated {
                    MainNavigationView()
                } else {
                    WelcomeOnboardingView()
                }
            }
        }
    }
}
