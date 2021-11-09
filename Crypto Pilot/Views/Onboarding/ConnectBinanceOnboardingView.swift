//
//  ConnectBinanceOnboarding.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

struct ConnectBinanceOnboardingView: View {
    
    @ObservedObject var viewModel = ConnectBinanceOnboardingViewModel()
    @Environment(\.openURL) private var openURL
    @State var binanceKey = ""
    @State var binanceSecretKey = ""
    @State var permissionGiven = false
    
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
                Text("Input your Binance read-only API keys here.")
                    .foregroundColor(.white())
                    .font(.callout)
                
                // Form
                VStack(alignment: .center, spacing: 16) {
                    TextField("Binance key", text: $binanceKey)
                        .preferredColorScheme(.dark)
                        .foregroundColor(.white())
                        .accentColor(.white())
                    TextField("Binance secret key", text: $binanceSecretKey)
                        .preferredColorScheme(.dark)
                        .foregroundColor(.white())
                        .accentColor(.white())
                    Toggle("Give Crypto Pilot permision to display your portfolio", isOn: $permissionGiven)
                        .font(.callout)
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
                    .onTapGesture {
                        Tracking.buttonClick(.tutorial, on: .onboardingConnectExchange)
                        openURL(viewModel.tutorialURL)
                    }
                
                // Confirm button
                HStack {
                    Spacer()
                    if viewModel.isCheckingApiKeys {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white()))
                            .offset(y: 24)
                    } else {
                        Button("Confirm Keys") {
                            Tracking.buttonClick(.confirmApiKeys, on: .onboardingConnectExchange)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            viewModel.saveApiKeys(apiKey: binanceKey, secretKey: binanceSecretKey)
                        }
                        .buttonStyle(PrimaryButton())
                        .offset(y: 24)
                        .disabled(binanceKey == "" || binanceSecretKey == "" || !permissionGiven)
                    }
                    Spacer()
                }
                
                // Error message
                if viewModel.errorMsg != nil {
                    HStack {
                        Spacer()
                        Text(viewModel.errorMsg!)
                            .foregroundColor(.red())
                        Spacer()
                    }
                    .offset(y: 24)
                }
                
                // Push content up
                Spacer()
            }
            .padding()
        }
        .hideNavigation()
        .onAppear(perform: {
            Tracking.viewOpened(.onboardingConnectExchange)
        })
    }
}

struct ConnectBinanceOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        ConnectBinanceOnboardingView()
    }
}
