//
//  RebalanceView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 02/07/2021.
//

import SwiftUI

struct RebalanceConfirmationView: View {
    @ObservedObject var viewModel = RebalanceConfirmationViewModel()
    @Binding var viewState: RebalanceViewState
    
    var body: some View {
        ZStack {
            
            // Background color
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack {
                Spacer().frame(height: 50)
                
                // Last rebalance
                HStack(spacing: 10) {
                    Text("Last rebalance")
                        .foregroundColor(.white())
                    Text(viewModel.lastRebalanceDateText)
                        .foregroundColor(.white())
                    Spacer()
                }
                Spacer().frame(height: 12)
                
                // Next rebalance
                HStack(spacing: 10) {
                    Text("Next rebalance")
                        .foregroundColor(.white())
                    Text(viewModel.nextRebalanceDateText)
                        .foregroundColor(.white())
                    Spacer()
                }
                Spacer().frame(height: 50)
                
                // Countdown text
                Text(viewModel.countdownText ?? "")
                    .foregroundColor(.white())
                    .font(.title)
                Spacer().frame(height: 44)
                
                // Button
                Button("Rebalance Now") {
                    viewState = .rebalanceInProgress
                }
                .buttonStyle(PrimaryButton())
                .disabled(!viewModel.rebalanceAllowed)
                
                // Spacer to push content up
                Spacer()
            }
            .padding(.horizontal, 16)
            
        }
    }
}

struct RebalanceConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        RebalanceConfirmationView(viewState: .constant(.confirmation))
    }
}
