//
//  Analytics.swift
//  LootBox
//
//  Created by Matej on 10/03/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation
import Mixpanel

enum Analytics {
    
    enum Event {
        case onboardingStarted
        case onboardingStepCompleted
        case onboardingPageProfileSelection
        case onboardingDone

        case addTraitButtonPressed
        case removeTraitButtonPressed
        case removeCanvasTraitButtonPressed

        case resetRotationButtonPressed
        
        case dragDropStart
        case dragDropEnd
        
        case workspaceSave
        case workspaceLoad

        case exportStartPressed
        case exportCancelPressed
        case exportSuccess
        case exportFinished
        case exportAddedCollection
        case exportAddedCollectionFailed
        
        case exportMenuOptionPressed
        
        case upgradeNowPressed
        case shareButtonPressed
        case rateButtonPressed
        case oddsSliderChanged

        case layerPositionChange

        case paywallShown
        case subscriptionPurchase
        case subscriptionRestored

        case toggleTraitImageFramePressed
        
        case numberOfNftMore
        case numberOfNftLess
        
        case mintButtonPressed
        case mintMenuOptionPressed
        case polygonImagePressed
        case polygonWalletImagePressed

        var name: String {
            switch self {
            case .onboardingStarted: return "Onboarding - Start"
            case .onboardingStepCompleted: return "Onboarding - Step"
            case .onboardingDone: return "Onboarding - Done"
            case .onboardingPageProfileSelection: return "Onboarding - Page - Profile"

            case .addTraitButtonPressed: return "Action - Button - Add Trait"
            case .removeTraitButtonPressed: return "Action - Button - Remove Trait"
            
            case .removeCanvasTraitButtonPressed: return "Action - CanvasButton - Remove Trait"
            case .resetRotationButtonPressed: return "Action - CanvasButton - Reset Rotation"
            
            case .exportStartPressed: return "Action - Export - Start"
            case .exportCancelPressed: return "Action - Export - Cancel"
            case .exportSuccess: return "Status - Export - Success"
            case .exportFinished: return "Status - Export - Finished"
            case .exportAddedCollection: return "Status - Export - Added Collection"
            case .exportAddedCollectionFailed: return "Status - Export - Added Collection - Fail"
            case .exportMenuOptionPressed: return "Action - Menu option - Export"
            case .upgradeNowPressed: return "Action - Button - Upgrade"
            case .shareButtonPressed: return "Action - Button - Share"
            case .dragDropStart: return "Action - Drag&Drop Trait - Start"
            case .dragDropEnd: return "Action - Drag&Drop Trait - End"
            case .layerPositionChange: return "Action - Button - Layer position"
            case .rateButtonPressed: return "Action - Button - Rate"
            case .paywallShown: return "Alert - Paywall"
            case .toggleTraitImageFramePressed: return "Action - Checkbox - Image frame"
            case .numberOfNftMore: return "Action - NumberOfNFT - More"
            case .numberOfNftLess: return "Action - NumberOfNFT - Less"
            case .mintButtonPressed: return "Action - Button - MINT"
            case .mintMenuOptionPressed: return "Action - Menu option - MINT"
            case .polygonImagePressed: return "Action - Button - Polygon"
            case .polygonWalletImagePressed: return "Action - Button - Polygon wallet"
            case .oddsSliderChanged: return "Action - Slider - Changed"
            case .workspaceSave: return "Action - Workspace - Save"
            case .workspaceLoad: return "Action - Workspace - Load"
            
            case .subscriptionPurchase: return "Event - Subscription - Purchase"
            case .subscriptionRestored: return "Event - Subscription - Restore"
            }
        }
    }
    
    static func setup() {
#if os(macOS)
        let mixpanel = Mixpanel.initialize(token: Bundle.mixpanelApiKey_macOS)
#elseif os(iOS)
        let mixpanel = Mixpanel.initialize(token: Bundle.mixpanelApiKey_iOS, trackAutomaticEvents: true)
#endif
        mixpanel.serverURL = "https://api-eu.mixpanel.com"
        
#if os(macOS)
        mixpanel.registerSuperProperties(Properties(dictionaryLiteral: ("AppVersion", AppSettings.Version.isPro ? "PRO" : "FREE")))
#elseif os(iOS)
        mixpanel.registerSuperProperties(Properties(dictionaryLiteral: ("AppVersion", "Mobile")))
#endif
    }

    static func track(event: Analytics.Event, data: [String: MixpanelType]? = nil) {
        guard !AppSettings.isDevEnvironment else { return }
        guard !Mixpanel.mainInstance().hasOptedOutTracking() else { return }

        Mixpanel.mainInstance().track(event: event.name, properties: data)
    }
    
    static func startStopwatchFor(event: Analytics.Event) {
        guard !AppSettings.isDevEnvironment else { return }
        guard !Mixpanel.mainInstance().hasOptedOutTracking() else { return }
    
        Mixpanel.mainInstance().time(event: event.name)
    }
}
