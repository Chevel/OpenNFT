//
//  Array+Remove.swift
//  LootBox
//
//  Created by Matej on 09/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove(trait: Element) {
        if let toRemove = firstIndex(where: { $0 == trait }) {
            remove(at: toRemove)
        }
    }
    
}
