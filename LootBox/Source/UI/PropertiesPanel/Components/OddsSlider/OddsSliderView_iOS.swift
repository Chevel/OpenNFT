//
//  OddsView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import RevenueCatUI

struct OddsSliderView: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPaywallShown = false
    @State private var wasLimitReached = false

    @Binding var odds: Double
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(Font.Pallete.infoText)
                    .foregroundStyle(Color.Palette.Foreground.primary)
            }

            if wasLimitReached && !appStateManager.isUnlocked {
                UpsellButton(title: "paywall_upsell_text_slider") {
                    isPaywallShown = true
                }.padding(.vertical, 4)
            }

            Slider(value: $odds, in: 0...100)
                .tint(color)
                .onChange(of: odds) { oldValue, newValue in
                    if !appStateManager.isUnlocked && newValue < 60 {
                        odds = 61
                        wasLimitReached = true
                    }
                }
        }
        .sheet(isPresented: $isPaywallShown) {
            PaywallView(displayCloseButton: true)
                .frame(height: UIScreen.main.bounds.height * (UIDevice.current.isIpad ? 0.7 : 0.9))
                .onAppear { Analytics.track(event: .paywallShown) }
        }
    }
    
    private var title: String {
        String(localized: LocalizedStringResource(stringLiteral: rarityTitle(odds: odds)))
        + " "
        + "(" + String(format: "%0.2f", odds) + "%)"
    }
    
    private func rarityTitle(odds: Double) -> String {
        switch odds {
        case 0 ..< 20: "trait_settings_legendary"
        case 20 ..< 40: "trait_settings_epic"
        case 40 ..< 60: "trait_settings_rare"
        case 60 ..< 80: "trait_settings_uncommon"
        case 80 ... 100: "trait_settings_common"
        default: ""
        }
    }
}
#endif
