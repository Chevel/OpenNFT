//
//  SettingsModel.swift
//  LootBox
//
//  Created by Matej on 27. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)

import Foundation

@Observable
final class AppUiModel {

    // MARK: - Navigation

    var currentScreen: MainScreenType = {
        if UserDefaults.standard.bool(forKey: UserDefaults.OpenNftMacOSKey.wasOnboardingShown.rawValue) {
            .main
        } else {
            .onboarding
        }
    }()
    
    // MARK: - Export
    
    var exportedIndex: Int = 0

    // MARK: - Promo

    var isMobilePromoActive = true
    
    // MARK: - Workspace

    var isSavingWorkspace = false
    var isLoadingWorkspace = false

    // MARK: - Paywall

    var shouldShowPaywall = false
    var shouldShowMintUnavailable = false

    // MARK: - Alert

    var shouldShowSuccessAlert = false
    var isExporting = false
    {
        didSet {
            // reset on export start
            if isExporting {
                error = nil
                shouldShowSuccessAlert = false
            }
        }
    }
    
    var shouldShowErrorAlert = false
    var error: DisplayableError?
    {
        didSet {
            Task(priority: .userInitiated) {
                await MainActor.run { shouldShowErrorAlert = error != nil }
            }
        }
    }
    
    var shouldShowAlert = false
    var alert: AppAlert?
    {
        didSet {
            Task(priority: .userInitiated) {
                await MainActor.run { shouldShowAlert = alert != nil }
            }
        }
    }
}

// MARK: - ScreenType

extension AppUiModel {
    
    enum MainScreenType: Identifiable, Hashable {
        
        // MARK: - Login
        
        case onboarding
        
        // MARK: - Main
        
        case main
    }
}

// MARK: - Identifiable

extension AppUiModel.MainScreenType {

    var id: String {
        switch self {
        case .onboarding: return "onboarding"
        case .main: return "main"
        }
    }
}
#endif
