//
//  ImagesGridView.swift
//  LootBox
//
//  Created by Matej on 11/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct ImagesGridView: View {
    
    @Binding var selectedImageUuid: String
    var iconTintColor: Color
    var imagesData: [ImageViewModel] = []
    var selectedImageAction: ((ImageViewModel) -> Void)
    
    private let vGridLayout = [
        GridItem(.adaptive(minimum: 45)),
        GridItem(.adaptive(minimum: 45)),
        GridItem(.adaptive(minimum: 45))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: vGridLayout) {
                if imagesData.isEmpty {
                    ForEach(0 ..< 60) { _ in
                        Rectangle()
                            .frame(width: 45, height: 45)
                            .overlay {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(iconTintColor)
                                    .padding(16)
                            }
                    }
                } else {
                    ForEach(imagesData, id: \.self) { model in
                        TraitImageView(isSelected: model.id == selectedImageUuid,
                                       image: model.image,
                                       borderColor: model.frameColorValue)
                        .frame(width: 45, height: 45)
                        .onTapGesture {
                            selectedImageUuid = model.id
                            selectedImageAction(model)
                        }
                    }
                }
            }
        }
    }
}
#endif
