//
//  DropHandler.swift
//  OpenNFT
//
//  Created by Matej on 19/03/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//
#if os(macOS)
import SwiftUI

struct DropViewHandler: DropDelegate {
    
    let destinationItem: TraitModel
    @Binding var traits: [TraitModel]
    @Binding var draggedTrait: TraitModel?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        // update zIndex based on layer position
        for (index, trait) in traits.enumerated() {
            trait.zIndex = -Double(index)
        }
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        Analytics.track(event: .dragDropEnd)
        draggedTrait = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard
            let draggedTrait,
            let fromIndex = traits.firstIndex(of: draggedTrait),
            let toIndex = traits.firstIndex(of: destinationItem),
            fromIndex != toIndex
        else {
            return
        }
        Analytics.track(event: .dragDropStart)
        withAnimation {
            // Swap Items
            self.traits.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
        }
    }
}
#endif
