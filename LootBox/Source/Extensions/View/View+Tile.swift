//
//  View+Tile.swift
//  LootBox
//
//  Created by Matej on 2. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension View {

    func tile<S: Shape>(_ shape: S, of size: CGSize, spacing: CGSize) -> some View {
        self.overlay(TilingShape(shape: shape, size: size, horizontalSpacing: 10, vericalSpacing: 10))
    }
}

struct TilingShape<S: Shape>: Shape {
    let shape: S
    let size: CGSize
    let horizontalSpacing: CGFloat
    let vericalSpacing: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for x in stride(from: CGFloat.zero, to: rect.size.width, by: size.width + horizontalSpacing) {
            for y in stride(from: CGFloat.zero, to: rect.size.height, by: size.height + vericalSpacing) {
                let r = CGRect(origin: CGPoint(x: x, y: y), size: size)
                path.addPath(shape.path(in: r))
            }
        }
        return path
    }
}
