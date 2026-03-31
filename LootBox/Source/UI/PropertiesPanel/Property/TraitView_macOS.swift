//
//  TraitView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct TraitView: View {

    @EnvironmentObject private var appStateManager: AppStateManager
    @Binding var traitModel: TraitModel

    // MARK: - UI

    var body: some View {
        VStack(spacing: 4) {
            traitNameFieldView
                .padding(.horizontal, 8)
            HStack {
                imagesGridView
                imagePickerView
            }
            .padding(.horizontal, 8)

            if let binding = $traitModel.imagesData.first(where: { $0.isSelected.wrappedValue })?.odds {
                raritySliderView(valueBinding: binding).padding(.horizontal, 16)
            }

            if !AppSettings.Feature.isTraitReorderSupported {
                LayerPositionStepperView(zIndex: $traitModel.zIndex)
            }
            
            if $traitModel.imagesData.first(where: { $0.isSelected.wrappedValue }) != nil {
                borderToggleView
            }
            
            Spacer()
        }
        .padding(.top, CloseButtonView.size.height + 16)
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    CloseButtonView()
                        .padding(8)
                        .onTapGesture {
                            Analytics.track(event: .removeTraitButtonPressed)
                            $appStateManager.traitsViewModel.traits.wrappedValue.remove(trait: traitModel)
                        }
                }
                Spacer()
            }
        )
        .overlay(
            VStack {
                ReorderButtonView()
                    .padding(.top, ReorderButtonView.size.height/2)
                    .opacity(AppSettings.Version.isPro ? 1 : 0.3)
                    .disabled(!AppSettings.Version.isPro)
                Spacer()
            }
        )
    }
    
    // MARK: - UI elements
    
    private var traitNameFieldView: some View {
        HStack {
            Text("trait_settings_name_title")
            TextField(String(localized: LocalizedStringResource(stringLiteral: "generic_untitled")), text: $traitModel.name)
        }
    }
    
    private var imagePickerView: some View {
        ImagePickerView(trait: traitModel) { data in
            // update trait section with selected images
            $traitModel.imagesData.wrappedValue = data
            
            traitModel.respondToArrayUpdate()
            
            // pre-select the first image from user selected images
            traitModel.selectedImageUuid = data.first?.id ?? ""
        }
        .frame(width: 150, height: 150)
        .padding(.top, 24)
    }
    
    private var imagesGridView: some View {
        ImagesGridView(
            selectedImageUuid: $traitModel.selectedImageUuid, 
            iconTintColor: traitModel.frameColorValue,
            imagesData: traitModel.imagesData
        ) {
            // update model based on the grid image selected by the user
            traitModel.selectedImageUuid = $0.id
        }.frame(height: 150).padding(.top, 24)
    }

    private func raritySliderView(valueBinding: Binding<Double>) -> some View {
        AnyView(OddsSliderView(odds: valueBinding, color: traitModel.frameColorValue))
    }
    
    private var borderToggleView: some View {
        Toggle(isOn: $traitModel.isFrameVisible) {
            Text("trait_settings_border_toggle")
        }.onChange(of: traitModel.isFrameVisible) { _, newValue in
            Analytics.track(event: .toggleTraitImageFramePressed)
            $traitModel.isFrameVisible.wrappedValue = newValue
        }
    }
}

struct TraitView_Previews: PreviewProvider {
    static var previews: some View {
        TraitView(traitModel: .constant(TraitModel(zIndex: 1)))
    }
}
#endif
