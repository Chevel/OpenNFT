//
//  TraitEditView.swift
//  OpenNFT
//
//  Created by Matej on 26. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct TraitEditView: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    @State private var scale: Double = 1
    @State private var odds: Double = 1

    @Binding var trait: TraitModel
    
    var body: some View {
        VStack {
            selectedOptionMenuView
                .padding(16)
            optionsView
                .background(Color.Palette.Background.light)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .circular))
        }
    }
}

// MARK: - UI

private extension TraitEditView {

    @ViewBuilder
    var selectedOptionMenuView: some View {
        if let option = appStateManager.selectedOption {
            switch option {
            case .rotate: rotateSlider
            case .resize: scaleSlider
            default: EmptyView()
            }
        } else {
            EmptyView()
        }
    }
    
    var addTraitIconButton: some View {
        PhotosPickerView(view: EditOption.addImages.icon) { result in
            switch result {
            case .success(let images):
                let imageVMs = images.map { imageData in
                    ImageViewModel(nsImage: imageData.image, name: imageData.name)
                }
                trait.imagesData = imageVMs
                trait.respondToArrayUpdate()

            case .failure(let error):
                appStateManager.error = error
            }
        }
        .frame(width: 30, height: 30)
        .foregroundStyle(Color.Palette.Foreground.primary)
    }
    
    var resizeOptionIconButton: some View {
        EditOption.resize
            .icon
            .frame(width: 30, height: 30)
            .foregroundStyle(colorForOption(option: .resize))
            .onTapGesture {
                appStateManager.select(option: .resize)
            }
    }
    
    var rotateOptionIconButton: some View {
        EditOption.rotate
            .icon
            .frame(width: 30, height: 30)
            .foregroundStyle(colorForOption(option: .rotate))
            .onTapGesture {
                appStateManager.select(option: .rotate)
            }
    }
    
    var optionsView: some View {
        HStack {
            HStack(alignment: .center, spacing: 32) {
                addTraitIconButton
                resizeOptionIconButton
                rotateOptionIconButton
            }.padding(.leading, 16)

            Rectangle()
                .frame(width: 2, height: 40)
                .foregroundStyle(Color.Palette.Background.primary)
                .padding(16)
            
            HStack(spacing: 32) {
                EditOption.delete.icon
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.Palette.State.error)
                    .padding(.horizontal, 4)
                    .onTapGesture {
                        appStateManager.select(option: .delete)
                    }
                @Bindable var bindableManager = appStateManager
                EditOption.settings.icon
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.Palette.Foreground.primary)
                    .onTapGesture {
                        appStateManager.select(option: .settings)
                        appStateManager.isMoreMenuVisible = true
                    }
                    .sheet(isPresented: $bindableManager.isMoreMenuVisible, content: {
                        EditMoreMenu(trait: $trait)
                            .presentationDetents([.fraction(trait.imagesData.isEmpty ? 0.20 : 0.55)])
                            .presentationDragIndicator(.visible)
                            .presentationBackground(Color.Palette.Background.light)
                    })
                    .padding(.trailing, 8)
            }.padding(.trailing, 16)
        }
    }

    var scaleSlider: some View {
        HStack {
            Button(action: {
                scale = 1
                trait.resetScale()
            }, label: {
                Image.SFSymbols.Generic.cancel
                    .font(Font.Pallete.Button.small)
                    .padding(.trailing, 16)
                    .foregroundColor(Color.Palette.Foreground.primary)
            })
            Slider(value: $scale, in: 0.1...4).tint(Color.Palette.primary)
                .onChange(of: scale) { oldValue, newValue in
                    trait.resize(scale: newValue)
                }
            Button(action: {
                trait.completeEdit()
                appStateManager.select(option: nil)
                scale = 1
            }, label: {
                Image.SFSymbols.Generic.ok
                    .font(Font.Pallete.Button.small)
                    .padding(.leading, 16)
                    .foregroundColor(Color.Palette.Foreground.primary)
            })
        }
    }

    var rotateSlider: some View {
        HStack {
            Button(action: {
                trait.resetRotate()
            }, label: {
                Image.SFSymbols.Generic.cancel
                    .font(Font.Pallete.Button.small)
                    .padding(.trailing, 16)
                    .foregroundColor(Color.Palette.Foreground.primary)
            })
            Slider(value: $trait.rotationAngle, in: 0...360).tint(Color.Palette.primary)
            Button(action: {
                trait.completeEdit()
                appStateManager.select(option: nil)
            }, label: {
                Image.SFSymbols.Generic.ok
                    .font(Font.Pallete.Button.small)
                    .padding(.leading, 16)
                    .foregroundColor(Color.Palette.Foreground.primary)
            })
        }
    }
}

// MARK: - Computed

private extension TraitEditView {

    func colorForOption(option: EditOption) -> Color {
        guard let selectedOption = appStateManager.selectedOption else { return Color.Palette.Foreground.primary }
        return option == selectedOption ? Color.Palette.primary : Color.Palette.Foreground.primary
    }
}

#endif
