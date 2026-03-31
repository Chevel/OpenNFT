//
//  OddsView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct OddsSliderView: View {
        
    @Binding var odds: Double
    var color: Color
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("trait_settings_odds")
            
            HStack {
                Slider(
                    value: $odds,
                    in: 0...100,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                ).tint(color)

                Text("\(odds, specifier: "%0.0f")%")
                    .foregroundColor(Color.Palette.Foreground.primary)
            }
        }
    }
}
#endif
