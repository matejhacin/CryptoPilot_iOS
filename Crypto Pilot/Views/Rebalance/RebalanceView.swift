//
//  RebalanceView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 02/07/2021.
//

import SwiftUI

struct RebalanceView: View {
    @Binding var presentedAsModal: Bool
    @State var viewState = RebalanceViewState.confirmation
    
    var body: some View {
        ZStack {
            
            // Background color
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack {
                Spacer()
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 2.5)
                    .foregroundColor(.black)
                
                Group {
                    switch (viewState) {
                    case .confirmation:
                        RebalanceConfirmationView(viewState: $viewState)
                    case .rebalanceInProgress:
                        RebalanceProgressView(viewState: $viewState, presentedAsModal: $presentedAsModal)
                    case .notificationPermission:
                        NotificationsPermissionView(presentedAsModal: $presentedAsModal)
                    }
                }
                .transition(.opacity)
                .animation(.linear)
            }
        }
    }
}

struct RebalanceView_Previews: PreviewProvider {
    
    static var previews: some View {
        RebalanceView(presentedAsModal: .constant(true))
    }
}
