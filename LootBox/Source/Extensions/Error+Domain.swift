//
//  Error+Domain.swift
//  LootBox
//
//  Created by Matej on 01/11/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

typealias DisplayableError = DisplayableMessage & Error

protocol DisplayableMessage {
    var localizedTitle: String { get }
    var localizedMessage: String { get }
}

enum AppError: DisplayableError {
    
    case generic
    case parse
    case mintFailed
    case export(localizedTitle: String? = nil, localizedMessage: String? = nil)
    case partialExport
    case emptyCanvas
    case noPhotoPermission
    case custom(title: String, message: String)
    case workspaceLoad
    case workspaceSave
    
    var localizedTitle: String {
        switch self {
        case .parse: return "alert_message_save_image_error"
        case .export(let title, _): return title ?? ""
        case .mintFailed: return ""
        case .generic: return "generic_error_title"
        case .partialExport: return "alert_export_warning_title"
        case .emptyCanvas: return ""
        case .noPhotoPermission: return ""
        case .custom(let title, _): return title
        case .workspaceLoad: return "generic_error_title"
        case .workspaceSave: return "generic_error_title"
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .generic: return ""
        case .parse: return ""
        case .export(_, let message): return message ?? ""
        case .mintFailed: return "alert_message_mint_failed"
        case .partialExport: return "alert_export_warning_message"
        case .emptyCanvas: return "alert_export_warning_empty_canvas_message"
        case .noPhotoPermission: return "alert_export_alert_no_permissions_message"
        case .custom(_, let message): return message
        case .workspaceLoad: return ""
        case .workspaceSave: return ""
        }
    }
}

// MARK: - Keychain

extension AppError {

    enum Keychain: Error {
        case noUserId
        case unexpectedData
        case unhandledError
    }
}

// MARK: - Login

extension AppError {
    
    enum Login: Error {
        case signInCanceled
        case signInFailed
    }
}
