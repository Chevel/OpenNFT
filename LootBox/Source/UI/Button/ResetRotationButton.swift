//
//  ResetRotationButton.swift
//  LootBox
//
//  Created by Matej on 28. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct ResetRotationButton: View {
    
    static let size = CGSize(width: 30, height: 30)
    
    var body: some View {
        Image.SFSymbols.Edit.resizeReset
            .foregroundColor(Color.Palette.primary)
            .bold()
            .frame(width: Self.size.width, height: Self.size.height)
    }
}

#Preview {
    ResetRotationButton()
}


