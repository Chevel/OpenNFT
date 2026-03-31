//
//  CancelExportButton.swift
//  LootBox
//
//  Created by Matej on 16. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct CancelExportButton: View {

    var body: some View {
        Button {
            NftRenderer.shared.cancelExport()
        } label: {
            HStack {
                Spacer()
                Text("generic_cancel")
                    .font(Font.Pallete.infoText)
                    .padding(.all, 16)
                    .foregroundColor(Color.Palette.Foreground.primary)
                Spacer()
            }
        }
        .buttonStyle(CancelActionButtonStyle())
    }
}

fileprivate struct CancelActionButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(idealWidth: 150, maxWidth: 300, idealHeight: 50)
            .font(Font.Pallete.Button.big)
            .foregroundColor(Color.red)
            .background(Color.red)
            .clipShape(Capsule(style: .circular))
    }    
}
