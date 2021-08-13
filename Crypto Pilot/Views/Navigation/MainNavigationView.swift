//
//  MainNavigationView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 30/06/2021.
//

import SwiftUI

enum MainNavigationState {
    case home
    case settings
}

struct MainNavigationView: View {
    @ObservedObject var viewModel = MainNavigationViewModel()
    @State var navState = MainNavigationState.home
    @State var presentingRebalanceModal = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Main content
            switch navState {
            case .home:
                HomeView(viewModel: HomeViewModel())
            case .settings:
                SettingsView()
            }
            
            // Navigation
            ZStack {
                // Main Buttons
                HStack {
                    MainNavigationButton(image: Image("home"), isSelected: navState == .home) {
                        navState = .home
                    }
                    Spacer().frame(width: 56)
                    MainNavigationButton(image: Image("settings"), isSelected: navState == .settings) {
                        navState = .settings
                    }
                }
                
                // Rebalance Button
                ZStack {
                    Circle()
                        .strokeBorder(Color.blakish(), lineWidth: 1)
                        .background(Circle().foregroundColor(viewModel.rebalanceAvailable ? .blue() : .gray()))
                        .frame(width: 72, height: 72)
                    Image("rebalance")
                        .foregroundColor(viewModel.rebalanceAvailable ? .white() : .lightBlue())
                }
                .offset(y: -32)
                .onTapGesture {
                    Tracking.buttonClick(.rebalance, on: .home)
                    presentingRebalanceModal = true
                }
                .sheet(isPresented: $presentingRebalanceModal, content: {
                    RebalanceView(presentedAsModal: $presentingRebalanceModal)
                })
            }
            .frame(height: 90)
            .background(Color.altGray())
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}

struct MainNavigationButton: View {
    var image: Image
    var isSelected: Bool
    var onTap: (() -> Void)
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(isSelected ? .blue() : .white())
                    .offset(y: -10)
                Spacer()
            }
            Spacer()
        }
        .onTapGesture {
            onTap()
        }
    }
}
