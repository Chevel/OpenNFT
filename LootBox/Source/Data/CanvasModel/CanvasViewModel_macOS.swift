//
//  CanvasViewModel.swift
//  LootBox
//
//  Created by Matej on 09/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import SwiftData

@Model
class CanvasViewModel {
    var canvasWidth: CGFloat = 600
    var canvasHeight: CGFloat = 800
    @Attribute(.transformable(by: NSColorValueTransformer.self)) var backgroundColor = NSColor.clear
    @Transient var backgroundColorValue: Color {
        Color(cgColor: backgroundColor.cgColor)
    }
    
    // Required by @Model
    init() {}
}

extension CanvasViewModel {
    
    var canvasSize: CGSize {
        CGSize(width: canvasWidth, height: canvasHeight)
    }
}
#endif
