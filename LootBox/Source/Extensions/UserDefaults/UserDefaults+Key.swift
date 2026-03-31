//
//  OpenNftKey.swift
//  LootBox
//
//  Created by Matej on 18. 1. 25.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum OpenNftKey: String {
        case wasOnboardingShown
        case workspace
        case didInstallMobileVersion
    }
    
    enum OpenNftMacOSKey: String {
        case wasOnboardingShown
        case workspace
    }
}
