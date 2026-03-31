//
//  TraitSettingsMenu.swift
//  OpenNFT
//
//  Created by Matej on 2. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct TraitSettingsMenu: View {
    
    @Binding var trait: TraitModel

    var body: some View {
        traitNameSettings.padding(8)
    }
}

// MARK: - UI

private extension TraitSettingsMenu {

    var traitNameSettings: some View {
        VStack(alignment: .leading) {
            Text("trait_settings_name_title")
                .font(Font.Pallete.infoText)
                .foregroundStyle(Color.Palette.Foreground.primary)

            TextField(String(localized: LocalizedStringResource(stringLiteral: "generic_untitled")), text: $trait.name)
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
