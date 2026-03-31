//
//  AppVersion.swift
//  LootBox
//
//  Created by Matej on 02/11/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//
import Foundation

enum AppSettings {
    
    static var isDevEnvironment: Bool {
#if DEV
        return true
#else
        return false
#endif
    }

#if os(macOS)
    enum Version {
        case basic, pro

        static var version: Version {
            #if PRO
            return .pro
            #else
            return .basic
            #endif
        }

        static var isPro: Bool {
            return version == .pro
        }
    }
    
    enum Feature {
        static var exportLimit: Int {
            switch AppSettings.Version.version {
            case .basic: return 9
            case .pro: return Int.max
            }
        }
        
        static var isTraitReorderSupported: Bool {
            true
        }
    }

#elseif os(iOS)
    enum Feature {
        static var traitLimit: Int = 4
        static var exportLimit: Int = 9
        static var traitSelectionLimit: Int = 3
    }
#endif

    enum Constants {
        static let exportWarningThreshold: Int = 500

        static let productHuntReviewURL = URL(string: "https://www.producthunt.com/products/opennft/reviews/new")!
        
        static let shareProVersionURL = URL(string: "https://apps.apple.com/us/app/opennft-pro/id6444143021")!

        static let shareFreeVersionURL = URL(string: "https://apps.apple.com/us/app/opennft/id6443635354")!
        
        static let appStoreProVersionURL = URL(string: "https://apps.apple.com/us/app/opennft-pro/id6444143021")!

        static func polygonscanForWalletURL(wallet: String) -> URL {
            if !wallet.isEmpty, let url = URL(string: "https://polygonscan.com/address/\(wallet)") {
                Analytics.track(event: .polygonWalletImagePressed)
                return url
            } else {
                Analytics.track(event: .polygonImagePressed)
                return URL(string: "https://polygonscan.com")!
            }
        }
        
        static var Mintky: String { Bundle.minterApiKey }
        static var LaunchDarkly: String { Bundle.launchDarklyApiKey }
    }
}
