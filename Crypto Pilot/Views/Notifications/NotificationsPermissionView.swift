//
//  Notifications.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 02/07/2021.
//

import SwiftUI
import Combine

struct NotificationsPermissionView: View {
    @ObservedObject var viewModel = NotificationsPermissionViewModel()
    @Binding var presentedAsModal: Bool
    var body: some View {
        ZStack {
            
            // Background color
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack(alignment: .leading, spacing: 50) {
                
                // Title
                HStack {
                    Spacer()
                    Text("Allow Notifications")
                        .foregroundColor(.white())
                        .font(.title)
                    Spacer()
                }
                
                // Image
                HStack {
                    Spacer()
                    Image("notification_permissions")
                        .resizable()
                        .frame(width: 194, height: 194)
                    Spacer()
                }
                
                // Text
                Text("We would like to notify you when your next rebalance is available. For that, please select “Allow” to recieve notifications.")
                    .foregroundColor(.white())
                
                Spacer()
                
                // Button
                HStack {
                    Spacer()
                    Button("Next") {
                        viewModel.requestNotificationsPermission { isAllowed in
                            Tracking.notificationPermission(isAllowed: isAllowed)
                            presentedAsModal = false
                        }
                    }
                    .buttonStyle(PrimaryButton())
                    Spacer()
                }
                
            }
            .padding()
            .onAppear {
                Tracking.viewOpened(.notificationPermission)
            }
        }
    }
}

struct NotificationsPermission_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPermissionView(presentedAsModal: .constant(false))
    }
}
