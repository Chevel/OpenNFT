//
//  PhoneButton.swift
//  LootBox
//
//  Created by Matej on 28. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct PhoneButton: View {
    
    @EnvironmentObject private var appStateManager: AppStateManager
    @Environment(\.openURL) private var openURL

    var body: some View {
        if #available(macOS 15.0, *) {
            Image.SFSymbols.iPhone
                .font(Font.Pallete.Button.mediumPlus)
                .foregroundStyle(Color.Palette.primary)
                .symbolEffect(.bounce.byLayer, options: .speed(0.15).repeat(.max), isActive: appStateManager.uiModel.isMobilePromoActive)
                .onTapGesture {
                    openURL(AppSettings.Constants.shareFreeVersionURL)
                    appStateManager.uiModel.isMobilePromoActive = false
                }
        } else {
            Image.SFSymbols.iPhone
                .font(Font.Pallete.Button.mediumPlus)
                .foregroundStyle(Color.Palette.primary)
                .symbolEffect(.pulse, options: .speed(3).repeat(.max), isActive: appStateManager.uiModel.isMobilePromoActive)
                .onTapGesture {
                    openURL(AppSettings.Constants.shareFreeVersionURL)
                    appStateManager.uiModel.isMobilePromoActive = false
                }
        }
    }
}
#endif
