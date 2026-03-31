//
//  Image+SFSymbols.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension Image {
    
    enum SFSymbols {
        static var magic = Image(systemName: "wand.and.stars.inverse").resizable()
        static var share = Image(systemName: "square.and.arrow.up").resizable()
        static var reorder = Image(systemName: "line.3.horizontal").resizable()
        static var star = Image(systemName: "star").resizable()
        static var account = Image(systemName: "person.crop.circle").resizable()
        
        static var lock = Image(systemName: "lock.fill").resizable()
        static var checkmarkSeal = Image(systemName: "checkmark.seal").resizable()
        
        static let pencilIcon = Image(systemName: "pencil")
        static let addTraitImages = Image(systemName: "photo.badge.plus")
        static let imagePlaceholder = Image(systemName: "photo")
        
        static let signInWithAppleIcon = Image(systemName: "applelogo")
        
        static let iPhone = Image(systemName: "iphone.radiowaves.left.and.right")
    }
}

// MARK: - Button

extension Image.SFSymbols {
    
    enum Button {
        static var close = Image(systemName: "xmark.circle.fill").resizable()
    }
}

// MARK: - Generic

extension Image.SFSymbols {

    enum Generic {
        static let ok = Image(systemName: "checkmark")
        static let cancel = Image(systemName: "xmark")
    }
}

// MARK: - Canvas

extension Image.SFSymbols {

    enum Canvas {
        static let magnify = Image(systemName: "magnifyingglass")
        static let magnifyMore = Image(systemName: "plus.magnifyingglass")
        static let magnifyLess = Image(systemName: "minus.magnifyingglass")
    }
}

// MARK: - Edit options

extension Image.SFSymbols {
    
    enum Edit {
        static let add = Image(systemName: "photo.on.rectangle").resizable()
        static let rotate = Image(systemName: "rectangle.landscape.rotate").resizable()
        static let resize = Image(systemName: "square.resize").resizable()
        static let resizeReset = Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90").resizable()
        static let delete = Image(systemName: "trash").resizable()
        static let more = Image(systemName: "ellipsis.circle").resizable()
        static let settings = Image(systemName: "slider.horizontal.3").resizable()
        static let layer = Image(systemName: "square.3.layers.3d.middle.filled").resizable()
        static let config = Image(systemName: "folder.fill.badge.gearshape").resizable()
        static let export = Image(systemName: "folder.fill").resizable()
    }
}
