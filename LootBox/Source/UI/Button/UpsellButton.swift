//
//  UpsellButtonStyle.swift
//  LootBox
//
//  Created by Matej on 2. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct UpsellButton: View {

    var title: String
    var action: EmptyClosure

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(String(localized: LocalizedStringResource(stringLiteral: title)))
                    .font(Font.Pallete.paywallText)
                    .padding(.all, 4)
                    .foregroundColor(Color.Palette.Foreground.primary)
                Spacer()
            }
        }
        .buttonStyle(UpsellButtonStyle())
    }
}


fileprivate struct UpsellButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.Pallete.paywallText)
            .foregroundColor(Color.Palette.Foreground.primary)
            .background(Color.Palette.tertiary)
            .clipShape(Capsule(style: .circular))
    }
}
