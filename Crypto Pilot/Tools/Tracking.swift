//
//  Tracking.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 13/08/2021.
//

import Foundation
import Mixpanel

class Tracking {
    
    static func buttonClick(_ button: Button, on view: View) {
        Mixpanel.mainInstance().track(event: "Button Click",
                                      properties: ["Button" : button.rawValue, "View" : view.rawValue])
    }
    
    static func viewOpened(_ view: View) {
        Mixpanel.mainInstance().track(event: "View Open",
                                      properties: ["View" : view.rawValue])
    }
    
    static func notificationPermission(isAllowed: Bool) {
        Mixpanel.mainInstance().track(event: "Notification Permission Change",
                                      properties: ["Allowed" : isAllowed])
    }
    
    enum View: String {
        case onboardingWelcome = "onboarding_welcome"
        case onboardingRequirements = "onboarding_requirements"
        case onboardingExplanation = "onboarding_explanation"
        case onboardingConnectExchange = "onboarding_connect_exchange"
        case home = "home"
        case settings = "settings"
        case rebalanceConfirmation = "rebalance_confirmation"
        case rebalanceProgress = "rebalance_progress"
        case notificationPermission = "notification_permission"
    }
    
    enum Button: String {
        case onboardingNext = "onboarding_next"
        case register = "register"
        case tutorial = "tutorial"
        case confirmApiKeys
        case rebalance = "rebalance"
        case removeApiKeys = "remove_api_keys"
        case aboutUs = "about_us"
        case faq = "faq"
        case termsAndConditions = "terms_and_conditions"
        case privacyPolicy = "privacy_policy"
        case feedback = "feedback"
    }
    
}
