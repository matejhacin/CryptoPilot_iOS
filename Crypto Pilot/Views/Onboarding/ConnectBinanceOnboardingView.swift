//
//  ConnectBinanceOnboarding.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

struct ConnectBinanceOnboardingView: View {
    @State var binanceKey = ""
    @State var binanceSecretKey = ""
    
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
                
                // Title
                HStack {
                    Spacer()
                    Text("Connect to Binance")
                        .foregroundColor(.white())
                        .font(.headline)
                    Spacer()
                }
                
                // Subtitle
                Text("Once you have a Binance account, generate your API keys and input them below.")
                    .foregroundColor(.white())
                    .font(.callout)
                
                // Form
                VStack(alignment: .center, spacing: 16) {
                    TextField("Binance key", text: $binanceKey)
                    TextField("Binance secret key", text: $binanceSecretKey)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal, 12)
                .background(Color.altGray())
                .cornerRadius(32)
                
                // Link to instructions
                Text("How to set up API Keys?")
                    .foregroundColor(.white())
                    .font(.callout)
                    .underline()
                
                // Confirm button
                HStack {
                    Spacer()
                    Button("Confirm Keys") {
                        // TODO Figure out how to change root view
                    }
                    .buttonStyle(PrimaryButton())
                    .offset(y: 24)
                    Spacer()
                }
                
                // Push content up
                Spacer()
            }
            .padding()
        }
        .hideNavigation()
    }
}

struct ConnectBinanceOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        ConnectBinanceOnboardingView()
    }
}
