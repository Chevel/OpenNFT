//
//  Color+Hex.swift
//  LootBox
//
//  Created by Matej on 21. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension Color {

    /// Creates color from RGB components in range 0-255
    /// - Parameters:
    ///   - r: Red component as value from 0-255
    ///   - g: Green component as value from 0-255
    ///   - b: Blue component as value from 0-255
    init(r: Int, g: Int, b: Int) {
       assert(r >= 0 && r <= 255, "Invalid red component")
       assert(g >= 0 && g <= 255, "Invalid green component")
       assert(b >= 0 && b <= 255, "Invalid blue component")

       self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0)
   }

    init(hex: Int) {
       self.init(
           r: (hex >> 16) & 0xFF,
           g: (hex >> 8) & 0xFF,
           b: hex & 0xFF
       )
   }
}
