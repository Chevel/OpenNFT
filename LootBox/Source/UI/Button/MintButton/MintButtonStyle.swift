//
//  MintButtonStyle.swift
//  LootBox
//
//  Created by Matej on 24/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct MintButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 200)
            .font(Font.Pallete.Button.big)
            .background(Color.Palette.primary)
            .foregroundStyle(Color.Palette.Foreground.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
}
