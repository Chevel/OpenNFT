//
//  BigActionButtonStyle.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct BigActionButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 240)
            .font(Font.Pallete.Button.big)
            .foregroundColor(color)
            .background(configuration.isPressed ? Color.Palette.primary : color)
            .clipShape(Capsule(style: .circular))
    }
}
