//
//  SettingsView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 30/06/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            
            // Background
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack {
                Spacer()
                Text("Zupan gay")
                    .foregroundColor(.white())
                Spacer()
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
