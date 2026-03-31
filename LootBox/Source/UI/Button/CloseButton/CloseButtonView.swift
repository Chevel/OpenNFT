//
//  CloseButtonView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct CloseButtonView: View {
    
    static let size = CGSize(width: 30, height: 30)
    
    var body: some View {
        Circle()
            .frame(width: Self.size.width, height: Self.size.height)
            .foregroundColor(Color.Palette.Foreground.primary)
            .overlay {
                Image.SFSymbols.Button.close
                    .foregroundColor(Color.Palette.State.error)
            }
    }
}

struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView()
    }
}
#endif
