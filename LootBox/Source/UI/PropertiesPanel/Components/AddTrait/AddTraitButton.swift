//
//  AddTraitButtonView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

#if os(macOS)
struct AddTraitButton: View {
    
    var buttonPressedAction: EmptyClosure
    
    var body: some View {
        Button(action: buttonPressedAction, label: {
            HStack {
                Spacer()
                Text("trait_settings_add_trait")
                    .multilineTextAlignment(.center)
                    .font(Font.Pallete.infoText)
                    .padding(.all, 16)
                    .foregroundColor(Color.Palette.Foreground.secondary)
                Spacer()
            }
        }).buttonStyle(BigActionButtonStyle(color: Color.Palette.primary))
    }
}

struct AddTraitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddTraitButton(buttonPressedAction: {
            
        })
    }
}
#endif
