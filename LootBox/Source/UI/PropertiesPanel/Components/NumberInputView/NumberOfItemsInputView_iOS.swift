//
//  NumberInputView.swift
//  LootBox
//
//  Created by Matej on 23/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import RevenueCatUI

struct NumberOfItemsInputView: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    @State private var isPaywallShown = false

    var focusField: FocusState<SettingsMenu.Field?>.Binding

    var body: some View {
        @Bindable var model = appStateManager

        VStack(alignment: .leading) {
            Text("settings_number_of_nfts")
                .font(Font.Pallete.infoText)
                .foregroundStyle(Color.Palette.Foreground.primary)

            if appStateManager.isMaxExportLimitReached && !appStateManager.isUnlocked {
                UpsellButton(title: "paywall_upsell_text_export") {
                    isPaywallShown = true
                }.padding(.vertical, 4)
            }

            TextField("", value: $model.numberOfItems, formatter: formatter)
                .font(Font.Pallete.text)
                .foregroundStyle(Color.Palette.Foreground.primary)
                .focused(focusField, equals: .numberOfNft)
                .padding(8)
                .background(Color.Palette.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .keyboardType(.numberPad)
        }
        .sheet(isPresented: $isPaywallShown) {
            PaywallView(displayCloseButton: true)
                .frame(height: UIScreen.main.bounds.height * (UIDevice.current.isIpad ? 0.7 : 0.9))
                .onAppear { Analytics.track(event: .paywallShown) }
        }
    }
}

private extension NumberOfItemsInputView {
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 0
//        formatter.maximum = NSNumber(integerLiteral: AppSettings.Feature.exportLimit)
        formatter.allowsFloats = false
        formatter.numberStyle = .none
        return formatter
    }
}
#endif
