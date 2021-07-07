//
//  Button.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 25/05/2021.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MyButton(configuration: configuration)
    }
    
    struct MyButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(isEnabled ? (configuration.isPressed ? Color.altBlue() : Color.blue()) : Color.gray())
                .foregroundColor(isEnabled ? Color.white() : Color.lightBlue())
                .cornerRadius(100)
        }
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
            Button("Primary") {}
                .buttonStyle(PrimaryButton())
            Button("Primary disabled") {}
                .buttonStyle(PrimaryButton())
                .disabled(true)
            Button("Secondary") {}
                .buttonStyle(SecondaryButton())
        }
    }
}
