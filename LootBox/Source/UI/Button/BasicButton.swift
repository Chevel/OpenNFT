//
//  UpsellButtonStyle.swift
//  LootBox
//
//  Created by Matej on 2. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct BasicButton: View {

    @Binding var isLoading: Bool
    var title: String
    var height: CGFloat?
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
                    .foregroundColor(Color.Palette.Background.primary)
                Spacer()
            }
            .frame(height: height)
        }
        .buttonStyle(BasicButtonStyle())
        .overlay {
            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.Palette.Background.primary)
            }
        }
        .opacity(isLoading ? 0.5 : 1)
        .disabled(isLoading)
    }
}

fileprivate struct BasicButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.Pallete.paywallText)
            .foregroundColor(Color.Palette.Background.primary)
            .background(Color.Palette.primary)
            .clipShape(Capsule(style: .circular))
    }
}
