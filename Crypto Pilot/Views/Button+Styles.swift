//
//  Button.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 25/05/2021.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(configuration.isPressed ? Color.altBlue() : Color.blue())
            .foregroundColor(Color.white())
            .cornerRadius(100)
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(configuration.isPressed ? Color.white() : Color.gray())
            .foregroundColor(Color.blue())
            .cornerRadius(100)
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Preview") {}
                .buttonStyle(PrimaryButton())
            Button("Preview") {}
                .buttonStyle(SecondaryButton())
        }
    }
}
