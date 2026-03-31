//
//  ImagePickerView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

#if os(macOS)
// https://stackoverflow.com/questions/60372608/swiftui-macosx-imagepicker
struct ImagePickerView: View {

    var trait: TraitModel
//    var selectedImage: Image? // If eneabled => Shows a preview of the selected image
    var selectedImageData: (([ImageViewModel]) -> Void)

    var body: some View {
        Button(action: {
            let openPanel = NSOpenPanel()
            openPanel.prompt = NSLocalizedString("dialog_select_images", comment: "")
            openPanel.allowsMultipleSelection = true
            openPanel.canChooseDirectories = false
            openPanel.canCreateDirectories = false
            openPanel.canChooseFiles = true
            openPanel.allowedContentTypes = [.image]
            openPanel.begin { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    let data = openPanel.urls.compactMap({
                        if let image = NSImage(contentsOf: $0) {
                            let imageNameWithoutFileTypeExtension: String
                            if let filenameSubsequence = $0.lastPathComponent.split(separator: ".").first {
                                imageNameWithoutFileTypeExtension = String(filenameSubsequence)
                            } else {
                                imageNameWithoutFileTypeExtension = $0.lastPathComponent
                            }
                            return ImageViewModel(nsImage: image, frameColor: trait.frameColorValue, name: imageNameWithoutFileTypeExtension)
                        }
                        return nil
                    })
                    selectedImageData(data)
                }
            }
        }, label: {
            Rectangle().overlay {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .font(Font.Pallete.infoText)
                    .foregroundColor(Color.Palette.Foreground.primary)
            }
        })
        .buttonStyle(ImagePickerButtonStyle())
//        // If eneabled => Shows a preview of the selected image, it works I just don't need it
//        // but I dont want to remove it :)
//        .overlay(content: {
//            if let selectedImage = selectedImage {
//                selectedImage
//                    .resizable()
//                    .scaledToFit()
//            }
//        })
        .foregroundColor(trait.frameColorValue)
        .background(trait.frameColorValue)
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(trait: TraitModel(zIndex: 1)) { imageData in
            print(imageData)
        }.frame(width: 150, height: 150)
    }
}
#endif
