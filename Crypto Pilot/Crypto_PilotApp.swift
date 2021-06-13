//
//  Crypto_PilotApp.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI
import Firebase

@main
struct Crypto_PilotApp: App {
    @ObservedObject var authState = AuthState.shared
    
    init() {
        ExchangeInfo.shared.update()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authState.isAuthenticated {
                    HomeView(viewModel: HomeViewModel())
                } else {
                    WelcomeOnboardingView()
                }
            }
//            HomeView()
//            .transition(.opacity)
//            .animation(.easeInOut, value: true)
        }
    }
}
