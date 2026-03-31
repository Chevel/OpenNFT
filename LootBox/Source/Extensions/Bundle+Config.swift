//
//  Bundle+Config.swift
//  LootBox
//
//  Created by Matej on 31. 3. 2026.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var revenueCatApiKey: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "REVENUE_CAT_API_KEY") as? String {
            return value
        } else {
            fatalError("Missing revenue cat api key")
        }
    }
    static var launchDarklyApiKey: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "LAUNCH_DARKLY_API_KEY") as? String {
            return value
        } else {
            fatalError("Missing launch darkly api key")
        }
    }
    static var minterApiKey: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "MINTER_API_KEY") as? String {
            return value
        } else {
            fatalError("Missing Mint api key")
        }
    }
    static var mixpanelApiKey_macOS: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_MACOS_API_KEY") as? String {
            return value
        } else {
            fatalError("Missing mixpanel api key")
        }
    }
    static var mixpanelApiKey_iOS: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_iOS_API_KEY") as? String {
            return value
        } else {
            fatalError("Missing mixpanel api key")
        }
    }
}
