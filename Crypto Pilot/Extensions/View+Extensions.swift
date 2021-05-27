//
//  View+Extensions.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 27/05/2021.
//

import SwiftUI

extension View {
    func hideNavigation() -> some View {
        return navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
