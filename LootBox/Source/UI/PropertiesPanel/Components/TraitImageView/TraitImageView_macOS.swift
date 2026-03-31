//
//  TraitImageView.swift
//  LootBox
//
//  Created by Matej on 27. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct TraitImageView: View {
    
    let isSelected: Bool
    let image: Image
    let borderColor: Color

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .border(borderColor, width: isSelected ? 4 : 0)
    }
}
#endif
