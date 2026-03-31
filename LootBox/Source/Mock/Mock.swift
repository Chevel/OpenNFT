//
//  Mock.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

enum MockData {
   
    static func traits() -> [TraitModel] {
        [
            TraitModel(zIndex: 0),
            TraitModel(zIndex: 1),
            TraitModel(zIndex: 2),
            TraitModel(zIndex: 3),
            TraitModel(zIndex: 4),
            TraitModel(zIndex: 5),
            TraitModel(zIndex: 6),
            TraitModel(zIndex: -1)
    ]
    }
    
    static func trait() -> TraitModel {
        TraitModel(zIndex: 7)
    }

}
