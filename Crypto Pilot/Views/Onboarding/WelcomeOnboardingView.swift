//
//  WelcomeOnboardingView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

struct WelcomeOnboardingView: View {
    var body: some View {
        ZStack {
            // Background Color
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
                    Text("Welcome to Crypto Pilot")
                        .foregroundColor(Color.white())
                        .font(.headline)
                    Spacer()
                }
                
                Text("Crypto Pilot is a quick and simple solution that enables users to index the crypto market and automatically rebalance their porfolio.")
                    .foregroundColor(Color.white())
                    .font(.callout)
                
                Text("If you would like to learn more on CP works check it out here.")
                    .foregroundColor(Color.white())
                    .font(.callout)
                
                // FAQ Button
                HStack {
                    Spacer()
                    Button("I would like to learn more") {
                        
                    }
                    .buttonStyle(SecondaryButton())
                    Spacer()
                }
                
                // Final text
                Text("Or let’s just go ahead and setup your Crypto Pilot and start rebalancing straight away.")
                    .foregroundColor(Color.white())
                    .font(.callout)
                
                // Call to action
                HStack {
                    Spacer()
                    Button("Set me up!") {
                        
                    }
                    .buttonStyle(PrimaryButton())
                    Spacer()
                }
                
                // Spacer to push everything up
                Spacer()
            }
            .padding()
        }
    }
}

struct WelcomeOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeOnboardingView()
    }
}
