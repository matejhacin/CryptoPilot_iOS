//
//  ExplanationOnboardingView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

struct ExplanationOnboardingView: View {
    @State var navigateToNextView = false
    
    var body: some View {
        ZStack {
            // Background
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack(alignment: .leading, spacing: 32) {
                
                // Logo
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                    Spacer()
                }
                
                // Top texts
                HStack {
                    Spacer()
                    Text("How do we do it?")
                        .foregroundColor(.white())
                        .font(.headline)
                    Spacer()
                }
                
                Text("Crypto Pilot connects to Your Binance Exchange account via the API.\n\nWe use the exchange API to programatically execute trades. We do not have account withdrawal permission and all user data is is encrypted.\n\nIn order to connect to your exchange account, we'll need permissions to do so. That's why we need API keys setup.\n\nNote that you have full control over your API keys. You can delete them on the exchange at any time. We also recommend limiting withdrawal permissions so API keys are trade-only.")
                    .foregroundColor(.white())
                    .font(.callout)
                
                HStack {
                    Spacer()
                    NavigationLink("", destination: ConnectBinanceOnboardingView(), isActive: $navigateToNextView).hidden()
                    Button("Ok! Continue") {
                        navigateToNextView = true
                    }
                    .buttonStyle(PrimaryButton())
                    .offset(y: 24)
                    Spacer()
                }
                
                // Spacer to push everything up
                Spacer()
            }
            .padding()
        }
        .hideNavigation()
    }
}

struct ExplanationOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationOnboardingView()
    }
}
