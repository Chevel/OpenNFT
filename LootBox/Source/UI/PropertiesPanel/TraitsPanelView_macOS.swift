//
//  TraitsView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct TraitsPanelView: View {
    
    @EnvironmentObject private var appStateManager: AppStateManager
    
    var body: some View {
        macOSLayout
    }
    
    private var separator: some View {
        Rectangle().foregroundColor(.Palette.separator)
    }
}

// MARK: - macOS

private extension TraitsPanelView {
    
    var macOSLayout: some View {
        HStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 32, pinnedViews: []) {
                        AddTraitButton {
                            $appStateManager.traitsViewModel.traits.wrappedValue
                                .insert(TraitModel(zIndex: Double(appStateManager.traitsViewModel.traits.count)), at: 0)

                            Analytics.track(event: .addTraitButtonPressed)
                        }

                        ForEach(Array(appStateManager.traitsViewModel.traits.enumerated()), id: \.element) { index, _ in
                            TraitView(traitModel: $appStateManager.traitsViewModel.traits[index])
                                .background(Color.Palette.Background.light)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .circular))
                                .onDrag({
                                    appStateManager.traitsViewModel.draggedTrait = appStateManager.traitsViewModel.traits[index]
                                    return NSItemProvider(object: String(appStateManager.traitsViewModel.traits[index].id) as NSString)
                                })
                                .onDrop(of: [.text],
                                        delegate: DropViewHandler(
                                            destinationItem: appStateManager.traitsViewModel.traits[index],
                                            traits: $appStateManager.traitsViewModel.traits,
                                            draggedTrait: $appStateManager.traitsViewModel.draggedTrait)
                                )
                        }
                    }.padding(.top, 16)
                    Spacer()
                }
            }.padding(.bottom, 8)
            separator.frame(width: 1)
        }
    }
}
#endif

// Manual binding
// as long as traits array is the same count, the view will not be rendered
//                    ForEach(0 ..< appStateManager.traitsViewModel.traits.count, id: \.self) { index in
//                        TraitView(traitModel: Binding(get: {
//                            return appStateManager.traitsViewModel.traits[index]
//                        }, set: { newValue, _ in
//                            appStateManager.traitsViewModel.traits[index] = newValue
//                        })).frame(height: 237)
//                    }
