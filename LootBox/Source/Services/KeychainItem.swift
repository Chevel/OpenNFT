/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct for accessing generic password keychain items.
*/

import Foundation

struct KeychainItem {

    // MARK: - Properties
    
    let service: Service
    let accessGroup: String?
    private(set) var account: String
    
    // MARK: - Init
    
    init(service: Service) {
        CustomLogger.log(type: .keychain, message: "SignIn problem", error: AppError.generic)

        self.service = service
        self.account = Self.account
        self.accessGroup = nil
    }
    
    // MARK: - Keychain access
    
    func readItem() throws -> String {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else {
            CustomLogger.log(type: .keychain, message: "read item", error: AppError.Keychain.noUserId)
            throw AppError.Keychain.noUserId
        }
        guard status == noErr else {
            CustomLogger.log(type: .keychain, message: "read item", error: AppError.Keychain.unhandledError)
            throw AppError.Keychain.unhandledError
        }
        
        // Parse the password string from the query result.
        guard
            let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            CustomLogger.log(type: .keychain, message: "read item", error: AppError.Keychain.unexpectedData)
            throw AppError.Keychain.unexpectedData
        }
        
        CustomLogger.log(type: .keychain, message: "read item")
        return password
    }
    
    func saveItem(_ userId: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = userId.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readItem()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                CustomLogger.log(type: .keychain, message: "save item", error: AppError.Keychain.unhandledError)
                throw AppError.Keychain.unhandledError
            }

            CustomLogger.log(type: .keychain, message: "save item")
        } catch AppError.Keychain.noUserId {
            /*
             No password was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                CustomLogger.log(type: .keychain, message: "save item", error: AppError.Keychain.unhandledError)
                throw AppError.Keychain.unhandledError
            }
            
            CustomLogger.log(type: .keychain, message: "save item")
        }
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            CustomLogger.log(type: .keychain, message: "delete item", error: AppError.Keychain.unhandledError)
            throw AppError.Keychain.unhandledError
        }
        
        CustomLogger.log(type: .keychain, message: "delete item")
    }
}

// MARK: - Interface

extension KeychainItem {

    static func getUserIdFromKeychain() throws -> (String, Service) {
        if let appleUserId = try? KeychainItem(service: .apple).readItem() {
            CustomLogger.log(type: .keychain, message: "load keychain item for \(Service.apple.rawValue)")
            return (appleUserId, .apple)
        } else if let googleUserId = try? KeychainItem(service: .google).readItem() {
            CustomLogger.log(type: .keychain, message: "load keychain item for \(Service.google.rawValue)")
            return (googleUserId, .google)
        }
        else if let facebookUserId = try? KeychainItem(service: .facebook).readItem() {
            CustomLogger.log(type: .keychain, message: "load keychain item for \(Service.facebook.rawValue)")
            return (facebookUserId, .facebook)
        }
        else if let redditUserId = try? KeychainItem(service: .reddit).readItem() {
            CustomLogger.log(type: .keychain, message: "load keychain item for \(Service.reddit.rawValue)")
            return (redditUserId, .reddit)
        } else {
            CustomLogger.log(type: .keychain, message: "failed loading keychain item", error: AppError.Keychain.noUserId)
            throw AppError.Keychain.noUserId
        }
    }

    static func deleteUserIdentifierFromKeychain() {
        Service.allCases.forEach {
            do {
                try KeychainItem(service: $0).deleteItem()
                CustomLogger.log(type: .keychain, message: "delete keychain item")
            } catch {
                CustomLogger.log(type: .keychain, message: "delete keychain item", error: error)
            }
        }
    }
}

// MARK: - Service

extension KeychainItem {

    enum Service: String, CaseIterable {
        case apple
        case google
        case facebook
        case reddit
    }
}

// MARK: - Helper

private extension KeychainItem {

    // Make sure the account name does **NOT** match the bundle identifier!
    private static let account = "com.opennft.signInWithApple.details"
    private static let server = "www.open-nft.tech"

    static func keychainQuery(withService service: Service, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service.rawValue as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
