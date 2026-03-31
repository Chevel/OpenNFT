//
//  ImageData.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import SwiftData

@Model
final class ImageViewModel {
    
    @Attribute(.unique) private(set) var id = UUID().uuidString
    @Attribute(.transformable(by: NSImageValueTransformer.self)) private(set) var nsImage: NSImage
    @Attribute(.transformable(by: NSColorValueTransformer.self)) private(set) var frameColor: NSColor

    @Transient var frameColorValue: Color {
        Color(cgColor: frameColor.cgColor)
    }
    var odds: Double
    private(set) var name: String

    var isSelected = false

    init(nsImage: NSImage, frameColor: Color, name: String) {
        self.nsImage = nsImage
        if let cgColor = frameColor.cgColor, let frameColor = NSColor(cgColor: cgColor) {
            self.frameColor = frameColor
        } else {
            self.frameColor = NSColor.green
        }
        self.odds = 45.0
        self.name = name
    }
}

// MARK: - Equatable

extension ImageViewModel: Equatable {
    
    static func == (lhs: ImageViewModel, rhs: ImageViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension ImageViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}

// MARK: - Convenience

extension ImageViewModel {

    var image: Image { Image(nsImage: nsImage) }
}

#endif
