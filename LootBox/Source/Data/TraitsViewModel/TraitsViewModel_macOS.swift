//
//  TraitsViewModel.swift
//  LootBox
//
//  Created by Matej on 09/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import Foundation
import SwiftData

@Model
final class TraitsViewModel {
    
    // MARK: - Data

    var traits: [TraitModel] = [] {
        didSet {
            for (index, trait) in traits.enumerated() {
                trait.zIndex = -Double(index)
            }
        }
    }
    var draggedTrait: TraitModel? = nil
    
    // MARK: - SwiftData

    // Required by @Model
    init() {}
}
#endif
