//
//  Color+Pallete.swift
//  LootBox
//
//  Created by Matej on 01/11/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension Color {

    enum Palette {
        
        /// 89FF99
        static let primary = Color(hex: 0x89FF99)
        
        /// 27282d
        static let secondary = Color(hex: 0x27282d)
        
        // DD6CB1
        static let tertiary = Color(hex: 0xDD6CB1)
    
        /// 4E4E4F
        static let separator = Color(hex: 0x4E4E4F)
    }
}

extension Color.Palette {
    
    enum Background {
        static let primary = secondary
        
        /// 464a4c
        static let light = Color(hex: 0x464a4c)
    }
}

extension Color.Palette {
    
    enum Foreground {
        static let primary = Color.white
        static let secondary = Background.primary
    }
}

extension Color.Palette {
    
    enum State {
        static let success = Color.green
        static let warning = Color.yellow
        static let error = Color.red
    }
}
