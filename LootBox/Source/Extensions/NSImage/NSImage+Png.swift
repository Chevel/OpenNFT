//
//  NSImage+Png.swift
//  LootBox
//
//  Created by Matej on 01/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import AppKit

extension NSImage {
    
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
}
#endif
