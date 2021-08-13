//
//  SettingsView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 30/06/2021.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    private let viewModel = SettingsViewModel()
    
    @Environment(\.openURL) private var openURL
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isShowingApiKeysAlert = false
    
    var body: some View {
        ZStack {
            
            // Background
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack {
                
                // Logo
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                    Spacer()
                }
                Spacer().frame(height: 5)
                
                // Top divider
                Divider()
                    .background(Color.darkGray())
                
                // Content
                SettingButton(title: "Remove or change API keys") {
                    isShowingApiKeysAlert = true
                }
                .alert(isPresented: $isShowingApiKeysAlert, content: {
                    Alert(title: Text("Are you sure?"), message: Text("You're about to remove your API keys and disconnect from your Binance portfolio. If you wish to reconnect, you will be able to do it after this step."), primaryButton: .destructive(Text("Yes, remove"), action: {
                        Tracking.buttonClick(.removeApiKeys, on: .settings)
                        viewModel.unlinkApiKeys()
                    }), secondaryButton: .cancel())
                })
                SettingButton(title: "About Us") {
                    Tracking.buttonClick(.aboutUs, on: .settings)
                    openURL(viewModel.aboutURL)
                }
                SettingButton(title: "FAQ") {
                    Tracking.buttonClick(.faq, on: .settings)
                    openURL(viewModel.faqURL)
                }
                SettingButton(title: "Terms & Conditions") {
                    Tracking.buttonClick(.termsAndConditions, on: .settings)
                    openURL(viewModel.termsURL)
                }
                SettingButton(title: "Privacy Policy") {
                    Tracking.buttonClick(.privacyPolicy, on: .settings)
                    openURL(viewModel.privacyURL)
                }
                SettingButton(title: "Feedback / Bugs Report") {
                    Tracking.buttonClick(.feedback, on: .settings)
                    isShowingMailView.toggle()
                }
                
                // Push content up
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: $result) { composer in
                    composer.setSubject("Feedback")
                    composer.setToRecipients(["info@getcryptopilot.com"])
                }
            }
        }
        .onAppear(perform: {
            Tracking.viewOpened(.settings)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingButton: View {
    var title: String
    var subtitle: String?
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack() {
                Text(title)
                    .foregroundColor(.white())
                Spacer()
                Text(subtitle ?? "")
                    .foregroundColor(.lightBlue())
                Spacer()
                    .frame(width: 20)
                Image("arrow_right")
                    .resizable()
                    .frame(width: 17, height: 17)
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
            Divider()
                .background(Color.darkGray())
        }
        .frame(height: 60)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
