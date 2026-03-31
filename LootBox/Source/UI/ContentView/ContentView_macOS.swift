//
//  ContentView.swift
//  LootBox
//
//  Created by Matej on 22. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        switch appStateManager.uiModel.currentScreen {
        case .onboarding:
            OnboardingView()
                .ignoresSafeArea(.all)
                .onAppear { Analytics.track(event: .onboardingStarted) }

        case .main:
            MainView().navigationBarBackButtonHidden(true)
        }
    }
}
#endif
