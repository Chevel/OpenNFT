//
//  ImagePickerButtonStyle.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct ImagePickerButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .clipShape(Rectangle())
    }
    
}
