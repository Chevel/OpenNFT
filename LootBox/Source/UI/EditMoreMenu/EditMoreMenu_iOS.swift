//
//  EditMoreMenu.swift
//  OpenNFT
//
//  Created by Matej on 2. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import RevenueCatUI

struct EditMoreMenu: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager

    @Binding var trait: TraitModel
    @State private var isPaywallShown = false
    @State private var wasLimitReached = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            layerSettings
            raritySettings
            if trait.imagesData.first(where: { $0.isSelected }) != nil {
                selectedTraitValueSettings
                    .padding(.bottom, 16)
            }
        }
        .padding(8)
        .padding(.bottom, 16)
        .sheet(isPresented: $isPaywallShown) {
            PaywallView(displayCloseButton: true)
                .frame(height: UIScreen.main.bounds.height * (UIDevice.current.isIpad ? 0.7 : 0.9))
                .onAppear { Analytics.track(event: .paywallShown) }
        }
    }
}

private extension EditMoreMenu {
    
    @ViewBuilder
    var raritySettings: some View {
        if let binding = $trait.imagesData.first(where: { $0.isSelected.wrappedValue })?.odds {
            OddsSliderView(odds: binding, color: Color.Palette.primary)
        } else {
            EmptyView()
        }
    }
    
    var layerSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image.SFSymbols.Edit.layer
                    .foregroundStyle(Color.Palette.Foreground.primary)
                    .frame(width: 40, height: 40)
                    .scaledToFit()
                Text("\(Int(trait.zIndex))")
                    .font(Font.Pallete.text)
                    .foregroundStyle(Color.Palette.Foreground.primary)
            }

            if wasLimitReached && !appStateManager.isUnlocked {
                UpsellButton(title: "paywall_upsell_text_layer") {
                    isPaywallShown = true
                }.padding(.vertical, 4)
            }

            Slider(value: $trait.zIndex, in: -25...25)
                .tint(Color.Palette.primary)
                .onChange(of: trait.zIndex) { oldValue, newValue in
                    guard !appStateManager.isUnlocked else {
                        return
                    }
                    if newValue < -5 {
                        trait.zIndex = -5
                        wasLimitReached = true
                    }
                    if newValue > 5 {
                        trait.zIndex = 5
                        wasLimitReached = true
                    }
                }
        }
    }
    
    // set the value of the image (ie. "blue" for eyes trait)
    var selectedTraitValueSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("trait_settings_value_name")
                .font(Font.Pallete.infoText)
                .foregroundStyle(Color.Palette.Foreground.primary)

            TextField("", text: $trait.selectedImageName)
                .placeholder("trait_settings_value_name_placeholder", when: trait.selectedImageName.isEmpty)
                .font(Font.Pallete.text)
                .foregroundStyle(Color.Palette.Foreground.primary)
                .padding(8)
                .background(Color.Palette.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .submitLabel(.done)
        }
    }
}
#endif
