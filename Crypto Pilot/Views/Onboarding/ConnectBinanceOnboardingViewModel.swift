//
//  ConnectBinanceOnboardingViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 28/05/2021.
//

import Foundation
import Combine

class ConnectBinanceOnboardingViewModel: ObservableObject {
    
    @Published var isCheckingApiKeys = false
    @Published var errorMsg: String?
    
    private let authState = AuthState.shared
    private let bnb = BinanceClient()
    private var disposeBag = Set<AnyCancellable>()
    
    let tutorialURL = URL(string: "https://www.youtube.com/watch?v=Tx-MEZQEKXY&t=53s")!
    
    func saveApiKeys(apiKey: String, secretKey: String) {
        isCheckingApiKeys = true
        errorMsg = nil
        bnb.testConnection(apiKey: apiKey, secretKey: secretKey)
            .sink { response in
                self.isCheckingApiKeys = false
                if let _ = response.value {
                    self.authState.saveApiKeys(apiKey: apiKey, secretKey: secretKey)
                } else if let data = response.data, let error = try? JSONDecoder().decode(BNError.self, from: data) {
                    self.errorMsg = error.msg
                } else {
                    self.errorMsg = "Unknown error"
                }
            }.store(in: &disposeBag)
    }
    
}
