//
//  AppAlert.swift
//  LootBox
//
//  Created by Matej on 11. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

enum AppAlert: DisplayableMessage {

    case success

    var localizedTitle: String {
        switch self {
        case .success: return ""
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .success: return NSLocalizedString("alert_success", comment: "")
        }
    }
}
