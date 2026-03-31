//
//  Array+SafeAccess.swift
//  LootBox
//
//  Created by Matej on 07/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension Array {

    subscript (safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }

}
