//
//  View+Placeholder.swift
//  LootBox
//
//  Created by Matej on 30. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension View {

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            placeholder(when: shouldShow, alignment: alignment) {
                Text(String(localized: LocalizedStringResource(stringLiteral: text)))
                    .foregroundColor(.gray)
            }
    }
}
