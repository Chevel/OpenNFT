//
//  TraitEditHUD.swift
//  OpenNFT
//
//  Created by Matej on 9. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct TraitEditHUD: View {

    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            traitsEditMenu.padding(.bottom, 18)
            imagesGridView
        }
        .ignoresSafeArea(.keyboard)
        .ignoresSafeArea(edges: .bottom)
    }
}

private extension TraitEditHUD {
    
    @ViewBuilder
    var traitsEditMenu: some View {
        if let selectedTraitIndex = appStateManager.traitsViewModel.traits.firstIndex(where: { $0.isSelected }) {
            @Bindable var model = appStateManager
            TraitEditView(trait: $model.traitsViewModel.traits[selectedTraitIndex])
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var imagesGridView: some View {
        if let selectedTraitIndex = appStateManager.traitsViewModel.traits.firstIndex(where: { $0.isSelected }) {
            @Bindable var model = appStateManager

            ImagesGridView(
                selectedImageUuid: $model.traitsViewModel.traits[selectedTraitIndex].selectedImageUuid,
                iconTintColor: $model.traitsViewModel.traits[selectedTraitIndex].wrappedValue.frameColor,
                imagesData: $model.traitsViewModel.traits[selectedTraitIndex].wrappedValue.imagesData
            )
            .frame(height: 100)
            .overlay {
                if appStateManager.isLoadingPhotos {
                    Color.black.opacity(0.5)
                        .overlay {
                            ProgressView()
                            .controlSize(.large)
                            .tint(Color.Palette.primary)
                        }
                        .padding(.vertical, 5)
                }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    TraitEditHUD()
}
#endif
