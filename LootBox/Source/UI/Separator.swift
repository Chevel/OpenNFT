//
//  Separator.swift
//  LootBox
//
//  Created by Matej on 21. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct Separator: View {
    
    var color: Color = Color.Palette.Background.light
    
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(color)
    }
}
