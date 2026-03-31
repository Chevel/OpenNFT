//
//  ScreenType.swift
//  LootBox
//
//  Created by Matej on 21. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension AppStateManager {

    enum ScreenType: Identifiable, Hashable {

        // MARK: - Login

        case onboarding
        
        // MARK: - Main

        case main
    }
}

// MARK: - Identifiable

extension AppStateManager.ScreenType {

    var id: String {
        switch self {
        case .onboarding: return "onboarding"
        case .main: return "main"
        }
    }
}

