//
//  UpgradeButtonStyle.swift
//  LootBox
//
//  Created by Matej on 02/11/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct UpgradeButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 250, height: 45)
            .font(Font.Pallete.Button.big)
            .background(Color.Palette.primary)
            .foregroundStyle(Color.Palette.Foreground.secondary)
            .clipShape(Capsule(style: .circular))
    }
}
