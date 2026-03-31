//
//  ContentView.swift
//  LootBox
//
//  Created by Matej on 22. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import RevenueCatUI

struct ContentView: View {

    @Environment(AppStateManager.self) private var appStateManager: AppStateManager

    var body: some View {
        content
    }
}

// MARK: - UI

private extension ContentView {
    
    @ViewBuilder
    var content: some View {
        switch appStateManager.currentScreen {
        case .onboarding:
            OnboardingView()
                .ignoresSafeArea(.all)
                .onAppear { Analytics.track(event: .onboardingStarted) }

        case .main:
            @Bindable var model = appStateManager
            MainView()
                .presentPaywallIfNeeded(
                    requiredEntitlementIdentifier: "pro",
                    purchaseCompleted: { customerInfo in
                        Analytics.track(event: .subscriptionPurchase)
                    },
                    restoreCompleted: { customerInfo in
                        // Paywall will be dismissed automatically if "pro" is now active.
                        Analytics.track(event: .subscriptionRestored)
                    }
                )
        }
    }
}
#endif
