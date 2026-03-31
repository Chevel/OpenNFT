//
//  NSImage+CGImage.swift
//  LootBox
//
//  Created by Matej on 23/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

#if os(macOS)
extension NSImage {
    
    var cgImage: CGImage? {
        var imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        return self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
    }
}
#endif
