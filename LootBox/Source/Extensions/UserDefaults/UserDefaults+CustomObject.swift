//
//  UserDefaults+CustomObject.swift
//  LootBox
//
//  Created by Matej on 11. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    @discardableResult
    func save<T:Encodable>(customObject object: T, inKey key: String) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
            return true
        } else {
            CustomLogger.log(type: .dataBase, message: "UserDefaults - Couldn't save object \(T.self)")
            return false
        }
    }
    
    func load<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                CustomLogger.log(type: .dataBase, message: "UserDefaults - Couldn't decode object")
                return nil
            }
        } else {
            CustomLogger.log(type: .dataBase, message: "UserDefaults - Couldn't find key")
            return nil
        }
    }
}
