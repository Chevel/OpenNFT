//
//  UpgradeButtonView.swift
//  LootBox
//
//  Created by Matej on 02/11/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct UpgradeButtonView: View {

    var body: some View {
        Button(action: {
            Analytics.track(event: .upgradeNowPressed)
            
#if os(macOS)
            NSWorkspace.shared.open(AppSettings.Constants.appStoreProVersionURL)
#elseif os(iOS)
            UIApplication.shared.open(AppSettings.Constants.appStoreProVersionURL)
#endif
            
        }, label: {
            HStack() {
                Spacer()
                HStack(spacing: 8) {
                    Text("settings_upgrade_button_title")
                        .font(Font.Pallete.infoText)
                    Image.SFSymbols.magic
                        .foregroundColor(Color.Palette.Foreground.secondary)
                        .frame(width: 20, height: 20)
                }
                Spacer()
            }
        }).buttonStyle(UpgradeButtonStyle())
    }

}

struct UpgradeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeButtonView()
    }
}
