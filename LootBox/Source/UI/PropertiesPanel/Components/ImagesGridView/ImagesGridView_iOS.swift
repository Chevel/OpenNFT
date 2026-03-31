//
//  ImagesGridView.swift
//  LootBox
//
//  Created by Matej on 11/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct ImagesGridView: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager

    @Binding var selectedImageUuid: String
    var iconTintColor: UIColor
    var imagesData: [ImageViewModel] = []
    
    var body: some View {
        if imagesData.isEmpty {
            EmptyView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(imagesData.enumerated()), id:\.element) { index, model in
                        TraitImageView(
                            isSelected: model.id == selectedImageUuid,
                            image: model.uiImage,
                            borderColor: Color(uiColor: iconTintColor)
                        )
                        .overlay {
                            if index >= AppSettings.Feature.traitSelectionLimit && !appStateManager.isUnlocked {
                                Color.black
                                    .opacity(0.8)
                                    .overlay {
                                        Image.SFSymbols.lock
                                            .resizable()
                                            .scaledToFit()
                                            .padding(16)
                                            .foregroundStyle(Color.Palette.tertiary)
                                    }
                            }
                        }
                        .onTapGesture {
                            guard appStateManager.isUnlocked || index < AppSettings.Feature.traitSelectionLimit else {
                                // basic user cannot select/edit images past 5th one
                                appStateManager.isPaywallShown = true
                                return
                            }
                            selectedImageUuid = model.id
                        }
                    }
                    if imagesData.count < 15 { // 15 = magic number to fill device width with placeholders
                        ForEach(0 ..< 15) { _ in
                            placeholder
                        }
                    }
                }
            }
        }
    }
    
    private var placeholder: some View {
        Rectangle()
            .foregroundStyle(Color.Palette.Background.light)
            .frame(width: 90, height: 90)
            .overlay {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .scaledToFit()
                    .foregroundStyle(Color(uiColor: iconTintColor))
            }
    }
}
#endif
