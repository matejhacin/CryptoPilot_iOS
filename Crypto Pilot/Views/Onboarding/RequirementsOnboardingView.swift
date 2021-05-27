//
//  RequirementsOnboardingView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

struct RequirementsOnboardingView: View {
    var body: some View {
        ZStack {
            // Background color
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
                    Text("What you'll need")
                        .foregroundColor(.white())
                        .font(.headline)
                    Spacer()
                }
                
                Text("1.) Binance account\n\n2.) Minimum sum cash on your account\n\n3.) Crypto Pilot rebalances your complete portfolio. Please make sure that we can rebalance contents of your portfolio.\n\n4.) Binance API keys")
                    .foregroundColor(.white())
                    .font(.callout)
                
                Text("Dont have a Binance Account?\n(https://accounts.binance.com/en/register?)")
                    .foregroundColor(.white())
                    .font(.callout)
                    .underline()
                    .onTapGesture {
                        // TODO Open binance tutorial/website
                    }
                
                HStack {
                    Spacer()
                    Button("Ok! Continue") {
                        
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
    }
}

struct RequirementsOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementsOnboardingView()
    }
}
