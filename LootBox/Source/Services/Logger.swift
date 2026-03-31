//
//  CustomLogger.swift
//  LootBox
//
//  Created by Matej on 01/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation
import os.log

enum CustomLogger {

    // MARK: - Event

    enum Event {
        case export
        case imageCache
        case network
        case dataBase
        case login
        case keychain

        var symbol: String {
            switch self {
            case .export: return "🚚"
            case .imageCache: return "🖼"
            case .network: return "📡"
            case .dataBase: return "💾"
            case .login: return "🔑"
            case .keychain: return "🔐"
            }
        }
    }
    
    // MARK: - Interface
    
    static func log(type: Event, message: String, error: Error? = nil) {
#if DEBUG
        if let error = error {
            os.Logger().log(level: .error, "\(type.symbol) - \(message) with error: \(error.localizedDescription)")
        } else {
            os.Logger().log(level: .info, "\(type.symbol) - SUCCESS - \(message)")
        }
#endif
    }
}

