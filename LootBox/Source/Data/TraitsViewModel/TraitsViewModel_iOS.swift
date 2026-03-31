//
//  TraitsViewModel.swift
//  LootBox
//
//  Created by Matej on 09/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftData
import Foundation

@Model
final class TraitsViewModel {

    // MARK: - Data

    var traits: [TraitModel] = []
    var draggedTrait: TraitModel?
    
    // Required by @Model
    init() {}
        
    // MARK: - Remove
    
    func removeSelectedTrait() {
        guard let selectedTrait = traits.first(where: { $0.isSelected }) else { return }
        traits.remove(trait: selectedTrait)
    }

    // MARK: - Selection

    func deselectAll() {
        for (idx, _) in traits.enumerated() {
            traits[idx].isSelected = false
        }
    }

    func toggleTraitSelection(traitId: String) {
        for (idx, trait) in traits.enumerated() { // we need to access traits this way because otherwise we are changing copies of objects. don't ask...
            if trait.id == traitId {
                traits[idx].isSelected.toggle()
            } else {
                traits[idx].isSelected = false
            }
        }
    }
}

// MARK: - Computed

extension TraitsViewModel {
    
    var isTraitSelected: Bool {
        traits.contains(where: { $0.isSelected })
    }
    
    var selectedTrait: TraitModel? {
        traits.first(where: { $0.isSelected })
    }

    var hasValidData: Bool {
        !traits.isEmpty && !traits.contains(where: { $0.imagesData.isEmpty })
    }
}

#endif
